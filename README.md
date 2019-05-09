**Xiang Wang @ 2017-01-23 14:05:03**

[A quick reference for django][django-reference] 
the test project is in [rest-framework-test][rest-framework-test] repository  
建议使用markdown工具打开[原始文件][raw]，
直接看的话因为github的每一级菜单字体太接近了，所以看上去会有点混乱

[官网文档](https://docs.djangoproject.com/en/2.2/)

# [django-rest-framework](./rest-framework/README.md)
* ## [swagger](http://api-docs.easemob.com/#/)
* ## [serializer](./rest-framework/serializer.md)
* ## [filters](./rest-framework/filter.md)
* ## [views](./rest-framework/view.md)

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

## TODO list
* [ ] Model Instance
* [ ] Migration
* [ ] Advanced
* [ ] Other

# [View][view]

* [URLconfs](./urls.md)
解析url, 反编译url

* [Requests and Response](./request_response.md)  
FILE uploads 文件上传
```
request.FILES['file']
```

* ## [Class-based View](./classbaseView.md)

# [The template layer 模板](templates.md)
# Forms 表单
[官网](https://docs.djangoproject.com/en/2.1/#forms)
* attribute
    * errors  *具体的报错信息*
* method
    * `clean()`  *其实就是调用了clean_data*
## Built-in fields
* FileField

# 开发进程 Development Process
[官网](https://docs.djangoproject.com/en/2.0/#the-development-process)
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
### [自定义指令](./customcommand.md)

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

## cache 缓存系统,
[官网](https://docs.djangoproject.com/en/2.0/topics/cache/)
```
from django.core.cache import cache
from django.core.cache import caches

cache.set('foo', 'bar', timeout=3600)
cache = caches['thirdparty']
cache.set('foo', 'bar', timeout=3600*24*60)
cache.get('cache_list', [])  # 没有默认值就返回None
```
## [Pagination](https://docs.djangoproject.com/en/2.1/topics/pagination/)
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
## [signal](./signal信号.md)
* 生成随即的字符串
```
from django.utils.crypto import get_random_string
get_random_string(length=6)
```

# TODO list
* [ ] [Document](https://docs.djangoproject.com/en/2.0/#how-the-documentation-is-organized)
* [ ] [First Steps](https://docs.djangoproject.com/en/2.0/#first-steps)

# [utils](./utils.md)

[django-reference]: https://github.com/ramwin/django-reference
[raw]: https://raw.githubusercontent.com/ramwin/django-reference/master/README.md
[view]: https://docs.djangoproject.com/en/2.0/#the-view-layer
[rest-framework-test]: https://github.com/ramwin/rest-framework-test
[api-reference]: https://docs.djangoproject.com/en/2.2/ref/class-based-views/
[exceptions]: https://docs.djangoproject.com/en/2.1/ref/exceptions/
[international]: https://docs.djangoproject.com/en/2.0/#internationalization-and-localization
[common-tool]: https://docs.djangoproject.com/en/2.1/#common-web-application-tools
