#### Xiang Wang @ 2016-08-04 19:02:28

# 基础
    from django.views.generic import View, ListView, DetailView, TemplateView

    class ListView(ListView):
        model = Publisher
        template_name = 'appname/templates.html'
        paginate_by = 2 # 每页的数量
        http_method_names = ['get']
        context_object_name = 'my_favorite_publishers'  # 渲染用的名称

## View
* 参数
    * http_method_names = ["get", "post"]   # 支持的参数
        * 默认 ['get', 'post', 'put', 'patch', 'delete', 'head', 'options', 'trace']
* 方法
    * get

## TemplateView
* 参数
    * template_name = "appname/filename.html"  # 使用哪个html渲染
* 方法
    * `get_context_data`
        * 返回一个dict, 用于渲染
        * 预定义的方法只是把view这个对象交给context['view']并没有其他操作
## ListView
## DetailView
