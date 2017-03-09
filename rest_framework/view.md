#### Xiang Wang @ 2016-10-08 10:38:43

# APIView
## 基础

    from rest_framework.views import APIView
    from rest_framework.generics import GenericAPIView
    from rest_framework.generics import ListCreateAPIView

## 参数  
    http_method_names = ['post','get']  # 设置允许的请求方法  
    `self.kwargs['key']  # 获取url里面的参数`

# GenericAPIView
```
    def get_serializer(instance, *args, **kwargs):
        serializer_class = self.get_serializer_class()
        kwargs['context'] = self.get_serializer_context()
        return serializer_class(*args, **kwargs)

    def get_serializer_class(self):
        return self.serializer_class

    def get_serializer_context(self):
        return {
            'request': self.request,
            'format': self.format_kwarg,
            'view': self
        }

    def get_object(self):
        ...
        self.check_object_permissions(self.request, obj)
```

# 常用的需要修改的方法

2. `GenericAPIView.get_queryset`  # 可能你需要根据请求来过滤
1. `GenericAPIView.get_serializer_class`  # 可能你要根据request调用不同的序列化类，默认是 `self.serializer_class`
```
    def get_serializer_class(self):
        if self.request.method == "GET":
            return serializers.VoteListSerializer
```

# ListCreateAPIView
* GET请求顺序
```
    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())
    def filter_queryset(self, queryset):
        queryset = backend().filter_queryset(self.request, queryset, self)
    def get_queryset(self):
        return self.queryset
```
* POST请求顺序
```
    1. ListCreateAPIView.post  # 没有什么操作
    2. CreateModelMixin.create(self, request, *args, **kwargs)  # 验证数据

    serializer = self.get_serializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    self.perform_create(serializer)
    headers = self.get_success_headers(serializer.data)
    return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    1. CreateModelMixin.perform_create  # serializer.save()  如果要save后进行其他操作，修改这个函数
```

# CreateAPIView
* POST请求顺序
    1. CreateAPIView.post  # 没有什么操作
    2. CreateModelMixin.create  # 验证数据


# RetrieveAPIView
```
    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)
    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        lookup_url_kwarg = self.lookup_url_kwarg or self.lookup_field
        assert lookup_url_kwarg in self.kwargs, (
            'Expected view %s to be called with a URL keyword argument '
            'named "%s". Fix your URL conf, or set the `.lookup_field` '
            'attribute on the view correctly.' %
            (self.__class__.__name__, lookup_url_kwarg)
        )
        filter_kwargs = {self.lookup_field: self.kwargs[lookup_url_kwarg]}
        obj = get_object_or_404(queryset, **filter_kwargs)
        self.check_object_permissions(self.request, obj)
        return obj
```

# DestroyAPIView
* DELETE请求顺序

# DestroyAPIView
```
    self.delete(self, request, *args, **kwargs)
    self.destroy(self, request, *args, **kwargs)
```

# UpdateAPIView
```
    def patch(self, request, *args, **kwargs)
    self.partial_update(request, *args, **kwargs)
        kwargs['partial'] = True
    self.update(request, *args, **kwargs)
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request, data, partial=partial)
```
