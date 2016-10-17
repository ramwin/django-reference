#### Xiang Wang @ 2016-09-19 11:22:51

## Request:
    
    request.query_params    # 获取请求参数
    request.data    # 获取请求数据


## View
    from rest_framework.views import APIView
    from rest_framework.response import Response

    class Basic(APIView):
        def get(self, request):
            Response(status=200, data="ok")
