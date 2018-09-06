** Xiang Wang @ 2016-09-28 15:54:49 **

# 目录
* [django-reference](../README.md)
    * [rest-framework](./README.md)
        * [filter](./filter.md)
        * [request_and_response](./request_and_response.md)
        * serializer
        * [view.md](./view.md)


# 基础使用
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


# 属性和方法
## context
    ```
    {'view': <views.DetailView object>,
     'format': None,
     'request': <rest_framework.request.Request object>}
    ```

## data  
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

## fields
    ```
    返回一个 BindingDict {'text': Field }
    ```

## `validate_<field_name>`:
校验某个字段,这个字段是已经通过序列化转化的数据，所以是校验后才会调用

## `validated_data`:  
返回格式化的数据，注意如果是外键，会变成model的instance  

## `to_representation`(self, instance/validated_data)  
如果直接在`is_valid`后调用`.data`就会导致输入是OrderedDict而不是instance
    ```
    # 返回数据

    # 如果要根据不同的instance返回不同的字段怎么办。比如高私密文件就不能看detail
    def to_representation(self, instance):
        if self.context['request'].user.level >= instance.level:
            pass
        else:
            self.fields.pop('detail')
        return super(Serializer, self).to_representation(instance)
    ```

## `validate`(self, data)  
在所有的默认validate和自定义的validate_field都成功后才调用,用来校验整体的数据一致性

## save
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

## update
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
# meta
```
    read_only_fields = ["username", "is_staff"]  # 哪些属性不能修改，不过如果指定了field，必须在field里面加read_only
    write_only_fields = ???  # 这个属性不存在，可惜了
    fields = "__all__"  # 不会把method的属性放进去，如果放进去了，那也只是read_only的
    exclude = ["is_superuser", "is_active"]
    extra_kwargs = {
        "password": {'write_only': True}
    }
```

# [Fields](https://www.django-rest-framework.org/api-guide/fields/)
* ## [core arguments核心参数](https://www.django-rest-framework.org/api-guide/fields/#core-arguments)
    * [ ] read_only
    * [ ] write_only
    * [ ] required
    * [ ] default
    * [ ] allow_null
    * [source](https://www.django-rest-framework.org/api-guide/fields/#source)
        1. [ ] method that only takes a self argument like `URLField(source='get_absolute_url')`
        2. [ ] dotted notation to traverse attributes like `EmailField(source='user.email')`  
        如果user是None, 不会报错，返回None
        3. [ ] `source="*"` means entire object should be passed through to the field
    * [ ] validators
    * [ ] error_messages
    * [ ] label
    * [ ] help_text
    * [ ] initial
    * [ ] style
* [CharField](http://www.django-rest-framework.org/api-guide/fields/#charfield)
    * 参数
        * `trim_whitespace`: *默认`True`, 把字符的前后空白字符删除*
        * `max_length`, `min_length`, `allow_blank`, `trim_whitespace`, `allow_null`
* EmailField
* [RegexField](http://www.django-rest-framework.org/api-guide/fields/#regexfield)
```
regex=r'^tmp-\d+\'
```
* SlugField
* URLField
* UUIDField
* FilePathField
* IPAddressField
* [PrimaryKeyRelatedField](http://www.django-rest-framework.org/api-guide/relations/#primarykeyrelatedfield)
    * 基础使用
        users = serializers.PrimaryKeyRelatedField(many=True)
    * 参数
        * many=True, 允许传入多个
        * allow_null=False, 如果设置了many=True的话，这个设置就没有效果了
        * queryset, 从那个queryset里面搜索
* BooleanField
    * **注意: 由于html里面，当你不选择那个checkbox的时候，就会不传递这个值。所以当你如果用form post的时候，就算没有参数，`rest_framework`也会当成False处理。**
    * 务必看源码
    * 会变成True的值: `字符串: true, True, 1,; 布尔值: True; 数字: 1`
    * 会变成False的值: `字符串: False, false, 0; 布尔值: False; 数字: 0`
    * 其他就会报错
* NullBooleanField
* [IntegerField](http://www.django-rest-framework.org/api-guide/fields/#integerfield)
    serializer.IntegerField(max_value=None, min_value=None)
* FloatField
* DateTimeField
没有`auto_now_add`这个参数。必须model里面存在`auto_now_add`
如果model里面有`auto_now_add`参数，那么就无视任何前端传递的值，变成hiddenfield了
* DateField
* DurationField
* [ChoiceField](http://www.django-rest-framework.org/api-guide/fields/#choicefield)
    * `choices`: [('0', 'enabled'), ('1', 'disabled')]
* MultipleChoiceField
* SerializerMethodField
    * 使用methodfield来做一些函数的操作，比如班级的序列化类，只看里面有哪些班干部(默认是返回所有学生)
    ```
    good_student = serializers.SerializerMethodField(read_only=True)

    def get_good_student(self, obj):
        return obj.students(is_class_leader=True)
    ```
* SlugRelatedField
    ```
    # 输入的是name，但是会根据username去搜索，返回一个user对象出来
    name = serializers.SlugRelatedField(queryset=User.objects.all(), slug_field="username")
    ```
* ListField  
    `advantages = serializers.ListField(child=serializers.CharField())`
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

* 自定义序列化类
    ```
    class MySerializer(serializers.Field):
        def to_internal_value(self, data):
            # 把传递过来的数据转化成python可以用的数据。
            pass
        def to_representation(self, data):
            # 把pyhton的值转化成用于显示的值。在create的时候，会先调用to_internal_value，然后save，然后调用to_representation
            pass
    ```
* 属性
    context
        {'view': object, 'request': object} 可以获取上下文
    parent
        可以获取field的序列化类
* 嵌套的序列化类
这种嵌套的需要B本来就有A的`manytomany`或者`a_set`的字段。如果需要过滤的话就要手动写method
    ```
    class ASerializer
    class BSerializer:
        as = ASerializer(many=True)
    这个时候如果要save，必须手动修改BSerializer的save函数，并且内部得到的 as 里面每个对象都是一个OrderedDict, 而不是序列化类的instance
    ```


# 自定义序列化类

# 进阶
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

# 序列化类的继承
* `class CSerializer(ASerializer, BSerializer)`: 对于A和B都有的field，C会继承第一个class的（既A的)
