# django_reference
A quick reference  for django

# 基础
* [用户认证](./auth认证模块.md)
* [管理员](./admin.md)
* [URL分配](./urls.md)
* [Model数据库基础](./models_type数据类型.md)
* [Model数据库方法](./models_action数据操作.md)
* [View视图](./views.md)
* [classbaseview预定义视图](./classbaseView.md)
* [请求request和返回response](./request_response.md)
* [templates模板](./templates模板.md)
* [Exceptions错误](./exceptions错误.md)
* [其他工具utils](./utils.md)
* [validator表单验证](validator表单验证.md)
* [rest_framework框架](./rest_framework/README.md)
    * [swagger效果](http://api-docs.easemob.com/#/)
* [信号](./signal信号.md)
* [form](./form.md)
    * 属性
        * errors  *具体的报错信息*
    * 方法
        * `clean()`  *其实就是调用了clean_data*
* url
    ```
    from django.urls import reverse
    >>> reverse('reqres:ajax')
    /reqres/ajax/
    ```

# 其他
* [自定义指令](./command自定义指令.md)
* [uwsgi部署](./uwsgi部署.md)
