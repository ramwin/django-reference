**Xiang Wang @ 2017-01-23 14:05:03**

*A quick reference  for django*

# [The Model Layer](https://docs.djangoproject.com/en/2.0/#the-model-layer)

1. ## Model and Field
    * [Official Document](https://docs.djangoproject.com/en/2.1/#the-model-layer)
    * [My Reference](./models.md)

2. ## QuerySets
    * ### [My Reference](./queries.md)
    * [Making Queries](making_queries.md)
    * [QuerySet method reference](queryset_method_reference.md)
    * [Lookup expressions](lookup_expressions.md)

3. ## TODO list
    * [ ] Model Instance
    * [ ] Migration
    * [ ] Advanced
    * [ ] Other

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

# TODO list
* [ ] [Document](https://docs.djangoproject.com/en/2.0/#how-the-documentation-is-organized)
* [ ] [First Steps](https://docs.djangoproject.com/en/2.0/#first-steps)
* [ ] [The Model Layer](https://docs.djangoproject.com/en/2.0/#the-model-layer)
* [ ] [The View Layer](https://docs.djangoproject.com/en/2.0/#the-view-layer)
* [ ] [The Template Layer](https://docs.djangoproject.com/en/2.0/#the-template-layer)
* [ ] [Forms](https://docs.djangoproject.com/en/2.0/#forms)
* [ ] [The Admin](https://docs.djangoproject.com/en/2.0/#the-admin)
* [ ] [Security](https://docs.djangoproject.com/en/2.0/#security)
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
```
# [View](./views.md)
# [classbaseview](./classbaseView.md)
# [Request & Response](./request_response.md)
# [templates](./templates.md)
# [Exceptions](./exceptions错误.md)
# [utils](./utils.md)
# [validator](validator表单验证.md)
# [rest_framework](./rest-framework/README.md)
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
