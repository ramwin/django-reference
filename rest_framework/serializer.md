#### Xiang Wang @ 2016-09-28 15:54:49


# Serializer

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
        def to_representation(self, value):  # 展示用户数据
    * `save`
        save会根据有没有instance来调用 create 获取 update
        调用完以后，会把data里面的字段用instance重新去渲染
        return instance

## meta:
```
    fields = "__all__"
    exclude = ["is_superuser", "is_active"]
    extra_kwargs = {
        "password": {'write_only': True}
    }
```

## Fields
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

* PrimaryKeyRelatedField

    * 基础使用
        users = serializers.PrimaryKeyRelatedField(many=True)

    * 参数
        * many=True, 允许传入多个
        * allow_null=False, 如果设置了many=True的话，这个设置就没有效果了


* BooleanField
    * **注意: 由于html里面，当你不选择那个checkbox的时候，就会不传递这个值。所以当你如果用form post的时候，就算没有参数，`rest_framework`也会当成False处理。**
    * 务必看源码
    * 会变成True的值: `字符串: true, True, 1,; 布尔值: True; 数字: 1`
    * 会变成False的值: `字符串: False, false, 0; 布尔值: False; 数字: 0`
    * 其他就会报错

* ChoiceField

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

## 自定义序列化类


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

## 关联的序列化类
