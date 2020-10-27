Xiang Wang @ 2017-01-23 14:05:03

[A quick reference for django][django-reference] 
the test project is in [rest-framework-test][rest-framework-test] repository  
建议使用markdown工具打开[原始文件][raw]，
直接看的话因为github的每一级菜单字体太接近了，所以看上去会有点混乱

[官网文档](https://docs.djangoproject.com/en/3.0/)

# 一些有用的插件
* [django-dirtyfields](https://github.com/romgar/django-dirtyfields/)  
利用`__init__`的时候备份数据，实现知道一个model哪些数据变化了

* [django-bootstrap4](https://github.com/zostera/django-bootstrap4)
```
pip install django-bootstrap4
{% load bootstrap4 %}
{% bootstrap_css %}
{% bootstrap_javascript jquery='full' %}
```
## django-import-export 导入导出功能
### Resource
* 源码剖析
```
def import_date():
    import_data_inner
def import_data_inner
    instance_loader = instance_loaders.ModelInstanceLoader
    instance_loader = self._meta.instance_loader_class(self, dataset)
    row_result = self.import_row(
        row, instance_loader, ...
    )
def import_row(self, row):
    self.before_import(row, **kwargs)
    instance, new = self.get_or_init_instance(instance_loader, row)
    self.import_obj(instance, row, dry_run)
    self.save_instance(instance, using_transactions, dry_run)
    self.save_m2m(instance, row, using_transactions, dry_run)
def get_or_init_instance(self, instance_loader, row):
    instance = self.get_instance(instance_loader, row)
    if instance:
        return (instance, False)
    else:
        return (self.init_instance(row), True)
def init_instance(self, row)
    return self._meta.model()  # ModelResource
    raise NotImplementedError()
def import_obj(self, obj, data, dry_run):
    for field:
        self.import_field(field, obj, data)
def import_field(self, field, obj, data, is_m2m=False):
    if field.attribute and field.column_name in data:
        field.save(obj, data, is_m2m)  # 看下面的Field.save
def save_instance(self, instance, using_transactions=True, dry_run=False):
    self.before_save_instance(instance, using_transactions, dry_unr)
    if not using_transactions and dry_run:
        # we don't have transactions and we want to do a dry_run
        pass
    else:
        instance.save()
    self.after_save_instance(instance, using_transactions, dry_run)
```
* `Resource.get_instance`
只有在`get_instance`以后,才会用field的clean方法获取object
```
def get_instance(self, instance_loader, row):
    import_id_fields = [
        self.fields[f] for f in self.get_import_id_fields()
    ]
    for field in import_id_fields:
        if field.column_name not in row:
            return
    return instance_loader.get_instance(row)
```
### [Field](https://django-import-export.readthedocs.io/en/stable/api_fields.html)
* 因为源码里是用`__`来split的,注意
```
from import_export.fields import Field
class Field:
    def clean(self, data):
        """
        Translates the value stored in the imported datasource to an
        appropriate Python object and returns it.
        """
        try:
            value = data[self.column_name]
        except KeyError:
            raise KeyError("Column '%s' not found in dataset. Available "
                           "columns are: %s" % (self.column_name, list(data)))

        # If ValueError is raised here, import_obj() will handle it
        value = self.widget.clean(value, row=data)

        if value in self.empty_values and self.default != NOT_PROVIDED:
            if callable(self.default):
                return self.default()
            return self.default

        return value
    def save(self, obj, data, is_m2m=False):
        if not self.readonly:
            attrs = self.attribute.split("__")
            for attr in attrs[:-1]:
                obj = getattr(obj, attr, None)
            cleaned = self.clean(data)
            if cleaned is not None or self.saves_null_values:
                if not is_m2m:
                    setattr(obj, attrs[-1], cleaned)
                else:
                    getattr(obj, attrs[-1]).set(cleaned)
    def export(self, obj):
        value = self.get_value(obj)
        if value is None:
            return ""
        return self.widget.render(value, obj)
    def get_value(self, obj):
        attrs = self.attribute.splic("__")
        value = obj
        for attr in attrs:
            value = getattr(value, attr, None)
        return value
```
### ModelInstanceLoader
```
def get_instance(self, row):  # 用来修改数据的
    for key in self.resource.get_import_id_fields():
        field = self.resource.fields[key]
        params[field.attribute] = field.clean(row)
```

# [django-rest-framework](./rest-framework/README.md)
* ## [swagger](http://api-docs.easemob.com/#/)
* ## [serializer](./rest-framework/serializer.md)
* ## [filters](./rest-framework/filter.md)
* ## [views](./rest-framework/view.md)

# FAQ
## Databases and models
* How can I see the raw SQL queries Django is running? 查看queryset的sql语句
使用connection.queries
```
DEBUG模式
from django.db import connection
connection.queires
from djabgo.db import reset_queries
reset_queries()  # 清空query
```
或者使用`print(queryset.query)` `queryset.query.sql_with_params()` [stackoverflow链接](https://stackoverflow.com/questions/1074212/how-can-i-see-the-raw-sql-queries-django-is-running)

# Topic guides
讨论各种主题和工具 at a fairly high level, 提供一些背景知识和解释

## Models and databases
* [aggregation聚合数据](./aggregation聚集.md)

# Model & Queryset  
*Django The Model Layer 数据库model层*
[官网](https://docs.djangoproject.com/en/2.1/#the-model-layer)

## [Model & Field](./model.md)
* [Field Options](./model.md#field-options-字段选项)  
unique, blank, null的用法，歧义解释
* [Field Types](./model.md#field-types-字段类型)
* [Relationship fields](./model.md#relationship-fields-关联字段)
* [Instance methods 实例方法](./model.md#instance-methods-实例方法)

## [QuerySets](./queryset.md)

## [Migrations](https://docs.djangoproject.com/en/3.0/#the-model-layer)
### [Introduction to Migrations](https://docs.djangoproject.com/en/3.0/topics/migrations)
### [压缩迁移 Squashing migrations](https://docs.djangoproject.com/en/3.0/topics/migrations/#squashing-migrations)

## [Advanced](./advanced.md)
### [ ] Managers
### [ ] Custom lookups
### [Multiple databases](https://docs.djangoproject.com/en/3.0/topics/db/multi-db/)
### [Query Expressions](./advanced.md#query-expressions)
### [ ] Conditional Expressions
### Database Functions

## TODO list
* [ ] Model Instance
* [ ] Other

# [View][view]

* [URLconfs](./urls.md)
解析url, 反编译url

* [Requests and Response](./request_response.md)  
FILE uploads 文件上传
```
request.FILES['file']
```

## [Class-based View](./classbaseView.md)

## Middleware
```
def simple_middleware(get_response):
    # One-time configuration and initialization.

    def middleware(request):
        # Code to be executed for each request before
        # the view (and later middleware) are called.

        response = get_response(request)

        # Code to be executed for each request/response after
        # the view is called.

        return response

    return middleware
```

# [The template layer 模板](templates.md)

# [Forms 表单](https://docs.djangoproject.com/en/2.1/#forms)

## [Form API](https://docs.djangoproject.com/en/2.1/ref/forms/api/#)
### [Using forms to validate data](https://docs.djangoproject.com/en/2.1/ref/forms/api/#using-forms-to-validate-data)
* attribute
    * errors  *具体的报错信息*
    ```
    f.errors
    {'sender': ['Enter a valid email address.'], 'subject': ['This field is required.']}
    ```
* method
    * `clean()`  *其实就是调用了clean_data*
## Built-in fields
* FileField

# 开发进程 Development Process
[官网](https://docs.djangoproject.com/en/2.2/#the-development-process)

* [Settings]
    * [ ] overview
    * [ ] Full list of settings
        * Core Settings
            * [ ] CSRF_TRUSTED_ORIGINS
            * [Databases](http://ramwin.com:8888/ref/settings.html#databases)
            ```
            DATABASES = {
                'default': {
                    'ENGINE': 'django.db.backends.sqlite3',
                    'NAME': 'mydatabase',
                }
            }
            DATABASES = {
                'default': {
                    'ENGINE': 'django.db.backends.postgresql',
                    'NAME': 'mydatabase',
                    'USER': 'mydatabaseuser',
                    'PASSWORD': 'mypassword',
                    'HOST': '127.0.0.1',
                    'PORT': '5432',
                }
            }
            ```
        * Auth
            * AUTH_USER_MODEL
        * Sessions
            * SESSION_COOKIE_AGE
            默认1209600(2 weeks), 当session过期的时候，就会直接变成not authenticated了。但是这个session的过期时间是看上次生成的日期的。更改后，以前登录过的人，还是一直在登录状态。麻烦.
            * [ ] [如何根据不活跃时间来计算expire](https://stackoverflow.com/questions/3024153/how-to-expire-session-due-to-inactivity-in-django)
            * [ ] 如何处理之前登录过，有个很长的cookie的人

* [Applications](https://docs.djangoproject.com/en/2.2/ref/applications/)
    * Configuring applications
    ```
    from django.apps import AppConfig
    class MyAppConfig(AppConfig):
        verbose_name = "自己的名字"
    注意修改后要在 app/__init__.py 里面设置 default_app_config = 'app.apps.MyAppConfig'
    ```

* [Exceptions][exceptions]  
    Django Core Exceptions  
    `from django.core.exceptions import *`
    * ValidationError()
    * ObjectDoesNotExist
    因为model.DoesNotExist是继承了这个Exception, 所以可以用一个ObjectDoesNotExist来判断多个错误
    ```
    from django.core.exceptions import ObjectDoesNotExist
    try:
        e = Entry.objects.get(id=3)
        b = Blog.objects.get(id=1)
    except ObjectDoesNotExist:
        print("Either the entry or blog doesn't exist.")
    ```
    * model.DoesNotExist `from django.core.exceptions import ObjectDoesNotExist`
    * MultipleObjectsReturned
    * PermissionDenied()

* ## django-admin and manage.py
### [customcommand 自定义指令](./customcommand.md)

## [Testing 测试](./test测试.md)

* Deployment 部署
    * [WSGI servers, uwsgi](./uwsgi部署.md)
    * [ ] to be continued

# The Admin 后台管理系统cms
* [Admin site](./admin.md)
* [ ] Admin actions
* [ ] Admin documentation generator


# [Security](https://docs.djangoproject.com/en/2.0/#security)
## [Cross Site Request Forgery protection](https://docs.djangoproject.com/en/2.0/ref/csrf/)
form表单提交的csrf数据: csrfmiddlewaretoken="wfjdaefefewajfklajsf"
```
    from django.views.decorators.csrf import csrf_exempt
    @csrf_exempt
    def view(request):
        return HttpResponse('csrf')
```

# [国际化本地化][international]
* [Time zones 时区](timezone时区.md)

# [Python Compatibility 23兼容](https://docs.djangoproject.com/en/1.11/topics/python3/)
```
from django.utils.encoding import python_2_unicode_compatible
from __future__ import unicode_literals
```

# [常用的网站应用 Common Web application tools][common-tool]
## [用户认证 Authentication](./auth认证模块.md)
* [已经有了AbstractUser的情况下,自定义user](https://www.caktusgroup.com/blog/2019/04/26/how-switch-custom-django-user-model-mid-project/)

## cache 缓存系统,
[官网](https://docs.djangoproject.com/en/2.2/topics/cache/)
```
from django.core.cache import cache
from django.core.cache import caches

cache.set('foo', 'bar', timeout=3600)
cache = caches['thirdparty']
cache.set('foo', 'bar', timeout=3600*24*60)
cache.get('cache_list', [])  # 没有默认值就返回None
```

## [logging](./logging.md)

## [Pagination](./pagination.md)
```
from django.core.pagiator import Paginator
objects = Model.objects.all()
p = Paginator(objects, 2)   # 每页显示2个元素
p.count # 获取一共多少个元素
p.num_pages # 获取页数
objectslist = p.page(n)   # 获取第n页
objectslist.has_previous | has_next # 判断是否有下一页
objectslist.previous_page_number | next_page_number # 获取上一页或下一页的页码
objectslist.number  # 当前页码
```

## [Data Validation](./validator表单验证.md)

# [Other core functionalities 其他功能](https://docs.djangoproject.com/en/2.1/#other-core-functionalities)
## [Content Types and Generic relations](http://ramwin.com:8888/ref/contrib/contenttypes.html)
* The ContentType Model 
    * app_label: application的名字.如果有层import,就是最后的路径
    * model: model的name
    * name: 人看的name
* [ContentType的方法](http://ramwin.com:8888/ref/contrib/contenttypes.html#methods-on-contenttype-instances)
    * [ ]
    * model_class(): 返回contenttype对应的model
    ```
    class ContentType(models.Model):
        def model_class(self):
            try:
                return apps.get_model(self.app_label, self.model)
            except LookupError:
                return None
    ```
* ContentTypeManager
    * [ ]
    * get_for_model(model)
    ```
    ContentType.objects.get_for_model(User)
    ```
    * [ ]



## [signal](./signal信号.md)

# TODO list
* [ ] [Document](https://docs.djangoproject.com/en/2.0/#how-the-documentation-is-organized)
* [ ] [First Steps](https://docs.djangoproject.com/en/2.0/#first-steps)

# [utils](./utils.md)
* 生成随即的字符串
```
from django.utils.crypto import get_random_string
get_random_string(length=6)
```

[django-reference]: https://github.com/ramwin/django-reference
[raw]: https://raw.githubusercontent.com/ramwin/django-reference/master/README.md
[view]: https://docs.djangoproject.com/en/2.0/#the-view-layer
[rest-framework-test]: https://github.com/ramwin/rest-framework-test
[api-reference]: https://docs.djangoproject.com/en/2.2/ref/class-based-views/
[exceptions]: https://docs.djangoproject.com/en/2.1/ref/exceptions/
[international]: https://docs.djangoproject.com/en/2.0/#internationalization-and-localization
[common-tool]: https://docs.djangoproject.com/en/2.1/#common-web-application-tools
