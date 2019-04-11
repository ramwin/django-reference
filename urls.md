**URL dispatcher**  

### 目录
[URL dispatcher 官网](https://docs.djangoproject.com/en/2.0/topics/http/urls/)  
[url 工具](https://docs.djangoproject.com/en/2.1/ref/urlresolvers/)  
[URLconfs里用的函数](https://docs.djangoproject.com/en/2.1/ref/urls/#module-django.conf.urls)

### How Django processes a request
1. 查看`ROOT_URLCONF`
2. 寻找urlpatterns
3. 没找到就报错

### python2例子
```
from django.conf.urls import url
urlpatterns = [
    url(),
]
```
* 直接调用：
`ulr(r'^polls/index/$','polls.views.index', name='index'),`
* 间接调用  
`url(r'^polls/', include('polls.urls', namespace="polls")),`
    * 内部调用
        `url( r'^polls/index/$' , 'blog.views.index'),`

```
from django.conf.urls import include, url  # 如果已经是app的url，一般都不需要include了
url(r'^polls/index/$','polls.views.index'),  # 第一个参数是正则表达式,第二个参数
# 但是每个方法的URL不一样，如何做到不大量修改就能重复利用一个app呢：
url(r'^polls/', include('polls.urls')),
# 如果碰巧两个api路径一样的（具体没遇到）用一个namespace来区分就好了：
url(r'^polls/', include('polls.urls', namespace="polls")),
```

* 代码示例
```
url(r'^polls/index/(?P<id>\d{2})/$','index'),
def index(req,id):
    return render_to_response( 'index.html' , { 'id' : id})
# 在index.html里面就可以使用id这个参数了
    <p>the convey of parameter</p>
    <p>id: {{id}}</p>
```

### Example
```
from django.urls import path

from . import views

urlpatterns = [
    path('articles/2003/', views.special_case_2003),
    path('articles/<int:year>/', views.year_archive),
    path('articles/<int:year>/<int:month>/', views.month_archive),
    path('articles/<int:year>/<int:month>/<slug:slug>/', views.article_detail),
]
```

### Path converters
* str: 匹配字符串，除了`/`
* int: 匹配0或者任何正整数
* slug: 字符和数字hyphen, underscore
* uuid
* path: 非空字符串，包括`/`

### Registering custom path converters

### Using regular expressions
[官网](https://docs.djangoproject.com/en/2.2/topics/http/urls/#using-regular-expressions)
使用正则匹配的路径，不管匹配到的结果是什么样的，返回的都是字符串，请务必注意
```
from django.urls import path, re_path
from . import views
urlpatterns = [
    path('articles/2003/', views.special_case_2003),
    re_path(r'^articles/(?P<year>[0-9]{4})/$', views.year_archive),
    re_path(r'^articles/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/$', views.month_archive),
    re_path(r'^articles/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/(?P<slug>[\w-]+)/$', views.article_detail),
]
```

### Including other URLconfs
当django遇到include的时候，它会把当前匹配的url切换，然后把剩下的路径放入include去匹配
```
from django.urls import include, path

urlpatterns = [
    # ... snip ...
    path('community/', include('aggregator.urls')),
    path('contact/', include('contact.urls')),
    # ... snip ...
]
```
当然这个include也可以直接是一个列表传进去。
```
from django.urls import include, path

from apps.main import views as main_views
from credit import views as credit_views

extra_patterns = [
    path('reports/', credit_views.report),
    path('reports/<int:id>/', credit_views.report),
    path('charge/', credit_views.charge),
]

urlpatterns = [
    path('', main_views.homepage),
    path('help/', include('apps.help.urls')),
    path('credit/', include(extra_patterns)),
]
```
这一点在重复利用一个重复的pattern prefix时很有用。比如
```
from django.urls import path
from . import views

urlpatterns = [
    path('<page_slug>-<page_id>/history/', views.history),
    path('<page_slug>-<page_id>/edit/', views.edit),
    path('<page_slug>-<page_id>/discuss/', views.discuss),
    path('<page_slug>-<page_id>/permissions/', views.permissions),
]
# 上面的烂代码可以改写成
from django.urls import include, path
from . import views

urlpatterns = [
    path('<page_slug>-<page_id>/', include([
        path('history/', views.history),
        path('edit/', views.edit),
        path('discuss/', views.discuss),
        path('permissions/', views.permissions),
    ])),
]
```

* 获取参数
included URLonf 会从 parent URLconfs 里面获取参数并传入view
```
# In settings/urls/main.py
from django.urls import include, path
urlpatterns = [
    path('<username>/blog/', include('foo.urls.blog')),
]
# In foo/urls/blog.py
from django.urls import path
from . import views
urlpatterns = [
    path('', views.blog.index),
    path('archive/', views.blog.archive),
]
```


### Passing extra options to view functions 传递额外的变量
`
urlpatterns = [
    path('blog/<int:year>/', views.year_archive, {'foo': 'bar'}),
]
`  
如果访问 `blog/2015/` django就会调用
`views.year_archive(request, year=2015, foo="bar")`
> 如果这个变量和url里面的变量名一致,django要优先使用字典里的变量,而不是url里面的变量

### url工具
[官网](https://docs.djangoproject.com/en/2.1/ref/urlresolvers/#resolve)
* reverse
```
from django.urls import reverse
>>> reverse('reqres:ajax')
/reqres/ajax/
>>> reverse('request:ajax-detail', args=[1])
/reqres/ajax/1/
>>> reverse('request:ajax', kwargs={'pk': 1})
/reqres/ajax/1/
```
* [ ] reverse_lazy
* resolve
```
resolve_match = resolve(url)
resolve_match.name_space
```
    * [ ] urlparse
    * [ ] urlunparse
* [ ] `get_script_prefix`

### TODO
* [ ] Error handling
* [ ] Registering custom path converters
* [ ] What the URLconf searches agains
