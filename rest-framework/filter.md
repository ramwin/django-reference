**Xiang Wang @ 2017-03-01 10:04:45**
*django-filter的参考*

# 基础
```python
pip install django-filter
import django_filters
class MyFilter(django_filters.rest_framework.FilterSet):
    type = django_filters.NumberFilter(name="type", lookup_expr="gte")
    name = django_filters.CharFilter(name='name')
    has_reply = django_filters.BooleanFilter(method='filter_reply')
    order_by = django_filters.OrderingFilter(
        fields=(
            ("level", "level"),
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
* `name` 查找哪个字段
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


# Filter


## [所有的filter](https://django-filter.readthedocs.io/en/master/ref/filters.html)

### MultiChoiceFilter [官网](https://django-filter.readthedocs.io/en/master/ref/filters.html#multiplechoicefilter)
使用了多重过滤,以后输入 `url?_type=类型1&_type=类型2` 就能过滤几个url
```
_type = django_filters.MultipleChoiceFilter(
    choices=models.TestFilter.TYPE_CHOICE
)
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
