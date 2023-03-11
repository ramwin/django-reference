# [Views][views]

# [Built-int Views][built-in views]
* serve
返回静态文件
```python
from django.conf import settings
from django.urls import re_path
from django.views.static import serve

# ... the rest of your URLconf goes here ...

if settings.DEBUG:
    urlpatterns += [
        re_path(
            r"^media/(?P<path>.*)$",
            serve,
            {
                "document_root": settings.MEDIA_ROOT,
            },
        ),
    ]
urlpatterns += [
    re_path("static/(?P<path>.*)$",
            serve,
            {
                "document_root": settings.STATIC_ROOT,
                "show_indexes": True}),
]
```

## URL
* [URLconfs](./urls.md)
解析url, 反编译url

* [Requests and Response](./request_response.md)  
FILE uploads 文件上传
```
request.FILES['file']
```

## [Class-based View](./classbaseView.md)

## [Middleware](https://docs.djangoproject.com/en/3.1/topics/http/middleware/)
* 编写自己的Middleware
```
def simple_middleware(get_response):
    # One-time configuration and initialization.

    def middleware(request):
        # Code to be executed for each request before
        # the view (and later middleware) are called.

        response = get_response(request)

        # Code to be executed for each request/response after
        # the view is called.

        return response

    return middleware
```

### 内置的middleware
* CommonMiddleware
  * 禁止Disallowed_user_agents访问
  * 自动append_slash和prepend_www
  * 设置Content-Length

## 获取请求的文件
    request.FILES['file']
## csrf
    from django.views.decorators.csrf import csrf_exempt
    @csrf_exempt
    def view(request):
        return HttpResponse('csrf')


[views]: https://docs.djangoproject.com/en/4.2/#the-view-layer
[built-in views]: https://docs.djangoproject.com/en/4.2/ref/views/
