**Xiang Wang @ 2016-09-23 10:55:46**


[ ] Quick Overview

### HttpRequest objects
```
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
    * `GET`: 返回GET的参数, ImmutableDict
    * `body`: 返回二进制内容
    * `POST`: 类似GET, 用于POST的方法
    * `FILES`: 获取文件
        request.FILES.getlist("images") 获取上传的图表列表 `django.core.files.uploadedfile.InMemoryUploadedFile`
    * `django.core.files.uploadedfile.InMemoryUploadedFile`:
        * name: 返回文件名
        * read(): 返回二进制内容
* 方法
    * `get_full_path`: `/reqres/request/?key=bar`

* cookie: `request.COOKIES`

* 其他
    * `request.META['REMOTE_ADDR']`  # 获取IP地址

### [QueryDict][QueryDict]
django.http.request.QueryDict, 是一个MultiValueDict
```python
query = QueryDict('a=1&a=2&b=3')
query['a'] == '2'
query.getlist('a') == ['1', '2']
query.getlist('c') == []
```
* copy: 用来把request.POST的数据copy, 这样才能修改
* get/__getitem__: 返回最后一个的值
* getlist(key, default=None)
必定返回list或者default的值

### [response](https://docs.djangoproject.com/en/3.1/ref/request-response/)

##### [参数](https://docs.djangoproject.com/en/1.11/ref/request-response/#httpresponse-objects)
* content
* charset
* status_code

#### JsonResponse
```
from django.http import JsonResponse
response = JsonResponse({"foo": "bar"})
```

#### 返回文件
```
    from django.http import FileResponse
    response = FileResponse(open('filename', 'rb'))
    response['Content-Disposition'] = 'attachment;filename="result.xlsx"'  # 告诉浏览器文件的文件名
    response['Content-Length'] = tmp_file.tell()  # 告诉浏览器文件的大小
    return response
```

#### 返回csv
```
    from django.http import HttpResponse
    from import csv

    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="somefilename.csv"'
    write = csv.write(response)
    write.writerow(['Firstrow', 'Foo', 'Bar', 'Baz'])
    write.writerow(['Second row', 'A', 'B', 'C', '"Testing"'])
```

#### 设置cookie
    a = HttpResponse('ok')
    a.set_cookie('foo', value='bar')
    return a


#### 重定向(HttpResponseRedirect)
```
from django.http import HttpResponseRedirect
return HttpResponseRedirect('http://www.ramwin.com')

from django.views.generic.base import Redirectiew
path(".*$", Redirectiew.as_view(url="/home"), namespace="other")
```

[QueryDict]: https://docs.djangoproject.com/en/4.2/ref/request-response/#querydict-objects
