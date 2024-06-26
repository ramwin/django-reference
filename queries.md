* 添加额外字段
    * [官网参考](https://docs.djangoproject.com/en/1.11/ref/models/database-functions/#module-django.db.models.functions.datetime)
    * 代码
    ```
    from django.db.models.functions import ExtractWeekDay
    TestDate.objects.all().annotate(weekday=ExtractWeekDay('date'))
    ```

* 通过不关联的表字段进行过滤
    ```
    visited_ids = Travel.objects.filter(user=uesr).values('interest')
    Interest.objects.exclude(id__in=visited_ids)
    ```

* 时间过滤
    ```
    TestDate.objects.exclude(date__week_day__in=[6,7])  # 只看周六周日的数据
    ```

* 高级搜索
    ```
    from django.db.models import Q
    User.objects.filter(Q(mobile_number='xxx') | Q(username='xxx'))
    ```

# 排序
* 基础
    ```
    User.objects.all().ordey_by('username', 'id')  # 通过2个字段排序
    ```

* 使用索引分页
    ```
    objs = <model>.objects.filter(params)[0]
    objs = <model>.objects.filter(params)[1:]
    # 注意: django的每次query_set的生成并不会去查询数据库，只有调用索引([0],[1:],等)或者类似All, first的时候才会查询数据库。
    # 如果你的 ordering 同时出现了2个数据，调用数据库的时候数据库不能保证调用[0](limit 1)和调用[1:](offset 1)的结果是互斥的。所以就会导致数据重复和丢失
    ```

* 使用 sql 语句查找
    ```
    model.objects.raw("select * from table where id=%s", params=(1,))
    # 请务必使用params而不要自己用format把数字格式话到query里面
    # 这样不用考虑sql注入
    ```

## 原子操作
    ```
    from django.db.models import F
    obj = Model.objects.get(name='test')
    obj.friends = F('friends') + 1
    obj.save()  # 注意哦，每次save都会触发底层的mysql更新，所以save只能执行一次
    ```

# 操作符号

## [官方教程](https://docs.djangoproject.com/en/1.10/ref/models/querysets/#field-lookups)

## 基础
* 过滤: Model.objects.filter()  Model.objects.all()  # 如果是外键，可以使用 user=obj, user=id, user_id=id 这三种方式。 id可以字符串，也可以是数字
* 排除: Model.objects.exclude()  

# 创建数据
* 基础
    ```
    instance = Text(text='text')
    instance.save()
    ```

# delete
* 基础
    ```python
    obj.delete()
    ```
* 关联
    ```
    obj.othermodel_set.clear()  # 删除关联的数据
    obj.readers.remove(*queryset)  # 删除manytomany的字段
    ```
* 例子
    ```python
    from django.db import transaction
    with transaction.atomic():
        # 如果这个时候有其他的代码执行了save，就会报错
        # 但是不能保证这个atomic一定执行，可能是其他的执行
        n = Number.objects.first()
        n.integer += 1
        n.save()
    ```

# aggregation
[官方文档](https://docs.djangoproject.com/en/5.0/ref/models/querysets/#aggregation-functions)

## [Sum](https://docs.djangoproject.com/en/5.0/ref/models/querysets/#sum)
```python
django.db.models[.aggregates].Sum
Student.objects.aggregat(height=Sum("height"))  # {'height': None | 1}

Number.objects.filter(id__lte=3).aggregate(s = Sum('integer'))
{'s': 10}  # 如果没有搜索到，返回的会是None，而不是0哦
```
```{warning}
queryset空或者都是null=True返回的是None, 所以不要用get("height", 4) 要用get("height") or 0
```

## 其他
* [Cheat Sheet](https://docs.djangoproject.com/en/1.11/topics/db/aggregation/#cheat-sheet)
    ```python
    from django.db.models import Avg, Max, FloatField, Count, Min
    Book.objects.all().aggregate(Avg('price'))
    Book.objects.all().aggregate(Max('price'))
    Book.objects.all().aggregate(price_diff=Max('price', output_field=FloatField()) - Avg('price'))
    # https://groups.google.com/forum/#!topic/django-users/QVo-fHwiRks
    pubs = Publisher.objects.annotage(num_books=Count('book'))
    ```
* 对一个queryset创建聚合aggregate
    * [聚合的函数参考](https://docs.djangoproject.com/en/1.11/ref/models/querysets/#aggregation-functions)
        * Avg, Count, Max, Min
* 对queryset里面的每一个item创建annotate
    ```python
    Book.objects.annotate(Count('authors', distinct=True))  # 找到每一本书的作者数量
    # 找到每个商店的最贵的书的价格和最便宜的书的价格
    >>> Store.objects.annotate(min_price=Min('books__price'), max_price=Max('books__price'))
    {'max_price': Decimal('200000.00'), 'min_price': Decimal('3.00')}
    # 查看每家书店的书的名字的种类（并且还去重)
    >>> Store.objects.annotate(c=Count('books__name', distinct=True))[0]
    >>> Publisher.objects.annotate(avg_rating=Avg('book__rating')).filter(book__rating__gt=3.0)
    (<Publisher: A>, 4.5)  # (5+4)/2
    (<Publisher: B>, 2.5)  # (1+4)/2
    >>> Publisher.objects.filter(book__rating__gt=3.0).annotate(avg_rating=Avg('book__rating'))
    (<Publisher: A>, 4.5)  # (5+4)/2
    (<Publisher: B>, 4.0)  # 4/1 (book with rating 1 excluded)
    Author.objects.values('name').annotate(average_rating=Avg('book__rating'))
    # 把用户按照name来排序，并算出排序
    ```
