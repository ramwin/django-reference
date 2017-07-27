#### Xiang Wang @ 2016-08-04 19:02:28

### 基础
    from django.views.generic import View, ListView, DetailView, TemplateView

    class ListView(ListView):
        model = Publisher
        template_name = 'appname/templates.html'
        paginate_by = 2 # 每页的数量
        http_method_names = ['get']
        context_object_name = 'my_favorite_publishers'  # 渲染用的名称

### View
* 参数
    * http_method_names = ["get", "post"]   # 支持的参数
        * 默认 ['get', 'post', 'put', 'patch', 'delete', 'head', 'options', 'trace']
* 方法
    * get

### 常见的view
* TemplateView
    * 参数
        * template_name = "appname/filename.html"  # 使用哪个html渲染
    * 方法
        * `get_context_data`
            * 返回一个dict, 用于渲染
            * 预定义的方法只是把view这个对象交给context['view']并没有其他操作
* ListView
* DetailView
* [CreateView](https://docs.djangoproject.com/en/1.11/ref/class-based-views/flattened-index/#createview)
    1. `BaseCreateView.post(self, request, *args, **kwargs):`  
        ```
        self.object = None
        super
        ```
    2. `ProcessFormView.post(self, request, *args, **kwargs):`  
        ```
        form = self.get_form()
        if form.is_valid():
            return self.form_valid(form)
        else:
            return self.form_invalid(form)
        ```
    3. 如果成功
        1. `ModelFormMixin.form_valid(self, form):`
            ```
            self.object=form.save()
            return super(ModelFormMixin, self).form_valid(form)
            ```
        2. `FormMixin.form_valid(self, form):`  
            `return HttpResponseRedirect(self.get_success_url())`
    4. 如果失败
        1. `FormMixin.form_invalid(self, form):`  
            `return self.render_to_response(self.get_context_data())`
