## [SlugField](https://docs.djangoproject.com/en/2.0/ref/models/fields/#slugfield)
    * 包含`[a-zA-Z_-]`，可以用在一些变量名上面
    * max_length 默认50
    * allow_unicode: 默认False，是否允许非ascii的名字

## 布尔值
    models.BooleanField()   # 布尔值

## 关联
### 一对一

```
    models.ForeignKey(Model)    # 关联到另一个Model
    models.OneToOneField(Model, related_name="profile", db_index=True)
```

#### 参数

    def get_default_user():
        return User.objects.first()

    limit_choices_to={'is_staff': True}, # 只能设置给 is_staff 的User
    related_name = "+" # 设置成+或者以+结尾，就会没有反向查找
    models.ForeignKey(Model,
        on_delete=models.CASCADE # 默认连带删除(2.0以后参数必须传)
        on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
    )
* [on_delete参数参考](https://docs.djangoproject.com/en/1.10/ref/models/fields/#django.db.models.CASCADE)  
    * models.CASCADE: `连带删除`
    * models.PROTECT: `报错`
    * models.SET_NULL: `设置为空`
    * models.SET_DEFAULT: `设置为默认`
    * models.SET(): `调用函数`
