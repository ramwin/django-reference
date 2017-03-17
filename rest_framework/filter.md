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
* `method` 使用哪个方法来过滤
