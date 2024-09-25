# serializer  
[官网](https://www.django-rest-framework.org/api-guide/serializers/)

## 基础使用
```
from rest_framework import serializers
class ShopSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shop
serializer = ModelSerializer(data={...})
serializer.is_valid(raise_exception=True)  # 会判断外键是否存在
serializer.save(**kwargs)  # 这个数据会覆盖掉原来的data, 并且可以设置一些read_only的数据
```
* 注意事项:
    * 不能把id放入
    * auto\_now\_add 无法修改, 但是在以前的版本里面，必须设置`read_only=True`
    * 如果是外键，使用 data = {'user':1}  # 不要直接用object
    * 如果外键是嵌套的model, save的时候需要把嵌套的字段进行覆盖
    * 嵌套的model要设置read\_only才有效
* 添加额外的数据: filed = serializers.ReadOnlyField(source="profile.avatar")
* 通用参数:
    help_text: 文档
    label: 标签
    allow_blank: False, 是否允许text为空值
    required: true, 是否允许不传
* 方法:
    * `to_representation`
        ```
        def to_representation(self, value):  # 展示用户数据
        ```
    * `save`
        save会根据有没有instance来调用 create 获取 update
        调用完以后，会把data里面的字段用instance重新去渲染
        return instance


## 源码剖析
```
// serializer.__new__
def __new__(cls, *args, **kwargs):
    if kwargs.pop('many', False):  # 如果传了many, 就会调用many_init
        return cls.many_init(*args, **kwargs)
    return super().__new__(cls, *args, **kwargs)
field.__new__
// class Field
    def __new__(cls, *args, **kwargs):
        """
        When a field is instantiated, we store the arguments that were used,
        so that we can present a helpful representation of the object.
        """
        instance = super().__new__(cls)
        instance._args = args
        instance._kwargs = kwargs
        return instance
// class BaseSerializer
def __init__(self, instance=None, data=empty, **kwargs):
    self.instance = instance
    if data is not empty:
        self.initial_data = data
    self.partial = kwargs.pop('partial', False)
    self._context = kwargs.pop('context', {})
    kwargs.pop('many', None)
    super().__init__(**kwargs)
```
## 如何把用户的字典变成了`validated_data`
1. `to_internal_value`
```
for field in fields:
    primitive_value = field.get_value(data)
    # set_value(ret, field.source_attrs, validated_value)
```

2. `rest_framework.fields.get_value`
```
return dictionary.get(self.field_name)
```

3. `rest_framework.fields.Field.field_name`
```{warning}
# field_name的来源，在field.bind serializer的时候设置的
# serializer调用BindingDict, __setitem__的时候会调用Bind
# BindingDict在调用_get_declared_fields的时候是直接传入的attrs的属性，所以无法变更外部的属性适配serializer
```

3. `rest_framework.fields.set_value`
set_value支持传入字典, 所以关键看`source_attrs`怎么确认的
```
set_value({'a': 1}, [], {'b': 2}) -> {'a': 1, 'b': 2}
set_value({'a': 1}, ['x'], 2) -> {'a': 1, 'x': 2}
set_value({'a': 1}, ['x', 'y'], 2) -> {'a': 1, 'x': {'y': 2}}
```

3. `Field.source_attrs`
```
if self.source == "*":
    self.source_attrs = []
else:
    self.source_attrs = self.source.split('.')
```

## [Validation](https://www.django-rest-framework.org/api-guide/serializers/#validation)
在获取data前，需要先调用`is_valid`函数。如果失败了 `.errors` 里面是一个字典，每个key就是报错的字段, 对应的values是一个string构成的列表，表明这个数据不符合哪个规则
如果希望校验的时候直接报错，可以使用`is_valid(raise_exception=True)`
* 源码
```python3
def is_valid(self, raise_exception=False):
    assert not hasattr(self, 'restore_object'), (
        'Serializer `%s.%s` has old-style version 2 `.restore_object()` '
        'that is no longer compatible with REST framework 3. '
        'Use the new-style `.create()` and `.update()` methods instead.' %
        (self.__class__.__module__, self.__class__.__name__)
    )

    assert hasattr(self, 'initial_data'), (
        'Cannot call `.is_valid()` as no `data=` keyword argument was '
        'passed when instantiating the serializer instance.'
    )

    if not hasattr(self, '_validated_data'):
        try:
            self._validated_data = self.run_validation(self.initial_data)
        except ValidationError as exc:
            self._validated_data = {}
            self._errors = exc.detail
        else:
            self._errors = {}

    if self._errors and raise_exception:
        raise ValidationError(self.errors)

    return not bool(self._errors)
```

* 记录客户端的报错
```
from rest_framework.exceptions import ValidationError
serializer = self.get_serializer(request.data)
is_valid = serializer.is_valid()
if not is_valid:
    log.error("客户端数据报错")
    log.error(serializer.errors)
    raise ValidationError(serializer.errors)
```


### [ ] Field-level validation
### [Object-level validation](https://www.django-rest-framework.org/api-guide/serializers/#object-level-validation)

在所有的默认validate和自定义的`validate_field`都成功后才调用,用来校验整体的数据一致性.  
```
def validate(self, data):
    if data['start'] > data['finish']:
        raise serializers.ValidationError("finish must occur after start")
    return data  # 这个data必须返回。返回后会当作serializer的 _validated_data
```

### validators
* 源码剖析
```
self.run_validation(self, data=empty) =>
  self.run_validators(value) =>
    Field.run_validators:
      for validator in self.validators:
        validator(value)
```

## 属性和方法

### context
    ```
    {'view': <views.DetailView object>,
     'format': None,
     'request': <rest_framework.request.Request object>}
    ```

### data  
访问了这个属性以后，就无法再调用save函数了，所以如果要之前看data，必须使用`validated_data`
```
@property
def data(self)
    if hasattr(self, 'initial_data') and not hasattr(self, '_validated_data'):
        msg = (
            'When a serializer is passed a `data` keyword argument you '
            'must call `.is_valid()` before attempting to access the '
            'serialized `.data` representation.\n'
            'You should either call `.is_valid()` first, '
            'or access `.initial_data` instead.'
        )
        raise AssertionError(msg)

    if not hasattr(self, '_data'):
        if self.instance is not None and not getattr(self, '_errors', None):
            self._data = self.to_representation(self.instance)
        elif hasattr(self, '_validated_data') and not getattr(self, '_errors', None):
            self._data = self.to_representation(self.validated_data)
        else:
            self._data = self.get_initial()
    return self._data
```

### errors
返回serializer的errors
```
@property
def errors(self):
    if not hasattr(self, '_errors'):
        msg = 'You must call `.is_valid()` before accessing `.errors`.'
        raise AssertionError(msg)
    return self._errors
```

### fields
```
返回一个 BindingDict {'text': Field }
```

### run_validation
```
def run_validation(self, data=empty)
    """
    We override the default `run_validation`, because the validation
    performed by validators and the `.validate()` method should
    be coerced into an error dictionary with a 'non_fields_error' key.
    """
    (is_empty_value, data) = self.validate_empty_values(data)
    if is_empty_value:
        return data

    value = self.to_internal_value(data)
    try:
        self.run_validators(value)
        value = self.validate(value)
        assert value is not None, '.validate() should return the validated data'
    except (ValidationError, DjangoValidationError) as exc:
        raise ValidationError(detail=as_serializer_error(exc))

    return value
```

### to_internal_value
```
def to_internal_value(self, data):
    """
    Dict of native values <- Dict of primitive datatypes.
    """
    if not isinstance(data, Mapping):
        message = self.error_messages['invalid'].format(
            datatype=type(data).__name__
        )
        raise ValidationError({
            api_settings.NON_FIELD_ERRORS_KEY: [message]
        }, code='invalid')

    ret = OrderedDict()
    errors = OrderedDict()
    fields = self._writable_fields

    for field in fields:
        validate_method = getattr(self, 'validate_' + field.field_name, None)
        primitive_value = field.get_value(data)
        try:
            validated_value = field.run_validation(primitive_value)
            if validate_method is not None:
                validated_value = validate_method(validated_value)
        except ValidationError as exc:
            errors[field.field_name] = exc.detail
        except DjangoValidationError as exc:
            errors[field.field_name] = get_error_detail(exc)
        except SkipField:
            pass
        else:
            set_value(ret, field.source_attrs, validated_value)

    if errors:
        raise ValidationError(errors)

    return ret
```

### `validate_<field_name>`:
校验某个字段,这个字段是已经通过序列化转化的数据，所以是校验后才会调用
* 如果是update的，此时可以通过self.instance拿到旧的数据方便对比
```
def validate_even(self, value):
    if value % 2 != 0:
        raise serializers.ValidationError("不是偶数")
    return value
```

### `validated_data`:  
返回格式化的数据，注意*如果是外键，会变成model的instance*

### `to_representation`(self, instance/validated_data)  
* 使用情景
    ```
    # 如果要根据不同的instance返回不同的字段怎么办。比如高私密文件就不能看detail
    def to_representation(self, instance):
        if self.context['request'].user.level >= instance.level:
            pass
        else:
            self.fields.pop('detail')
        return super(Serializer, self).to_representation(instance)
    ```
* 源码剖析  
如何返回的dict  


    ret = OrderedDict()
    fields = self._readable_fields
    for field in fields:
        attribute = field.get_attribute(instance)
        ret[field.field_name] = field.to_representation(attribute)
    return ret

### save
```
def save(self, **kwargs):
    validated_data = dict(
        list(self.validated_data.items()) + 
        list(kwargs.items())
    )
    if self.instance is not None:
        self.instance = self.update(self.instance, validated_data)
    else:
        self.instance = self.create(validated_data)
        assert self.instance is not None, (
            '`create()` did not return an object instance.'
        )
    return self.instance
def create(self, validated_data):  # 如果你自定了create方法，一般来说你也需要自定义to_representation方法
    instance = ModelClass.objects.create(**validated_data)
    return instance
```


### update
```
def update(self, instance, validated_data):
    raise_errors_on_nested_writes('update', self, validated_data)
    info = model_meta.get_field_info(instance)

    # Simply set each attribute on the instance, and then save it.
    # Note that unlike `.create()` we don't need to treat many-to-many
    # relationships as being a special case. During updates we already
    # have an instance pk for the relationships to be associated with.
    for attr, value in validated_data.items():
        if attr in info.relations and info.relations[attr].to_many:
            field = getattr(instance, attr)
            field.set(value)
        else:
            setattr(instance, attr, value)
    instance.save()

    return instance
```
## meta
```
    read_only_fields = ["username", "is_staff"]  # 哪些属性不能修改，不过如果指定了field，必须在field里面加read_only
    write_only_fields = ???  # 这个属性不存在，可惜了
    fields = "__all__"  # 不会把method的属性放进去，如果放进去了，那也只是read_only的
    exclude = ["is_superuser", "is_active"]
    extra_kwargs = {
        "password": {'write_only': True}
    }
```

## [Fields](https://www.django-rest-framework.org/api-guide/fields/)
### 源码剖析
```python
class Field:
    def get_value(self, dictionary: dict):
        return dictionary.get(self.field_name, empty)

        # field_name的来源，在field.bind serializer的时候设置的
        # serializer调用BindingDict, __setitem__的时候会调用Bind
        # BindingDict在调用_get_declared_fields的时候是直接传入的attrs的属性，所以无法变更外部的属性适配serializer
```

### [core arguments核心参数](https://www.django-rest-framework.org/api-guide/fields/#core-arguments)
* [ ] read_only
* [ ] write_only
* [ ] required
* [ ] default
有了default以后，如果没有传入值，就会设置成default。哪怕传入了None或者"",也会使用None或者""
* [ ] allow_null
* [source](https://www.django-rest-framework.org/api-guide/fields/#source)
    1. [ ] method that only takes a self argument like `URLField(source='get_absolute_url')`
    2. [ ] dotted notation to traverse attributes like `EmailField(source='user.email')`  

    如果user是None, 会报错, 所以要设置一个default

    3. [ ] `source="*"` means entire object should be passed through to the field
    4. [ ] 如果不设置 `read_only=True` 在, save的时候要处理好这个数据
    ```
    name = CharField(source="user.name")
    source = 'user.name'  如果写入的话，数据是这样 {'user': {'name': 'new name'}}, 而不是直接的{'user': 'new name'}
    ```
    * 源码剖析
    ```
    在Serializer.to_internal_value的时候
    for field in fields:
        set_value(ret, field.source_attrs, validated_value)
    这样就会把
    data: {
      'user_name': 'xiaoming'
    }变成
    {
      'user': User(Xiao Ming)
    }
    ```
* [ ] validators
* [ ] error_messages
* [ ] label
* [ ] help_text
* [ ] initial
* [ ] style

### [CharField](http://www.django-rest-framework.org/api-guide/fields/#charfield)
每秒大概可以转化 3E6 条数据
    * 参数
        * `trim_whitespace`: *默认`True`, 把字符的前后空白字符删除*
        * `max_length`, `min_length`, `allow_blank`, `trim_whitespace`, `allow_null`
### EmailField
### [RegexField](http://www.django-rest-framework.org/api-guide/fields/#regexfield)
```
regex=r'^tmp-\d+\'
```
* SlugField
* URLField
* UUIDField
* FilePathField
* IPAddressField
* [PrimaryKeyRelatedField](http://www.django-rest-framework.org/api-guide/relations/#primarykeyrelatedfield)
用来代表外键, 当request.data输入进去后, validated_data得到的是一个model的Instance
    * 基础使用
        users = serializers.PrimaryKeyRelatedField(many=True)
    * 参数
        * many=True, 允许传入多个
        * allow_null=False, 如果设置了many=True的话，这个设置就没有效果了
        * queryset, 从那个queryset里面搜索
* BooleanField
    * **注意: 由于html里面，当你不选择那个checkbox的时候，就会不传递这个值。所以当你如果用form post的时候，就算没有参数，`rest-framework`也会当成False处理。**
    * 务必看源码
    * 会变成True的值: `字符串: true, True, 1,; 布尔值: True; 数字: 1`
    * 会变成False的值: `字符串: False, false, 0; 布尔值: False; 数字: 0`
    * 其他就会报错
* NullBooleanField

### [IntegerField](http://www.django-rest-framework.org/api-guide/fields/#integerfield)
实际上django的默认id用的是`Integer(label='ID', read_only=True)`, 因为有了`read_only`的存在,所以会不修改  
`min_value`和`max_value`可以用来代表数值大小的约束
```
    serializer.IntegerField(max_value=None, min_value=None)
```

* FloatField
* DecimalField
    * max_digits
    * decimal_places
    * coerce_to_string
    * rounding: 四舍五入的方式

### DateTimeField
* `auto_now_add`
没有`auto_now_add`这个参数。必须model里面存在`auto_now_add`  
如果model里面有`auto_now_add`参数，那么就无视任何前端传递的值，变成hiddenfield了  
* 可以接受django的datetime当作data传入
* `input_formats`
默认['iso-8601']. 如果包含'%Y-%m-%d', 那么输入日期进去也可以，会变成当天的0点(local的)
* 源码剖析
```
def to_inernal_value(self, value):
    input_formats = getattr(self, 'input_formats', api_settings.DATETIME_INPUT_FORMATS)

    # 支持直接是datetime
    if isinstance(value, datetime.date) and not isinstance(value, datetime.datetime):
        self.fail('date')

    if isinstance(value, datetime.datetime):
        return self.enforce_timezone(value)

    # 尝试用各种去解析
    for input_format in input_formats:
        if input_format.lower() == ISO_8601:
            try:
                parsed = parse_datetime(value)  # 用的是django的dateparse.parse_datetime
                if parsed is not None:
                    return self.enforce_timezone(parsed)  # 然后强制datetime
            except (ValueError, TypeError):
                pass
        else:
            try:
                parsed = self.datetime_parser(value, input_format)
                return self.enforce_timezone(parsed)
            except (ValueError, TypeError):
                pass

    humanized_format = humanize_datetime.datetime_formats(input_formats)
    self.fail('invalid', format=humanized_format)

def enforce_timezone(parsed):
    """
    如果没有开启USE_TZ就会返回None. 从而导致field_timezone = None
    When `self.default_timezone` is `None`, always return naive datetimes.
    When `self.default_timezone` is not `None`, always return aware datetimes.
    """
    field_timezone = getattr(self, 'timezone', self.default_timezone())

    if field_timezone is not None:
        if timezone.is_aware(value):
            try:
                return value.astimezone(field_timezone)
            except OverflowError:
                self.fail('overflow')
        try:
            return timezone.make_aware(value, field_timezone)
        except InvalidTimeError:
            self.fail('make_aware', timezone=field_timezone)
    elif (field_timezone is None) and timezone.is_aware(value):
        return timezone.make_naive(value, utc)
    return value

def default_timezone(self):
    return timezone.get_current_timezone() if settings.USE_TZ else None

def django.utils.dateparse.parse_datetime(value):
    "2020-06-10T03:45:13.026Z" => "datetime.datetime(2020, 6, 10, 3, 45, 13, 26000, tzinfo=<UTC>)"
    
    ```
* [ ] DateField
* DurationField  
[官网](https://www.django-rest-framework.org/api-guide/fields/#durationfield)  
返回的数据格式是: `[DD] [HH:[MM:]]ss[.uuuuuuu]`
* [ChoiceField](http://www.django-rest-framework.org/api-guide/fields/#choicefield)
    * `choices`: [('0', 'enabled'), ('1', 'disabled')]
* MultipleChoiceField
* SerializerMethodField
    * 使用methodfield来做一些函数的操作，比如班级的序列化类，只看里面有哪些班干部(默认是返回所有学生). 如果不return, 会变成None
    ```
    good_student = serializers.SerializerMethodField(read_only=True)

    def get_good_student(self, obj):
        return obj.students(is_class_leader=True)
    ```
* SlugRelatedField
    * 案例
    ```
    # 输入的是name，但是会根据username去搜索，返回一个user对象出来
    name = serializers.SlugRelatedField(queryset=User.objects.all(), slug_field="username")
    ```
    * 源码剖析
    ```
    def __init__(self, slug_field=None, **kwargs):
        assert slug_field is not None, 'The `slug_field` argument is required.'
        self.queryset = kwargs["queryset"]
        self.slug_field = slug_field
        super().__init__(**kwargs)

    def to_internal_value(self, data):
        try:
            return self.get_queryset().get(**{self.slug_field: data})
        except ObjectDoesNotExist:
            self.fail('does_not_exist', slug_name=self.slug_field, value=smart_str(data))
        except (TypeError, ValueError):
            self.fail('invalid')

    def to_representation(self, obj):
        return getattr(obj, self.slug_field)
    ```

* [ListField](https://www.django-rest-framework.org/api-guide/fields/#listfield)  
```
advantages = serializers.ListField(child=serializers.CharField())
or
class StringListField(serializers.ListField): # 写成declarative格式,来方便复用这个listfield
    child = serializers.CharField()
```
    * `child`
    * `allow_empty`: 默认为True, 可以上传空数据, 注意这个不代表可以不穿这个参数
    * `min_length`
    * `max_length`
* DictField
* JSONField
    ```
    # 别用，因为mysql，sqlite不支持json，所以储存的时候会直接把json数据str保存进去。用我自己创建的 MyJSONField
    class MziiyJSONField(serializers.Field):
        default_error_messages = {
            'invalid': 'Value must be valid JSON.'
        }

        def to_internal_value(self, data):
            # 暂时只支持对象吧。我够用了。后面的人如果要支持列表自己修改
            if not isinstance(data, dict):
                self.fail('invalid')
            return json.dumps(data)

        def to_representation(self, value):
            return json.loads(value)
    ```
* FileField
    * `use_url=False` 这样就不会被渲染成url了，因为大部分都是用media处理，这个url生成的方式完全不对
* ImageField
* ReadOnlyField
* HiddenField
```
只是用来显示，不需要用户传递的数据。包含default的
```
* ModelField

### [自定义序列化类](https://www.django-rest-framework.org/api-guide/fields/#custom-fields)

```python
class MySerializer(serializers.Field):
    def to_internal_value(self, data):
        # 把传递过来的数据转化成python可以用的数据。
        pass
    def to_representation(self, value):
        # 把pyhton的值转化成用于显示的值。在create的时候，会先调用to_internal_value，然后save，然后调用to_representation
        pass
```

* 属性
    context
        {'view': object, 'request': object} 可以获取上下文
    parent
        可以获取field的序列化类

* #### 嵌套的序列化类
这种嵌套的需要B本来就有A的`manytomany`或者`a_set`的字段。如果需要过滤的话就要手动写method

```python
class ASerializer:
    ...
class BSerializer:
    as = ASerializer(many=True)
    # 这个时候如果要save，必须手动修改BSerializer的save函数，并且内部得到的 as 里面每个对象都是一个OrderedDict, 而不是序列化类的instance
```

## 进阶
```
    TestPermissionSerializer(serializers.ModelSerializer):
        class Meta:
            model = models.TestPermission
            fields = ["id", "date", "detail", "user"]
            read_only_fields = ["user"]

    TestPermissionSerializer2(TestPermissionSerializer):
        class Meta(TestPermissionSerializer.Meta):
            fields = TestPermissionSerializer.Meta.fields + ["extra"]
            read_only_fields = TestPermissionSerializer.Meta.read_only_fields + "date"]
```

## 序列化类的继承
* `class CSerializer(ASerializer, BSerializer)`: 对于A和B都有的field，C会继承第一个class的（既A的)


## ModelSerializer(rest_framework.serializers.ModelSerializer)

### 源码剖析
```
modelserializer调用get_field_kwargs
get_field_kwargs调用get_unique_validators
get_unique_validators看 1 UniqueConstraint 2 unique=True
最后返回 UniqueValidator(queryset=queryset)
validate的时候会简单的filter_queryset
所以如果你用many插入多个重复的并不会报错
大小写也区分, 需要不区分的话可以加索引
CREATE UNIQUE INDEX "unique_lower_name" ON "test" (LOWER("name"))
```
* 方法
    * [ ] `build_standard_field(self, field_name, model_field)` 这个方法知道作用,但是还没细看函数的作用方式.之后认真看看
    ```
    self.build_standard_field(self, "id", django.db.models.fields.AutoField):
        return {
            rest_framework.fields.IntegerField,
            {"label": "ID", "read_only": True}
        }
    ```

## Field
* run_validation(data)  
把data的数据校验后返回，经常用于SlugField().run_validation(data)
