# 基础的模块

    from django.db import models
    from django.contrib.auth.models import User  

* [数据结构](#数据结构)  
* [数据操作](#数据操作)  

# 数据结构
* [通用](#通用)
* [字符串](#字符串)
* [时间](#时间)  
* [关联](#关联)


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
    verbose_name = '名字'   # 不知道哪里用，用来给人看的名称
    through = ''

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

<div id="关联"></div>
## 关联
#### 一对一
    models.ForeignKey(Model)    # 关联到另一个Model


###### 参数
    def get_default_user():
        return User.objects.first()

    models.ForeignKey(Model,
        on_delete=models.CASCADE # 默认连带删除(2.0以后默认不连带删除)
        on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
    )

#### 多对多 [参考文档](https://docs.djangoproject.com/en/1.10/ref/models/fields/#manytomanyfield)

    label = models.ManyToManyField(Label, verbose_name=u'标签', null=True)
    todos = models.ManyToManyField(TodoList, through="WeeklyPaperTodoRef")

###### 参数
    through = "ModelRefName"  # 可以把中间关联的表拿出来写成model加参数
    db_table = "关联的表名"  # 关联的数据库的表名称


## 特殊
#### Meta的作用
    class Meta:
        unique_together = ("user","date")   # 同一个用户同一个时间只允许一次(比如投票)
    如果不符合，会报错  django.db.utils.IntegrityError
#### property的作用
* views里面可以直接调用,不用加括号
**但是不能在aggregrate或者filter里面使用**

<div id="数据操作"></div>
# 数据操作

* [查找](#查找)
* [操作符号](#操作符号)

<div id="查找"></div>
## 查找
    obj, created = <model>.objects.get_or_create(user__name='wangx')
    # 不存在用户就不登录而是注册
    # created 为 True， 代表了obj是新建的
    # 创建的时候的时候会自动保存, 但是要注意, 如果有写field不允许null, 就需要get的时候把参数传进去

## 创建
    Model.objects.bulk_create([Model1, Model2]) # 如果后面的创建失败，整个就不会创建。类似事务，但是无法调用每个instance的save函数
    创建后会把创建对象的列表返回

## 修改
#### 原子操作
    from django.db.models import F
    obj = Model.objects.get(name='test')
    obj.friends = F('friends') + 1
    obj.save()

<div id="操作符号"></div>
## 操作符号
[官方教程](https://docs.djangoproject.com/en/1.10/ref/models/querysets/#field-lookups)
#### 基础
* 过滤: Model.objects.filter()  Model.objects.all()
* 排除: Model.objects.exclude()
#### 操作符列表
* =: 值等于
* 
