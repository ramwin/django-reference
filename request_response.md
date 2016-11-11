#### Xiang Wang @ 2016-09-23 10:55:46

# 基础

## request
    request.GET['key']
    request.POST['key']
    json.loads(request.read().encode(request.encoding))
    file = request.FILES['file'].read()  # 获取文件
    file_name = file

### 获取cookie
    request.COOKIES

### 其他
    request.META['REMOTE_ADDR']  # 获取IP地址


## response

### 返回文件
    from django.http import FileResponse
    response = FileResponse(open('filename', 'rb'))
    response['Content-Disposition'] = 'attachment;filename="result.xlsx"'  # 告诉浏览器文件的文件名
    response['Content-Length'] = tmp_file.tell()  # 告诉浏览器文件的大小
    return response

### 设置cookie
    a = HttpResponse('ok')
    a.set_cookie('foo', value='bar')
    return a
