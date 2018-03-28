#### Xiang Wang @ 2017-01-23 14:05:03

*A quick reference  for django*

# 基础
## [管理员 & admin界面](./admin.md)
## [用户认证 user auth and login](./auth认证模块.md)
## [cache缓存](https://docs.djangoproject.com/en/2.0/topics/cache/)
```
from django.core.cache import cache
from django.core.cache import caches

cache.set('foo', 'bar', timeout=3600)
cache = caches['thirdparty']
cache.set('foo', 'bar', timeout=3600*24*60)
cache.get('cache_list', [])  # 没有默认值就返回None
```
## [URL分配](./urls.md)
## [Model基础参考](./models_type数据类型.md)
## [queryset参考](./models_action数据操作.md)
## [View视图](./views.md)
## [classbaseview预定义视图](./classbaseView.md)
## [请求request和返回response](./request_response.md)
## [templates模板](./templates模板.md)
## [Exceptions错误](./exceptions错误.md)
## [其他工具utils](./utils.md)
## [validator表单验证](validator表单验证.md)
## [rest_framework框架](./rest_framework/README.md)
* ### [swagger效果](http://api-docs.easemob.com/#/)
* ### [serializer序列化](./rest_framework/serializer.md)
* ### [filters](./rest_framework/filter.md)
* ### [views](./rest_framework/view.md)

## [信号](./signal信号.md)
## [form](./form.md)
* 属性
    * errors  *具体的报错信息*
* 方法
    * `clean()`  *其实就是调用了clean_data*

## url
    ```
    from django.urls import reverse
    >>> reverse('reqres:ajax')
    /reqres/ajax/
    ```
## unittest单元测试
* [assertions](https://docs.djangoproject.com/en/1.11/topics/testing/tools/#assertions)
## [自定义指令](./command自定义指令.md)
```
from django.core.management.base import OutputWrapper
from django.core.management.color import color_style
out = OutputWrapper(sys.stdout)
style = color_style()
out.write(style.SUCCESS(serializer.data))
```
## [uwsgi部署](./uwsgi部署.md)
