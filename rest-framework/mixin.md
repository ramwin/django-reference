

### Mixin

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


