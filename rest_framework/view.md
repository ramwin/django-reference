#### Xiang Wang @ 2016-10-08 10:38:43

# APIView
## 基础

    from rest_framework.views import APIView
    from rest_framework.generics import ListCreateAPIView

## 参数  
    http_method_names = ['post','get']  # 设置允许的请求方法  
    `self.kwargs['key']  # 获取url里面的参数`


# ListCreateAPIView
* POST请求顺序
    1. ListCreateAPIView.post  # 没有什么操作
    2. CreateModelMixin.create(self, request, *args, **kwargs)  # 验证数据

    serializer = self.get_serializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    self.perform_create(serializer)
    headers = self.get_success_headers(serializer.data)
    return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


    1. CreateModelMixin.perform_create  # serializer.save()

# CreateAPIView
* POST请求顺序
    1. CreateAPIView.post  # 没有什么操作
    2. CreateModelMixin.create  # 验证数据


# DestroyAPIView
* DELETE请求顺序
