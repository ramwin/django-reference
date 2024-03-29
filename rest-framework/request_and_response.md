**Xiang Wang @ 2017-04-18 11:40:20**


# 基础

## [request][request]
* 属性
    * `_request` 返回django的[request](../request_response.md)
    * `POST` 只会返回 POST 的数据
    * data  
    类型就是 `django.http.request.QueryDict` [参考django的request](../request_response.md)  
    patch, put, post的数据都能获取到
    * `accepted_renderer` *可以用来渲染的类* 
        * `.format` >>> *html, api, json*
        * `.charset` *utf-8*
        ```
        if request.accepted_renderer.format == 'html':
            return HttpResponseRedirect(reverser('houtai:group'))
        ```
    * [query_params](../request_response.md#querydict)
    返回的就是django的QueryDict

## response
```
from rest_framework.response import Response
```
* 定义
    Response(<dict>, status=200)
* 属性
    * `status_code` 状态码
    * `data` 数据
    * `method` 请求方法: GET, POST

[request]: https://www.django-rest-framework.org/api-guide/requests/
