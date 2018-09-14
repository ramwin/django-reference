**Xiang Wang @ 2017-01-23 14:05:03**

*A quick reference for django, the test example is in rest-framework-test repository*
* [official documents 官网文档](https://docs.djangoproject.com/en/2.0/)

# [The Model Layer 数据库model层](https://docs.djangoproject.com/en/2.0/#the-model-layer)

1. ## [Model and Field](./model.md)
    ### [Field Types 字段类型](./model.md#field-types-字段类型)

2. ## QuerySets
    * ### [My Reference(我的文档)](./queries.md)  
    * [ ] Making Queries  
    * [QuerySet method reference](queryset_method_reference.md)  
    * [ ] Lookup expressions  

3. ## TODO list
    * [ ] Model Instance
    * [ ] Migration
    * [ ] Advanced
    * [ ] Other


# [The View Layer 视图层](https://docs.djangoproject.com/en/2.0/#the-view-layer)
2. Requests and Response
    * 获取请求的文件: `request.FILES['file']`
3. FILE uploads 文件上传
    ```
    request.FILES['file']
    ```
4. ## Class-based View
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


# [The Development Process 开发工具](https://docs.djangoproject.com/en/2.0/#the-development-process)
## Testing
* Introduction
* Writting and running tests
    * Writing tests
    ```
    from django.test import TestCase
    from myapp.models import Animal

    class AnimalTestCase(TestCase):
        def setUp(self):
            Animal.objects.create(name="lion", sound="roar")
            Animal.objects.create(name="cat", sound="meow")

        def test_animals_can_speak(self):
            """Animals that can speak are correctly identified"""
            lion = Animal.objects.get(name="lion")
            cat = Animal.objects.get(name="cat")
            self.assertEqual(lion.speak(), 'The lion says "roar"')
            self.assertEqual(cat.speak(), 'The cat says "meow"')
    ```
* [Running Tests](https://docs.djangoproject.com/en/2.0/topics/testing/overview/#running-tests)

## [Exceptions 报错](./exceptions错误.md)
* Django Core Exceptions
    * ValidationError()
    * PermissionDenied()
    * model.DoesNotExist `from django.core.exceptions import ObjectDoesNotExist`

## [WSGI servers, uwsgi](./uwsgi部署.md)
* [ ] to be continued

# [The Admin 后台管理系统cms](./admin.md)
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

# [Common Web application tools](https://docs.djangoproject.com/en/2.1/#common-web-application-tools)
## [Authentication](./auth认证模块.md)
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

# TODO list
* [ ] [Document](https://docs.djangoproject.com/en/2.0/#how-the-documentation-is-organized)
* [ ] [First Steps](https://docs.djangoproject.com/en/2.0/#first-steps)
* [ ] [The Template Layer](https://docs.djangoproject.com/en/2.0/#the-template-layer)
* [ ] [Forms](https://docs.djangoproject.com/en/2.0/#forms)

# [cache](https://docs.djangoproject.com/en/2.0/topics/cache/)
```
from django.core.cache import cache
from django.core.cache import caches

cache.set('foo', 'bar', timeout=3600)
cache = caches['thirdparty']
cache.set('foo', 'bar', timeout=3600*24*60)
cache.get('cache_list', [])  # 没有默认值就返回None
```


# [URL](./urls.md)
```
from django.urls import reverse
>>> reverse('reqres:ajax')
/reqres/ajax/
>>> reverse('request:ajax-detail', args=[1])
/reqres/ajax/1/
>>> reverse('request:ajax', kwargs={'pk': 1})
/reqres/ajax/1/
```

# [View](./views.md)
# [classbaseview](./classbaseView.md)
# [Request & Response](./request_response.md)
# [templates](./templates.md)
# [utils](./utils.md)
# [validator](validator表单验证.md)
# [rest-framework](./rest-framework/README.md)
* ## [swagger](http://api-docs.easemob.com/#/)
* ## [serializer](./rest-framework/serializer.md)
* ## [filters](./rest-framework/filter.md)
* ## [views](./rest-framework/view.md)
* ## [exceptions](./rest-framework/README.md)

# [signal](./signal信号.md)
# [form](./form.md)
* attribute
    * errors  *具体的报错信息*
* method
    * `clean()`  *其实就是调用了clean_data*

# unittest
* [assertions](https://docs.djangoproject.com/en/1.11/topics/testing/tools/#assertions)

# [custom command](./customcommand.md)
```
from django.core.management.base import OutputWrapper
from django.core.management.color import color_style
out = OutputWrapper(sys.stdout)
style = color_style()
out.write(style.SUCCESS(serializer.data))
```
