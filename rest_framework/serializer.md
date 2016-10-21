#### Xiang Wang @ 2016-09-28 15:54:49


# Serializer

## 基础使用

    from rest_framework import serializers
    class ShopSerializer(serializers.ModelSerializer):
        class Meta:
            model = Shop
    serializer = ModelSerializer(data={...})
    serializer.is_valid(raise_exception=True)  # 会判断外键是否存在
    serializer.save(**kwargs)  # 这个数据会覆盖掉原来的data, 并且可以设置一些read_only的数据

* 注意事项:
    * 不能把id放入
    * auto\_now\_add 无法修改, 但是在以前的版本里面，必须设置`read_only=True`
    * 如果是外键，使用 data = {'user':1}  # 不要直接用object
    * 如果外键是嵌套的model, save的时候需要把嵌套的字段进行覆盖
    * 嵌套的model要设置read\_only


* 添加额外的数据: filed = serializers.ReadOnlyField(source="profile.avatar")
