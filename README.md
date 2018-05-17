**Xiang Wang @ 2017-01-23 14:05:03**

*A quick reference  for django*
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
# [Model and Field](./models_type数据类型.md)
# [queryset](./models_action数据操作.md)
# [View](./views.md)
# [classbaseview](./classbaseView.md)
# [Request & Response](./request_response.md)
# [templates](./templates模板.md)
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

# url
    ```
    from django.urls import reverse
    >>> reverse('reqres:ajax')
    /reqres/ajax/
    ```
# unittest
* [assertions](https://docs.djangoproject.com/en/1.11/topics/testing/tools/#assertions)
# [custom command](./command自定义指令.md)
```
from django.core.management.base import OutputWrapper
from django.core.management.color import color_style
out = OutputWrapper(sys.stdout)
style = color_style()
out.write(style.SUCCESS(serializer.data))
```
# [uwsgi deploy](./uwsgi部署.md)
