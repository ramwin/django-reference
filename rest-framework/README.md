# django rest framework 参考

## [rest-framework基础](./rest-framework.md)
## [Views](./view.md)
## [serializer序列化](./serializer.md)
## [Permissions权限](./permissions.md)  
```python
from rest_framework.permissions import BasePermission
class MyPermission(BasePermission):
    def has_permission(self, request, view):
        ...
    def has_object_permission(self, request, view, obj):
        ...
```
## [Filter过滤](./filter.md)
## [request and response](./request_and_response.md)
## [throtte限速](./throtte.md)
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
