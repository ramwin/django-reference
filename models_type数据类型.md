# 基础的模块

    from django.db import models
    from django.contrib.auth.models import User  

* [数据结构](#数据结构)  

# 数据结构
* [通用](#通用)
* [字符串](#字符串)
* [时间](#时间)  
* [关联](#关联)  


## 示例
    class profile(models.Model):
        SEX_CHOICE = (
            ('M':'男'),
            ('F':'女')
        )
        user = models.ForeignKey(User)  # 外键
        sex = models.CharField(
                max_length = 1,
                verbose_name = '性别',  # 显示名称
                choices = SEX_CHOICE)   # 可选内容
        birthday = models.DateField(default = datetime.date.today()) # 默认值, 日期
        registertime = models.DateTimeField(auto_now=True)
        # django默认是用
        lastlogin = models.DateTimeField()


<div id="通用"></div>
## 通用
#### 参数
    null = True,    # 是否可以是NULL
    default = '0',  # 默认的数值
    blank=True      # admin界面是不是可以不填写。不填写的话就是NULL
    related_name = 'table'  # 设置反向查找的功能
    verbose_name = '名字'   # admin界面用来给人看的名称,账号，而不是username
    help_text = ''  # 在每个model的form下面有一小行字符串。显示帮助信息。账号必须多于6个字符等等
    through = ''
    choices = TUPLE

<div id="字符串"></div>
## 字符串
    models.CharField(max_length=255)
    models.TextField()
        max_length  # 不是数据库底层支持的。
    models.EmailField()
        # 底层还是 CharField 只不过用 EmailValidator 去校验
* [EmailValidator](https://docs.djangoproject.com/en/1.10/ref/validators/#django.core.validators.EmailValidator)

<div id="时间"></div>
## 时间  
#### django 都是存储的0时区的时间  
    models.DateTimeField()
#### 可以有的参数
    auto_now_add = True   # 保存为当前时间，不再改变
    auto_now = True # 保存未当前时间，每次保存时候会自动变更

<div id="数字"></div>
## 数字
    models.IntegerField()   # 整数
    models.FloatField() # 小数
    models.DecimalField()   # 精确小数
#### 必须参数(decimal)
    decimal_places = 2  # 小数尾数
    max_digits = 3  # 数字的位数(包括小数)
#### 参数
#### 保存
    integer:    1, '1', 不可以是 '2.9', 但是可以是 2.9(之后存入2), 调用的是int函数
    float:  '1.1', 1.1
    decimal:    '1.1', 1.1, decimal.Decimal('1.1')
### 获取

<div id="布尔值"></div>
# 布尔值
    models.BooleanField()   # 布尔值

<div id="关联"></div>
## 关联
#### 一对一
    models.ForeignKey(Model)    # 关联到另一个Model
    models.OneToOneField(Model, related_name="profile", db_index=True)

###### 参数

    def get_default_user():
        return User.objects.first()

    models.ForeignKey(Model,
        on_delete=models.CASCADE # 默认连带删除(2.0以后默认不连带删除) 
        on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
    )
* [on_delete参数参考](https://docs.djangoproject.com/en/1.10/ref/models/fields/#django.db.models.CASCADE)  


###### 使用
    
    user.profile

#### 多对一
* 请使用ForeignKey [参考](https://docs.djangoproject.com/en/1.10/topics/db/examples/many_to_one/)
#### 多对多 [参考文档](https://docs.djangoproject.com/en/1.10/ref/models/fields/#manytomanyfield)

    label = models.ManyToManyField(Label, verbose_name=u'标签', null=True)
    todos = models.ManyToManyField(TodoList, through="WeeklyPaperTodoRef")

###### 参数
    through = "ModelRefName"  # 可以把中间关联的表拿出来写成model加参数
    db_table = "关联的表名"  # 关联的数据库的表名称

#### 其他
* 如果调用了本身，可以使用 `models.ForeignKey('self', on_delete=models.CASCADE)`


## 特殊
#### Meta的作用
    class Meta:
        unique_together = ("user","date")   # 同一个用户同一个时间只允许一次(比如投票)
    如果不符合，会报错  django.db.utils.IntegrityError
        ordering = "-id"  # 指定默认排序方式
        db_table = "table"  # 指定表的名称
#### property的作用
* views里面可以直接调用,不用加括号
**但是不能在aggregrate或者filter里面使用**

