[rest-framework官网](https://www.django-rest-framework.org/)
<head>
  <title>rest-framework</title>
</head>

## [Views](./view.md)

## Generic Views
## GenericAPIView
### Methods
* `get_serializer(self, instance=None, data=None, many=False, partial=False)`  
返回serializer。
```
def get_serializer(self, *args, **kwargs):
    """
    Return the serializer instance that should be used for validating and
    deserializing input, and for serializing output.
    """
    serializer_class = self.get_serializer_class()
    kwargs['context'] = self.get_serializer_context()
    return serializer_class(*args, **kwargs)
```
* `filter_queryset(self, queryset)`
```
for backend in list(self.filter_backends):
    queryset = backend().filter_queryset(self.request, queryset, self)
return queryset
```
    * DjangoFilterBackend
    ```
    def get_filterset(self, request, queryset, view):
        filterset_class = self.get_filterset_class(view, queryset)
        if filterset_class is None:
            return None
        kwargs = self.get_filterset_kwargs(request, queryset, view)
        return filterset_class(**kwargs)

    def get_filterset_class(self, view, queryset=None):
        """
        return the `FilterSet` class used to filter the queryset
        """
        filterset_class = getattr(view, 'filterset_class', None)
        filterset_fields = getattr(view, 'filterset_fields', None)
        if filterset_class:
            使用这个filterset_class
        if filterset_fields and queryset is not None:
            MetaBase = getattr(self.filterset_base, "Meta", object)

            class AutoFilterSet(self.filterset_base):
                class Meta(MetaBase):
                    mode = queryset.model
                    fileds = filterset_fields
            return AutoFilterSet
        return None

    def filter_queryset(self, request, queryset, view):
        filterset = self.get_filterset(request, queryset, view)
        if filterset is None
            return queryset
        if not filterset.is_valid() and self.raise_exception:
            raise utils.translate_validation(filterset.errors)
        return filterset.qs
    ```

### Mixins
[官网](https://www.django-rest-framework.org/api-guide/generic-views/#mixins)
* ListModelMixin
```
class ListModelMixin(object):
    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())
        page = self.paginate_queryset(queryset)
        if page is not None
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)
```
* CreateModalMixin  
如果成功，返回201以及创建好的数据。如果数据里面有url，就在header里面加location [参考](https://en.wikipedia.org/wiki/HTTP_location)
```
class CreateModalMixin(object):
    """
    Create a model instance.
    """
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def perform_create(self, serializer):
        serializer.save()

    def get_success_headers(self, data):
        try:
            return {'Location': str(data[api_settings.URL_FIELD_NAME])}
        except (TypeError, KeyError):
            return {}
```
* RetrieveModelMixin
```
class RetrieveModelMixin(object):
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
```

## [ViewSets](https://www.django-rest-framework.org/api-guide/viewsets/)
```
class UserViewSet(viewsets.ViewSet):
    
from rest_framework import mixins
from rest_framework import viewsets

class MyViewSet(mixins.RetrieveModelMixin,
                viewsets.GenericViewSet)
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


## [serializer序列化](./serializer.md)
### ModelSerializer

## Authentication
### TokenAuthentication
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


## [Filter过滤](./filter.md)
## [request and response](./request_and_response.md)
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
