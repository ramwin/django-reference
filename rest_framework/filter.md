#### Xiang Wang @ 2017-03-01 10:04:45

## 基础
```
    pip install django-filter
    import django_filters
    class MyFilter(django_filters.rest_framework.FilterSet):
        type = django_filters.NumberFilter(name="type", lookup_expr="gte")
        name = django_filters.CharFilter(name='name')
        has_reply = django_filters.BooleanFilter(method='filter_reply')
        def filter_reply(self, queryset, name, value):
            if value is True:
                return queryset.exclude(reply="")
            else:
                return queryset.filter(reply="")

        class Meta:
            model = models.Model
            fields = ("type", "name")
    class MyView(ListAPIView):
        filter_class = MyFilter
    queryset = MyFilter({'type': 'type1'}, models.Model.objects.all()).qs
```

## 参数
* `name` 查找哪个字段
* `lookup_expr` 查找的时候的后缀添加属性
* `help_text` 备注信息
* `required` 默认False，是否需要。如果为True的话，就会返回空的queryset
* `method` 使用哪个方法来过滤
    ```
    inbox = django_filters.BooleanFilter(method="filter_inbox")

    def filter_inbox(self, queryset, name, value):
        return queryset
    ```


## Filter


### [所有的filter](http://django-filter.readthedocs.io/en/develop/ref/filters.html)
* ModelChoiceFilter [参考](http://django-filter.readthedocs.io/en/develop/ref/filters.html#modelchoicefilter)
```
    author = django_filters.ModelChoiceFilter(queryset=Author.objects.all())
    def myqueryset(request):
        return request.user.friends.all()
    user = django_filters.ModelChoiceFilter(queryset=myqueryset)  # 当然也可以自定义一个queryset函数，必须接受一个request参数
```

* ChoiceFilter [参考](https://django-filter.readthedocs.io/en/develop/ref/filters.html#choicefilter)
    ```
    STATUS_CHOICES = (
        (0, 'regular'),
        (1, 'manager'), 
        (2, 'admin'),
    )
    status = ChoiceFilter(choices=STATUS_CHOICES)
    ```

* BooleanFilter [参考](http://django-filter.readthedocs.io/en/develop/ref/filters.html#booleanfilter)
    ```
    ```
