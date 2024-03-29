*Xiang Wang @ 2017-03-01 10:04:45*

# DjangoFilterBackend
```
def get_filterset(self, request, queryset, view):
    filterset_class = self.get_filterset_class(view, queryset)
    if filterset_class is None:
        return None
    kwargs = self.get_filterset_kwargs(request, queryset, view)
    return filterset_class(**kwargs)
def get_filterset_class(self, view, queryset=None):
    """
    return the `FilterSet` class used to filter the queryset
    """
    filterset_class = getattr(view, 'filterset_class', None)
    filterset_fields = getattr(view, 'filterset_fields', None)
    if filterset_class:
        使用这个filterset_class
    if filterset_fields and queryset is not None:
        MetaBase = getattr(self.filterset_base, "Meta", object)

        class AutoFilterSet(self.filterset_base):
            class Meta(MetaBase):
                mode = queryset.model
                fileds = filterset_fields
        return AutoFilterSet
    return None
def filter_queryset(self, request, queryset, view):
    filterset = self.get_filterset(request, queryset, view)
    if filterset is None
        return queryset
    if not filterset.is_valid() and self.raise_exception:
        raise utils.translate_validation(filterset.errors)
    return filterset.qs
```

# django-filter基础
[官网](https://django-filter.readthedocs.io/en/master/index.html)

```python
pip install django-filter
import django_filters
class MyFilter(django_filters.rest_framework.FilterSet):
    type = django_filters.NumberFilter(name="type", lookup_expr="gte")
    name = django_filters.CharFilter(name='name')
    has_reply = django_filters.BooleanFilter(method='filter_reply')
    order_by = django_filters.OrderingFilter(
        fields=(
            ("level", "level"),  # 前面的代表在queryset用的，后面的代表在params里用的
            ("customer__focus", "customer__focus"),
        )
    )
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

# core arguments
* `field_name` 查找哪个字段
* `lookup_expr` 查找的时候的后缀添加属性
* `help_text` 备注信息
* `required` 默认False，是否需要。如果为True的话，就会返回空的queryset
* `method` 使用哪个方法来过滤
    ```
    inbox = django_filters.BooleanFilter(method="filter_inbox")  # 如果是BooleanFilter, 那么 MyFilter({'inbox': 'false'}, queryset).qs 会导致无法过滤。必须validated_data才能进行过滤
    # TODO 如果是前端传递的bool值，会怎么样。rest-framework会进行validate吗

    def filter_inbox(self, queryset, name, value):
        return queryset
    ```
* `exclude` 是否要用exclude


# Filter


## [所有的filter](https://django-filter.readthedocs.io/en/master/ref/filters.html)
```
def filter_queryset(self, queryset):
    for name, value in self.form.cleaned_data.items():
        queryset = self.filters[name].filter(queryset, value)
        assert isintance(queryset, models.QuerySet)
    return queryset
```

### MultiChoiceFilter [官网](https://django-filter.readthedocs.io/en/master/ref/filters.html#multiplechoicefilter)
使用了多重过滤,以后输入 `url?_type=类型1&_type=类型2` 就能过滤几个url
```
_type = django_filters.MultipleChoiceFilter(
    choices=models.TestFilter.TYPE_CHOICE
)
/django_filters/filters.py line 231
class MultipleChoiceFilter(Filter):
    def filter(self, qs, value):
        ...
        for v in set(value):
            if v == self.null_value:
                v = None
            predicate = self.get_filter_predicate(v)
            if self.conjoined:
                qs = self.get_method(qs)(**predicate)
            else:
                q |= Q(**predicate)
        if not self.conjoined:
            qs = self.get_method(qs)(q)
        return qs.distinct() if self.distinct else qs
        ...
    def get_filter_predicate(self, v):
        name = self.field_name
        if name and self.lookup_expr != 'exact':
            name = LOOKUP_SEP.join([name, self.lookup_expr])
        try:
            return {name: getattr(v, self.field.to_field_name)}
        except (AttributeError, TypeError):
            return {name: v}
```

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

* BooleanFilter [参考](http://django-filter.readthedocs.io/en/master/ref/filters.html#booleanfilter)
    ```
    def filter_bool(self, queryset, name, value):
        # 前端必须传递 True 和 False 的首字母大写字符串。如果传递错了，就不进行过滤
        assert value in [True, False]
    ```

* IsoDateTimeFilter [参考](https://django-filter.readthedocs.io/en/1.1.0/ref/filters.html#isodatetimefilter)
    * 示例
        ```
        {'time__gt': '2017-12-11T11:19:28+00:00'} # 这种标准的格式肯定没有问题的
        {'time__gt': '2017-12-11 08:19:27'}  # 这种不标准的格式就会默认当作当前时区，所以就算是传递的 08 时，这个00UTC时的数据也会显示出来
        ```

### [RangeFilter](https://django-filter.readthedocs.io/en/master/ref/filters.html#rangefilter)
* 用法
```
    class F(FilterSet):
        """Filter for Books by Price"""
        price = RangeFilter()

        class Meta:
            model = Book
            fields = ['price']
      
    qs = Book.objects.all().order_by('title')

    # Range: Books between 5€ and 15€
    f = F({'price_min': '5', 'price_max': '15'}, queryset=qs)

    # Min-Only: Books costing more the 11€
    f = F({'price_min': '11'}, queryset=qs)

    # Max-Only: Books costing less than 19€
    f = F({'price_max': '19'}, queryset=qs)
```

* 原理

### DateFromToRangeFilter
* 用法
````
    class F(FilterSet):
        date = DateFromToRangeFilter()

        class Meta:
            model = Comment
            fields = ['date']

    f = F({'date_after': '2016-01-01', 'date_before': '2016-02-01'})
```

