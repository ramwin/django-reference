**Xiang Wang @ 2017-01-23 14:05:03**

*A quick reference  for django*

# [The Model Layer 数据库model层](https://docs.djangoproject.com/en/2.0/#the-model-layer)

1. ## Model and Field
    * [Official Document(官方文档)](https://docs.djangoproject.com/en/2.1/#the-model-layer)
    * [My Reference(以前的文档)](./models.md)
    * [Instance methods 实例方法](https://docs.djangoproject.com/en/2.1/ref/models/instances/)
        * Refreshing objects from database
        ```
        obj = MyModel.objects.first()
        del obj.field
        obj.field  # loads the only field from database 会重载这个field, 不会重载其他的field
        obj.refresh_from_db()  # reload all the fields
        ```
    * [Field Options 字段选项](https://docs.djangoproject.com/en/2.1/ref/models/fields/#field-options)
    * [Field Types 字段类型](https://docs.djangoproject.com/en/2.1/ref/models/fields/#field-types)
        * AutoField, BigAutoField, BigIntegerField, BinaryField
        * [BooleanField](https://docs.djangoproject.com/en/2.1/ref/models/fields/#booleanfield)  
        > before 1.11 version: use NullBooleanField  
        > after 2.0 version: user BooleanField(null=True)
        * CharField, DateField, DateTimeField, DecimalField, DurationField, EmailField, FileField, FileField and FieldFile, FilePathField, FloatField, ImageField, IntegerField, GenericIPAddressField
        * NullBooleanField
        > Like BooleanField with null=True. Use that instead of this field as it’s likely to be deprecated in a future version of Django.
        * PositiveIntegerField, PositiveSmallIntegerField, SlugField, SmallIntegerField, TextField, TimeField, URLField, UUIDField
    * [Relationship fields 关联字段](https://docs.djangoproject.com/en/2.1/ref/models/fields/#module-django.db.models.fields.related)
        * [ ] ForeignKey
            * Example 例子  
                ```
                def get_default_user():
                    return User.objects.first()
                
                limit_choices_to={'is_staff': True}, # 只能设置给 is_staff 的User
                related_name = "+" # 设置成+或者以+结尾，就会没有反向查找
                models.ForeignKey(Model,
                    on_delete=models.CASCADE # 默认连带删除(2.0以后参数必须传)
                    on_delete=models.SET(get_default_user)  # 删除后调用函数设置连带关系的默认直
                )
                ```
            * [on_delete参数参考](https://docs.djangoproject.com/en/1.10/ref/models/fields/#django.db.models.CASCADE)  
                * models.CASCADE: `连带删除`
                * models.PROTECT: `报错`
                * models.SET_NULL: `设置为空`
                * models.SET_DEFAULT: `设置为默认`
                * models.SET(): `调用函数`

        * [OneToOneField](https://docs.djangoproject.com/en/2.1/ref/models/fields/#onetoonefield)
        ```
        models.ForeignKey(Model)    # 关联到另一个Model
        models.OneToOneField(Model, related_name="profile", db_index=True)
        ```

2. ## QuerySets
    * ### [My Reference(我的文档)](./queries.md)  
    * [ ] Making Queries  
    * [QuerySet method reference](queryset_method_reference.md)  
        * Queryset API
            * Methods that return new Querysets  
                * `filter, exclude, annotate, defer`
                * defer
                `Entry.objects.defer("body")`: only access the body field when you use the `body` field to optimize the performance
            * Methods that do not return QuerySets
            `get, create, get_or_create`
            * [Field lookups](./queryset_method_reference.md#Field lookups)
                * exact
                * date
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
