**Xiang Wang @ 2016-10-08 10:38:43**

## APIView [官网](https://www.django-rest-framework.org/api-guide/views/)
* 基础
```
from rest_framework.views import APIView
from rest_framework.generics import GenericAPIView
from rest_framework.generics import ListCreateAPIView
from rest_framework.generics import get_object_or_404
```
* 参数  
    * `http_method_names = ['post','get']`  *设置允许的请求方法*
    * `self.kwargs['key']`  *获取url里面的参数*
* 方法
    * `dispatch(self, request, *args, **kwargs)`
    ```
    def dispatch(self, request, *args, **kwargs):
        try:
        except Exception as exc:
            response = self.handle_exception(exc)
        self.response = self.finalize_response(request, response, *args, **kwargs)
        return self.response
    ```
    * `get_permissions(self)`: 返回所有的permission
    ```
    return [permission() for permission in self.permission_classes]
    ```
    * `handle_exception`  
    处理各种`APIException`

## 常用方法
0. `get_object_or_404`
```
from django.http import Http404
def get_object_or_404(queryset, *filter_args, **filter_kwargs):
    """
    Same as Django's standard shortcut, but make sure to also raise 404
    if the filter_kwargs don't match the required types.
    """
    try:
        return _get_object_or_404(queryset, *filter_args, **filter_kwargs)
    except (TypeError, ValueError, ValidationError):
        raise Http404
```

1. `GenericAPIView.get_queryset`  *可能你需要根据请求来过滤*
```
def get_queryset(self):
    if self.request.user.is_superuser:
        return self.queryset.all()
    else:
        return self.queryset.filter(user=self.request.user)
```
2. `GenericAPIView.get_serializer_class`  *可能你要根据request调用不同的序列化类*  
```
def get_serializer_class(self):
    if self.request.method == "GET":
        return serializers.VoteListSerializer
```
3. `DestroyAPIView.perform_destroy`  *你可能要假删除只修改状态*
```
def perform_destroy(self, instance):
    # instance.delete()
    instance.status = 'delete'
    instance.save()
```
4. `GenericAPIView.get_serializer` *可能你要根据这个instance的user是不是request.user来做不同的序列化类*  
```
def get_serializer(self, *args, **kwargs):
    serializer_class = self.get_serializer_class()
    kwargs['context'] = self.get_serializer_context()  # 一般来说这个kwargs是空的
    return serializer_class(*args, **kwargs)
```
5. `GenericAPIView.get_serializer_context`  *可能你要传递额外的数据进去,最常见的就是request.user了，不过这个已经有了*
```
def get_serializer_context(self):
    return {
        "request": self.request,
        "format": self.format_kwarg,  # 尚且不清楚他的用处
        "view": self    # 这个有用，可以在ClassView里面加入类似 level_require 或者 permission_level 然后在序列化类里面做判断
    }
```


## 常用的view
### GenericAPIView
* 代码
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


### ListCreateAPIView
    * GET请求顺序  
        ```
        def list(self, request, *args, **kwargs):
            queryset = self.filter_queryset(self.get_queryset())
            page = self.paginate_queryset(queryset)
            if page is not None:
                serializer = self.get_serializer(page, many=True)
                return self.get_paginated_response(serializer.data)
            serializer = self.get_serializer(queryset, many=True)
            return Response(serializer.data)
        def filter_queryset(self, queryset):
            for backend in list(self.filter_backends):
                queryset = backend().filter_queryset(self.request, queryset, self)
            return queryset
        def paginate_queryset(queryset):
            if self.paginator is None:
                return None
            else:
                return self.paginator.paginate_queryset(queryset, self.request, view=self)

        @property
        def paginator(self):
            if not hasattr(self, '_paginator'):
                if self.pagination_class is None:
                    self._paginator = None
                else:
                    self._paginator = self.pagination_class()
            return self._paginator

        def get_queryset(self):
            return self.queryset
        def get_paginated_response(self, data):
            assert self.paginator is not None
            return self.paginator.get_paginated_response(data)
        def paginator.get_paginated_response(self, data):
            return Response(OrderedDict([
                ('count', self.page.paginator.count),
                ('next', self.get_next_link()),
                ('previous', self.get_previous_link()),
                ('results', data)
            ]))
        ```  
    * [page分页](../pagination.md)
        ```
        self._paginator = self.pagination_class()
        self._paginator.paginate_queryset(queryset, self.request, view=self)
        def paginate_queryset(self, queryset, request, view=None):
            page_size = self.get_page_size(request)
        def get_page_size(self, request):
            if self.page_size_query_param:
                try:
                    return _positive_int(
                        request.query_params[self.page_size_query_param],
                        strict=True,
                        cutoff=self.max_page_size
                    )
                except (KeyError, ValueError):
                    pass

            return self.page_size
        ```

* ### CreateAPIView
    * POST请求顺序  
        ```
        ListCreateAPIView.post  # 没有什么操作
        CreateModelMixin.create(self, request, *args, **kwargs)  # 验证数据
    
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
    
        1. CreateModelMixin.perform_create  # serializer.save()  如果要save后进行其他操作，修改这个函数
        ```

* ### RetrieveAPIView
    ```
    def get(self, request, *args, **kwargs):
        return self.retrieve(request, *args, **kwargs)

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)  # 注意，这里的get_serializer里面没有加入kwargs参数，不然会因为有id这个参数而导致报错
        return Response(serializer.data)
    def get_serializer(self, *args, **kwargs)
        serializer_class = self.get_serializer_class()
        kwargs['context'] = self.get_serializer_context()
        return serializer_class(*args, **kwargs)
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

* ### DestroyAPIView
    ```
    self.delete(self, request, *args, **kwargs)
    self.destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)
    DestroyModelMixin.perform_destroy(instance):
        instance.delete()
    ```

* ### UpdateAPIView
    ```
    def patch(self, request, *args, **kwargs)
        return self.partial_update(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs)
        kwargs['partial'] = True
        return self.update(request, *args, **kwargs)

    self.update(request, *args, **kwargs)
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)
    self.perform_update(serializer)
        serializer.save()
    ```
