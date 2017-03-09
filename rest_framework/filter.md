#### Xiang Wang @ 2017-03-01 10:04:45

## 基础
```
    pip install django-filter
    import django_filters
    class MyFilter(django_filters.rest_framework.FilterSet):
        type = django_filters.NumberFilter(name="type", lookup_expr="gte")
        name = django_filters.CharFilter(name='name')
        class Meta:
            model = models.Model
            fields = ("type", "name")
    class MyView(ListAPIView):
        filter_class = MyFilter
```

## 参数
* `lookup_expr` 查找的时候的后缀添加属性
