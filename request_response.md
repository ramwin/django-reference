#### Xiang Wang @ 2016-09-23 10:55:46


# request
```
    request.GET['key']
    request.POST['key']
    request.POST.getlist('multi_select')  # 获取一个多选的select的数值
    request.method == "GET" | "POST"
    json.loads(request.read().encode(request.encoding))
    file = request.FILES['file']  # 获取文件, 里面的file是你在form里面设置的name
        name: 文件名 - portriat.png
        read(): 读取文件的二进制数据(内存占用很大)
        chunks(): 一个迭代器
        size: 文件字节数
```
* 参数
    * `path`: `/reqres/request/`
* 方法
    * `get_full_path`: `/reqres/request/?key=bar`

## 获取cookie
    request.COOKIES

## 其他
    request.META['REMOTE_ADDR']  # 获取IP地址


# response

## [参数](https://docs.djangoproject.com/en/1.11/ref/request-response/#httpresponse-objects)
    * content
    * charset
    * status_code

## 返回文件
```
    from django.http import FileResponse
    response = FileResponse(open('filename', 'rb'))
    response['Content-Disposition'] = 'attachment;filename="result.xlsx"'  # 告诉浏览器文件的文件名
    response['Content-Length'] = tmp_file.tell()  # 告诉浏览器文件的大小
    return response
```
## 返回csv
    from django.http import HttpResponse
    from import csv

    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="somefilename.csv"'
    write = csv.write(response)
    write.writerow(['Firstrow', 'Foo', 'Bar', 'Baz'])
    write.writerow(['Second row', 'A', 'B', 'C', '"Testing"'])

## 设置cookie
    a = HttpResponse('ok')
    a.set_cookie('foo', value='bar')
    return a


## 重定向(HttpResponseRedirect)
    return HttpResponseRedirect('http://www.ramwin.com')
    
