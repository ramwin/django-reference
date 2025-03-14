[A quick reference for django][django-reference] 
the test project is in [rest-framework-test][rest-framework-test] repository  

[官网文档](https://docs.djangoproject.com/en/3.0/)  


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
```{toctree}
./queryset.md
./advanced.md
./pagination.md
```

*Django The Model Layer 数据库model层*
[官网](https://docs.djangoproject.com/en/2.1/#the-model-layer)

## Model & Field

* [Field Options](./model.md#field-options-字段选项)  
unique, blank, null的用法，歧义解释
* [Field Types](./model.md#field-types-字段类型)
* [Relationship fields](./model.md#relationship-fields-关联字段)
* [Instance methods 实例方法](./model.md#instance-methods-实例方法)

## Migrations
### [Introduction to Migrations][migrations]

### Data Migrations 数据迁移
```
python manage.py makemigrations --empty yourappname
from django.db import migrations
def combine_names(apps, schema_editor):
    Person = apps.get_model("yourappname", "Person")
    for person in Person.objects.all():
        person.name = "%s %s" % (person.first_name, person.last_name)
        person.save()
class Migration(migrations.Migration):
    dependencies = [
        ("yourappname", "0001_initial"),
    ]
    operations = [
        migrations.RunPython(combine_names, reverse_code=migrations.RunPython.noop)
    ]
```
### [压缩迁移 Squashing migrations](https://docs.djangoproject.com/en/3.0/topics/migrations/#squashing-migrations)

## TODO list
* [ ] Model Instance
* [ ] Other

# [views](./views.md)
```{toctree}
./views.md
```
## [url](./views.md#URL)

## Request and Response
```{toctree}
./request_response.md
```

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

## Settings配置
```{toctree}
./settings.md
```

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

# django-admin and manage.py

```{toctree}
./available_commands.md
./customcommand.md
```
```
from django.core.management import call_command
```

## Testing 测试

```{toctree}
:maxdepth: 5
./test测试.md
```

## Deployment 部署
### WSGI servers, uwsgi
```{toctree}
./uwsgi部署.md
```

### gunicorn
```{toctree}
./gunicorn.md
```

### 信号的处理机制
* signal绑定的情况下
    * 如果是runserver的进程, term的时候会直接崩溃
    * 如果是gunicorn的进程, term的时候也会直接崩溃
* 没有signal绑定的情况下
    * 如果是gunicorn的进程, 会先启动新的进程, term的时候会等待最后一个请求完成

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
* Time zones 时区
```{toctree}
./timezone时区.md
```

# [Python Compatibility 23兼容](https://docs.djangoproject.com/en/1.11/topics/python3/)
```
from django.utils.encoding import python_2_unicode_compatible
from __future__ import unicode_literals
```

# [常用的网站应用 Common Web application tools][common-tool]
```{toctree}
./logging.md
```

## Serialization
```python
from django.core import serializers
serializers.serializer("json", Iterable[Model], indent=4)  # json字符串
```

## [用户认证 权限](./auth认证模块.md)
Authentication Permission  
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

## Data Validation
```{toctree}
./validator表单验证.md
```

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
[rest-framework-test]: https://github.com/ramwin/rest-framework-test
[api-reference]: https://docs.djangoproject.com/en/2.2/ref/class-based-views/
[exceptions]: https://docs.djangoproject.com/en/2.1/ref/exceptions/
[international]: https://docs.djangoproject.com/en/2.0/#internationalization-and-localization
[common-tool]: https://docs.djangoproject.com/en/2.1/#common-web-application-tools
[migrations]: https://docs.djangoproject.com/en/4.2/topics/migrations/
