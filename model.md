**Xiang Wang @ 2018-08-07 15:25:20**

# 目录
* [return django 返回文档](./README.md)
* [Official Document(官方文档)](https://docs.djangoproject.com/en/2.1/#the-model-layer)
* [My Reference(以前的文档)](./models.md)

# [Instance methods 实例方法](https://docs.djangoproject.com/en/2.1/ref/models/instances/)
## Refreshing objects from database
```
obj = MyModel.objects.first()
del obj.field
obj.field  # loads the only field from database 会重载这个field, 不会重载其他的field
obj.refresh_from_db()  # reload all the fields
```

## [save](https://docs.djangoproject.com/en/2.1/ref/models/instances/#django.db.models.Model.save)
save的时候，会把model的所有数据全量更新一遍，所以两个线程来了，只会save最后一个的数据
* 主键有就是update，主键没有就是insert
* save的时候发生了什么
    1. 触发model的pre—save信号
    2. 处理数据，每个field触发`pre_save`，比如`auto_now_add`和`auto_now`
    3. 处理给数据库的数据，每个field触发`get_db_prep_save`
    4. 插入数据
    5. 触发post-save信号
* django怎么区分update和insert
* 指定更新哪些field: `product.save(update_fields=["name"])`
    * 更新后，并不会触发`refresh_from_db`
* 如果是queryset的update操作，不会触发自定义的save方法。比如save的时候计算总分，如果update某个分数，总分并不会自动更新 `python3 manage.py test testapp.test_queries.TestMethodTestCase`

## to be continued
* [ ] creating objects 创建数据
* [ ] validating objects 数据校验
* [ ] deleting objects 删除数据
* [ ] pickling objects 序列化数据
* [ ] other instance methods 其他方法
* [ ] extra instance methods 额外方法
* [ ] other attributes 其他属性

# [Field Options 字段选项](https://docs.djangoproject.com/en/2.1/ref/models/fields/#field-options)

# [Field Types 字段类型](https://docs.djangoproject.com/en/2.1/ref/models/fields/#field-types)
* AutoField, BigAutoField, BigIntegerField, BinaryField
* [BooleanField](https://docs.djangoproject.com/en/2.1/ref/models/fields/#booleanfield)  
> before 1.11 version: use NullBooleanField  
> after 2.0 version: user BooleanField(null=True)
* CharField, DateField, DateTimeField, DecimalField, DurationField, EmailField, FileField, FileField and FieldFile, FilePathField, FloatField, ImageField, IntegerField, GenericIPAddressField
* NullBooleanField
> Like BooleanField with null=True. Use that instead of this field as it’s likely to be deprecated in a future version of Django.
* PositiveIntegerField, PositiveSmallIntegerField, SlugField, SmallIntegerField, TextField, TimeField, URLField, UUIDField

# [Relationship fields 关联字段](https://docs.djangoproject.com/en/2.1/ref/models/fields/#module-django.db.models.fields.related)
    * [ ] ForeignKey
        * Example 例子  
            ```
            def get_default_user():
                return User.objects.first()
            
            limit_choices_to={'is_staff': True}, # 只能设置给 is_staff 的User
            related_name = "+" # 设置成+或者以+结尾，就会没有反向查找
            models.ForeignKey(Model,
                on_delete=models.CASCADE # 默认连带删除(2.0以后参数必须传)
                on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
            )
            ```
        * [on_delete参数参考](https://docs.djangoproject.com/en/1.10/ref/models/fields/#django.db.models.CASCADE)  
            * models.CASCADE: `连带删除`
            * models.PROTECT: `报错`
            * models.SET_NULL: `设置为空`
            * models.SET_DEFAULT: `设置为默认`
            * models.SET(): `调用函数`

    * [OneToOneField](https://docs.djangoproject.com/en/2.1/ref/models/fields/#onetoonefield)
    ```
    models.ForeignKey(Model)    # 关联到另一个Model
    models.OneToOneField(Model, related_name="profile", db_index=True)
    ```
