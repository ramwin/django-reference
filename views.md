#### Xiang Wang @ 2016-08-23 10:56:40

## 获取请求的文件
    request.FILES['file']
## csrf
    from django.views.decorators.csrf import csrf_exempt
    @csrf_exempt
    def view(request):
        return HttpResponse('csrf')
