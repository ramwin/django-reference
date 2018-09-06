**Xiang Wang @ 2017-01-23 14:05:03**

*A quick reference for django, the test example is in rest-framework-test repository*

# [The Model Layer 数据库model层](https://docs.djangoproject.com/en/2.0/#the-model-layer)

1. ## [Model and Field](./model.md)

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
3. ## FILE uploads 文件上传
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


# [The Development Process](https://docs.djangoproject.com/en/2.0/#the-development-process)
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
* [ ] to be continued


# [Security](https://docs.djangoproject.com/en/2.0/#security)
## [Cross Site Request Forgery protection](https://docs.djangoproject.com/en/2.0/ref/csrf/)
```
    from django.views.decorators.csrf import csrf_exempt
    @csrf_exempt
    def view(request):
        return HttpResponse('csrf')
```


# TODO list
* [ ] [Document](https://docs.djangoproject.com/en/2.0/#how-the-documentation-is-organized)
* [ ] [First Steps](https://docs.djangoproject.com/en/2.0/#first-steps)
* [ ] [The Template Layer](https://docs.djangoproject.com/en/2.0/#the-template-layer)
* [ ] [Forms](https://docs.djangoproject.com/en/2.0/#forms)
* [ ] [The Admin](https://docs.djangoproject.com/en/2.0/#the-admin)
* [ ] [Internationalization and Localization](https://docs.djangoproject.com/en/2.0/#internationalization-and-localization)

# [admin site](./admin.md)
# [user auth and login](./auth认证模块.md)
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
# [Exceptions](./exceptions错误.md)
# [utils](./utils.md)
# [validator](validator表单验证.md)
# [rest-framework](./rest-framework/README.md)
* ## [swagger](http://api-docs.easemob.com/#/)
* ## [serializer](./rest-framework/serializer.md)
* ## [filters](./rest-framework/filter.md)
* ## [views](./rest-framework/view.md)

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

# [uwsgi deploy](./uwsgi部署.md)
