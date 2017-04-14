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


## PrimaryKeyRelatedField

#### 基础使用
    users = serializers.PrimaryKeyRelatedField(many=True)

#### 参数
* many=True, 允许传入多个
* allow_null=False, 如果设置了many=True的话，这个设置就没有效果了


## JSONField
```
```

## BooleanField
* **注意: 由于html里面，当你不选择那个checkbox的时候，就会不传递这个值。所以当你如果用form post的时候，就算没有参数，`rest_framework`也会当成False处理。**
* 务必看源码
* 会变成True的值: `字符串: true, True, 1,; 布尔值: True; 数字: 1`
* 会变成False的值: `字符串: False, false, 0; 布尔值: False; 数字: 0`
* 其他就会报错


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
