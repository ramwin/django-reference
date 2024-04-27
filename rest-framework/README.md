# django rest framework
## [Views](./view.md)

```{toctree}
./view.md
```

## [Mixin](./mixin.md)

```{toctree}
./mixin.md
```

## [ViewSets](https://www.django-rest-framework.org/api-guide/viewsets/)

* 基础

```
    class UserViewSet(viewsets.ViewSet):
        
    from rest_framework import mixins
    from rest_framework import viewsets

    class MyViewSet(mixins.RetrieveModelMixin,
                    viewsets.GenericViewSet)
```

### [添加额外接口 Marking extra actions for routing][extra-action]

```python
from rest_framework.decorators import action
@action(detail=True, methods=["post"], url_path='customer')
def set_password(self, request):
    return
```

* `url_path`  
action对应的url, 默认为函数名称


```python
def decorator(func): 
    ...
    func.url_path = url_path if url_path else func.__name__
    func.url_name = url_name if url_name else func.__name__.replace('_', '-')
    ...
return decorator
```

* [路径里添加额外的参数](https://stackoverflow.com/questions/50425262/django-rest-framework-pass-extra-parameter-to-actions/72187999#72187999)
```python
@action(detail=True, methods=["GET"],
        url_path="parameters/(?P<my_pk>[^/.]+)")
def parameters(self, request, *args, **kwargs):
    print(kwargs["my_pk"])
```


### ViewSet actions
通过`self.action`可以知道当前的请求的状态，根据这个状态来判断不同的序列化类
list|create|retrieve|update|partial_update|destroy
```
class Permission(BasePermission):
    def has_permission(self, request, view):
        if view.action == "destroy":  # ViewSet才有action这个属性，不可用于APIView
            return False

from rest_framework import viewsets
from rest_framework import mixins
class APIViewSet(mixins.CreateModalMixin, GenericViewSet):
    def get_serializer_class(self):
        if self.action == 'create':
            return CreateSerializerClass
        return self.serializer_class
    def create(self, request):
    def retrieve(self, request, pk=None):
```


## Routers

```python
from rest_framework import routers
router = routers.DefaultRouter()
router.register(r'model', ModelViewSet)
urlpatterns = router.urls
```

## serializer序列化
```{toctree}
./serializer.md
```

### ModelSerializer

## Validators
```
def f(x):
    if x % 2 != 0:
        raise serializers.ValidationError(f"{x} is not an even number")

class Greater:
    def __init__(self, base):
        self.base = base
    def __call__(self, value):
        if value < self.base:
            raise serializers.ValidationError(f"{value} is too small')
field_name = models.Integer(Field validators=[f, Greater(4)])
```

## Authentication

### TokenAuthentication
安装
```
INSTALLED_APPS = [
    ...
    "rest_framework.authtoken",
]
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework.authentication.BasicAuthentication",
        "rest_framework.authentication.SessionAuthentication",
        "rest_framework.authentication.TokenAuthentication",
    ]
}
```

## [Permissions权限](https://www.django-rest-framework.org/api-guide/permissions/)
* 自定义Permission
```python
from rest_framework.permissions import BasePermission
class MyPermission(BasePermission):
    def has_permission(self, request, view):
        ...
    def has_object_permission(self, request, view, obj):
        ...
        可以return False 这样 response就是 {"detail": "您没有..权限"}
        或者 raise PermissionDenied({"message": "账户过期"})
```
* [ ] permission支持逻辑上的and, or, not操作
* AllowAny
这个没啥用, 因为你可以直接设置成为`permission_classes=[]`. 但是用了他你可以显式地生命这个view是allowany的
* IsAuthenticated
```
return bool(request.user and request.user.is_authenticated)
```
* IsAdminUser
```
return bool(request.user and request.user.is_staff)
```
* IsAuthenticatedOrReadOnly
```
return bool(
    request.method in SAFE_METHODS or
    request.user and request.user.is_authenticated
)
```
* [ ] djangorestframework可以和django的permission结合


## Filter过滤

```{toctree}
./filter.md
```

## Pagination
[分页](https://www.django-rest-framework.org/api-guide/pagination/#pagenumberpagination)

```
from rest_framework.pagination import PageNumberPagination

class MyPageNumberPagination(PageNumberPagination):
    page_size = 20
```

## request and response
```{toctree}
./request_and_response.md
```

## throtte限速 [官网](https://www.django-rest-framework.org/api-guide/throttling/)
    ```
    from rest_framework.throttling import BaseThrottle, ScopedRateThrottle
    class MyThrottle(BaseThrottle):
        def allow_request(self, request, view):
            return True or False
        def wait(self):
            return 50
    ```
    * ScopedRateThrottle:
        1. view 里面加入属性 throttle_scope = "自己定义一个scope, 同一个scope共享throlle"
        2. settings 里面添加这个scop的条数限制

## 基础  
    from rest_framework import permissions
    class IsOwner(permissions.BasePermission):
        def has_permission(self, request, view):
            return True  # 这个一定会执行
        def has_object_permission(self, request, view, obj):
            return job.user == request.user # 这个要调用self.chech
    class View(GenericAPIView):
        permission_classes = (IsOwner,)
        def post(self, request):
            self.check_object_permissions(request, obj)

## Exceptions
* `rest_framework.exceptions.ValidationError`
* `rest_framework.exceptions.PermissionDenied`
* `raise rest_framework.exceptions.Throttled(second)`: `raise Throttled(30)`

## Testing
### APIClient
```
from rest_framework.test import APIClient
client = APIClient()
res = client.post("/notes/", {"title": "new idea"}, format="json")
self.assertEqual(res.status_code, 201)
self.assertEqual(res.json()["id"], 1)
```

## Settings
默认配置
```
    REST_FRAMEWORK = {
        'DEFAULT_AUTHENTICATION_CLASSES': (
            'rest_framework.authentication.TokenAuthentication',
            'rest_framework.authentication.BasicAuthentication',
            # 'rest_framework.authentication.SessionAuthentication',
            "rest_extensions.authentication.SessionAuthentication",
        ),
        "DEFAULT_RENDERER_CLASS": {
            "rest_framework.renderers.JSONRenderer",
            "rest_framework.renderers.TemplateHTMLRenderer",
            "rest_framework.renderers.BrowsableAPIRenderer",
        },
        'DEFAULT_FILTER_BACKENDS': (
            'django_filters.rest_framework.DjangoFilterBackend',
            'rest_framework.filters.OrderingFilter',
            'rest_framework.filters.SearchFilter',  # 需要在viewset设置了search_fields才会生效哦
        ),
        "DEFAULT_PERMISSION_CLASSES": (
            "rest_framework.permissions.IsAuthenticated",
        ),
        "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
        "PAGE_SIZE": 10,
    }
```

## 其他
* [swagger](http://api-docs.easemob.com/#/)


[extra-action]: https://www.django-rest-framework.org/api-guide/viewsets/#marking-extra-actions-for-routing
[settings]: https://www.django-rest-framework.org/api-guide/settings/
