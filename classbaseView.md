*Xiang Wang @ 2016-08-04 19:02:28*

**ClasssBase View API**
[官网](https://docs.djangoproject.com/en/3.0/ref/class-based-views/)

### 基础
* 基础
```
from django.views.generic import View, ListView, DetailView, TemplateView
class ListView(ListView):
    model = Publisher
    template_name = 'appname/templates.html'
    paginate_by = 2 # 每页的数量
    http_method_names = ['get']
    context_object_name = 'my_favorite_publishers'  # 渲染用的名称

    def get_context_data(self):
        return {
            "paginator",
            "page_obj",
            "is_paginated",
            "object_list",
            "<modelname>_list",
        }
```

### Base Views
* View
    * 参数
        * http_method_names = ["get", "post"]   # 支持的参数
            * 默认 ['get', 'post', 'put', 'patch', 'delete', 'head', 'options', 'trace']
    * 方法
        * get
* TemplateView
    * 参数
        * template_name = "appname/filename.html"  # 使用哪个html渲染
    * 方法
        * `get_context_data`
            * 返回一个dict, 用于渲染
            * 预定义的方法只是把view这个对象交给context['view']并没有其他操作
* RedirectView
```
from django.views.generic.base import RedirectView
path('go-to-django/', RedirectView.as_view(url='https://djangoproject.com'), name='go-to-django'),
```

### Generic display views
* ListView
```
def get(self, request, *args, **kwargs):
    self.object_list = self.get_queryset()
    allow_empty = self.get_allow_empty()
    if not allow_empty:
        if self.get_paginate_by(self.object_list) is not None and hasattr(self.object_list, 'exists'):
            is_empty = not self.objects.exists()
        else:
            is_empty = len(self.object_list) == 0
        if is_empty:
            raise Http404(_("字符串"))
    context = self.get_context_data()
    return self.render_to_response(context)
```
* [DetailView](https://docs.djangoproject.com/en/1.11/ref/class-based-views/generic-display/#detailview)
```
from django.views.generic.detail import DetailView
class ArticleDetailView(DetailView):
    model = Article
```

### Generic editing views
* [CreateView](https://docs.djangoproject.com/en/3.0/ref/class-based-views/generic-editing/#createview)
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
        1. `FormMixin.get_form(self, form_class=None)`
            ```
            if form_class is None:
                form_class = self.get_form_class()
            return form_class(**self.get_form_kwargs())
            ```
        2. `ModelFormMixin.get_form_kwargs`:
            ```
            kwargs = super(ModelFormMixin, self).get_form_kwargs()
            if hasattr(self, 'object'):
                kwargs.update({'instance': self.object})
            return kwargs
            ```
        3. `FormMixin.get_form_kwargs(self)`:
            ```
            kwargs = {                                  
                'initial': self.get_initial(),          
                'prefix': self.get_prefix(),            
            }                                           
                                                        
            if self.request.method in ('POST', 'PUT'):  
                kwargs.update({                         
                    'data': self.request.POST,          
                    'files': self.request.FILES,        
                })                                      
            return kwargs                               
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

* [UpdateView](https://docs.djangoproject.com/en/1.11/ref/class-based-views/generic-editing/#updateview)
    * 参数
    * 执行过程
        ```
        def self.post(self, request, *args, **kwargs)
            self.object = self.get_object()
            return super(BaseUpdateView, self).post(request, *args, **kwargs)
        def BaseUpdateView.post(self, request, *args, **kwargs)
            form = self.get_form()
            if form.is_valid():
                return self.form_valid(form)
        def form_valid(self, form):
            self.object = form.save()
            return super(ModelFormMixin, self).form_valid(form)
        ```


### Class-based views mixins

#### Simple mixins
* Context mixins
    * extra_context: `TemplateView.as_view(extra_context={"title": "Common Title"})`
    * get_context_data:  
    ```
    from django.views.generic.base import ContextMixin
    def get_context_data(self, **kwargs):
        if "view" not in kwargs:
            kwargs["view"] = self
        return kwargs
    def get_context_data(self, **kwargs):
        context = super(TemplateView, self).get_context_data(**kwargs)
        context["number"] = random.randrange(1, 100)
        return context
    ```
* TemplateResponseMixin
`django.views.generic.base.TemplateResponseMixin`
    * get_template_names()
    返回一个template的列表用于渲染
    ```
    def get_template_names(self):
        if self.template_name is None:
            raisee ImproperlyConfigured(
                "TemplateResponseMixin requires either a definition of "
                "'template_name' or an implementation of 'get_template_names()'")
        else:
            return [self.template_name]
    ```
    如果要自定义template, 根据url返回
    ```
    def get_template_names(self):
        if self.request.resolver_match.kwargs["scene"] == "admin":
            return ["admin_template.html"]
        else:
            return super(View, self).get_template_names()
    ```


#### Editing mixins
* [FormMixin](https://docs.djangoproject.com/en/3.0/ref/class-based-views/mixins-editing/#formmixin): `django.views.generic.edit.FormMixin`
    * `form_valid`: redirects to get_success_url()
    ```
    return HttpResponseRedirect(self.get_success_url())
    ```
    * `form_invalid`:
    ```
    return self.render_to_response(self.get_context_data(form=form))
    ```
* ModelFormMixin(FormMixin, SingleObjectMixin): `django.views.generic.edit.ModelFormMixin`
    * form_valid
    ```
    def form_valid(self, form):
        self.object = form.save()
        return super().form_valid(form)
    ```
    * get_success_url: 数据创建成功后跳转的页面
    ```
    def get_success_url(self):
        if self.success_url:
            url = self.success_url.format(**self.object.__dict__)
        else:
            try:
                url = self.object.get_absolute_url()
            except AttributeError:
                raise ImproperlyConfigured("...")
        return url
    ```
