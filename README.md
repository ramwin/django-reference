**Xiang Wang @ 2017-01-23 14:05:03**

*[A quick reference for django](https://github.com/ramwin/django-reference), the test example is in [rest-framework-test](../rest-framework-test/README.md) repository*  
*建议使用markdown工具打开[原始文件](https://raw.githubusercontent.com/ramwin/django-reference/master/README.md)，直接看的话因为github的一级菜单, 二级菜单，三级菜单字体太接近了，所以看上去会有点混乱*

# [rest-framework restful框架](./rest-framework/README.md)
* ## [swagger](http://api-docs.easemob.com/#/)
* ## [serializer](./rest-framework/serializer.md)
* ## [filters](./rest-framework/filter.md)
* ## [views](./rest-framework/view.md)

# Topic guides
讨论各种主题和工具 at a fairly high level, 提供一些背景知识和解释
## Models and databases
* [aggregation聚合数据](./aggregation聚集.md)

# [Django The Model Layer 数据库model层](./model.md),
[官网](https://docs.djangoproject.com/en/2.1/#the-model-layer)
## [Model and Field](./model.md)
### [Field Options 字段选项](./model.md#field-options-字段选项)
unique, blank, null的用法，歧义解释
### [Field Types 字段类型](./model.md#field-types-字段类型)
* FileField

### [Relationship fields](./model.md#relationship-fields-关联字段)
### [Instance methods 实例方法](./model.md#instance-methods-实例方法)

## [QuerySets](./queryset.md)

## TODO list
* [ ] Model Instance
* [ ] Migration
* [ ] Advanced
* [ ] Other


# [The View Layer 视图层](https://docs.djangoproject.com/en/2.0/#the-view-layer)
1. ## [URLconfs](./urls.md)
    * ### django.urls utility functions
    [官网](https://docs.djangoproject.com/en/2.1/ref/urlresolvers/#resolve)
        * resolve
        ```
        resolve_match = resolve(url)
        resolve_match.name_space
        ```
        * ResolverMatch
        r.namespace url的namespace
    * 根据name生成url
    ```
    from django.urls import reverse
    >>> reverse('reqres:ajax')
    /reqres/ajax/
    >>> reverse('request:ajax-detail', args=[1])
    /reqres/ajax/1/
    >>> reverse('request:ajax', kwargs={'pk': 1})
    /reqres/ajax/1/
    ```
    * 解析url
    ```
    from django.utils.six.moves.urllib.parse import urlparse, urlunparse
    ```
2. ## [Requests and Response](./request_response.md)
3. FILE uploads 文件上传
    ```
    request.FILES['file']
    ```
4. ## [Class-based View](./classbaseView.md)
    * [API reference](https://docs.djangoproject.com/en/2.0/ref/class-based-views/)
        * Context Mixin
            * extra_context: `TemplateView.as_view(extra_context={"title": "Common Title"})`
            * get_context_data:  
            ```
            from django.views.generic.base import ContextMixin
            def get_context_data(self, **kwargs):
                if "view" not in kwargs:
                    kwargs["view"] = self
                return kwargs

            def get_context_data(self, **kwargs):
                context = super(TemplateView, self).get_context_data(**kwargs)
                context["number"] = random.randrange(1, 100)
                return context
            ```

# [The template layer 模板](templates.md)
# [Forms 表单]()
* attribute
    * errors  *具体的报错信息*
* method
    * `clean()`  *其实就是调用了clean_data*

# [The Development Process 开发工具](https://docs.djangoproject.com/en/2.0/#the-development-process)
## Applications

## [Exceptions 报错](./exceptions错误.md)
* Django Core Exceptions
    * ValidationError()
    * PermissionDenied()
    * model.DoesNotExist `from django.core.exceptions import ObjectDoesNotExist`

## django-admin and manage.py
* [Adding custom commands 自定义指令](./customcommand.md)
```
from django.core.management.base import OutputWrapper
from django.core.management.color import color_style
out = OutputWrapper(sys.stdout)
style = color_style()
out.write(style.SUCCESS(serializer.data))
```

## [Testing 测试](./test测试.md)
### [The test client](./test测试.md#The-test-client)

## Deployment 部署
### [WSGI servers, uwsgi](./uwsgi部署.md)
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

# [Internationalization and Localization 国际化和本地化](https://docs.djangoproject.com/en/2.0/#internationalization-and-localization)
## [Time zones 时区](timezone时区.md)

# [Python Compatibility 23兼容](https://docs.djangoproject.com/en/1.11/topics/python3/)
```
from django.utils.encoding import python_2_unicode_compatible
from __future__ import unicode_literals
```

# Common Web application tools 常用的网站应用
[官网](https://docs.djangoproject.com/en/2.1/#common-web-application-tools)
## [Authentication 用户认证](./auth认证模块.md),
[官网](https://docs.djangoproject.com/en/2.1/#common-web-application-tools)
* [ ] 总览
* [使用认证系统](./auth认证模块#Using_the_authentication_system_适用认证系统)
* [ ] 密码管理
* [ ] 自定义认证系统
* [ ] API参考

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

