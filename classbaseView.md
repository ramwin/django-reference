#### Xiang Wang @ 2016-08-04 19:02:28

# 基础
    from django.views.generic import View, ListView, DetailView, TemplateView

class ListView(ListView):
    model = Publisher
    template_name = 'appname/templates.html'
    paginate_by = 2 # 每页的数量
    http_method_names = ['get']
    context_object_name = 'my_favorite_publishers'  # 渲染用的名称

