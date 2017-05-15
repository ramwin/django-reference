# django rest framework 参考

* [rest_framework基础](./rest_framework.md)
* [Views](./view.md)
* [serializer序列化](./serializer.md)
* [Permissions权限](./permissions.md)  
* [Filter过滤](./filter.md)
* [request and response](./request_and_response.md)

###### 基础  
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
