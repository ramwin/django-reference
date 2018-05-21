** Xiang Wang @ 2016-09-30 16:14:18 **

# 查找
* 示例
    ```
    obj, created = <model>.objects.get_or_create(user__name='wangx')
    # 不存在用户就不登录而是注册
    # created 为 True， 代表了obj是新建
    # 如果返回多条数据，会报错的
    # 创建的时候的时候会自动保存, 但是要注意, 如果有写field不允许null, 就需要get的时候把参数传进去
    # get_or_create里面如果传递的是过滤参数，就会先用过滤参数过来
    obj, created = <model>.objects.get_or_create(text='text', time__gt='2017-12-12T10:24:00+08:00')
    ```
* 添加额外字段
    * [官网参考](https://docs.djangoproject.com/en/1.11/ref/models/database-functions/#module-django.db.models.functions.datetime)
    * 代码
    ```
    from django.db.models.functions import ExtractWeekDay
    TestDate.objects.all().annotate(weekday=ExtractWeekDay('date'))
    ```

* 仅仅查询需要的字段
    ```
    >>> User.objects.all().values('username')
    >>> 返回 [{'username': 'ramwin'}], 是一个queryset, 可以用来exclude，而如果是自己写的[{'uesrname': 'ramwin'}] 就不可以用来过滤
    ```
    
# 过滤
* 基础
    ```
    Search.objects.all()
    Search.objects.filter(text='text')  # 单个条件过滤
    Search.objects.filter(user=wx)  # 外健用对象或者对象id过滤,user_id, user__id也可以
    ```

* 联表查询，left join
    ```
    Search.objects.filter(user__username='wx')  # left join式的过滤。如果没有user，也会被过滤掉
    Search.objects.exclude(user__username='wx')  # 如果没有user，也不会过滤掉
    from djabgo.db.models import Count
    User.objects.filter(username='wangx').annotate(shop_cnt=Count('shop')  # count
    ```

* 多字段查询关联的歧义
    ```
    User.objects.filter(shop__title__contains='shop', shop__gmt_create__year=2008)  # 于2008年注册过商店名包含'shop'的所有用户
    User.objects.filter(shop__title__contains='shop').filter(shop__gmt_create__year=2008)  # 商店名有shop，并且于2008年注册过商店的用户
    User.objects.exclude(shop__title__contains='shop', shop__id=3)  # 过滤到有店id是3并且名字有shop的用户
    User.objects.exclude(shop__title__contains='shop', shop__name__contains='ew')  # 过滤所有title包含shop和name包含ew的
    User.objects.exclude(shop = Shop.objects.filter(location__contains='tian', name__contains='test'))  # 用户
    ts.messages.all().values('type').annotate(cnt=Count('type'))
    ```

* 通过不关联的表字段进行过滤
    ```
    visited_ids = Travel.objects.filter(user=uesr).values('interest')
    Interest.objects.exclude(id__in=visited_ids)
    ```

* 通过外健过滤
    ```
    TestQuery.objects.exclude(user__id=4001)  # 会搜索出user为None的
    TestQuery.objects.filter(user__id=None)  # 会搜索出user为None的
    # user都没有，更没有id，id更不可能属于这个列表
    TestQuery.objects.filter(user__id__in=[4001])  # 不会搜索出user为None的
    # exclude并不没有user__id必须存在这个前提条件
    TestQuery.objects.exclude(user__id__in=[4001])  # 会搜索出user为None的
    ```

* many的字段过滤
    ```
    ClassRoom.objects.filter(student__name__contains='王')  # 找到包含名字有王学生的的班级
    # 但是如果有两个人都包含"王"，那这个班级就会出现两次，所以用distinct()
    Blog.objects.filter(entry__authors__name__isnull=True)
    # 这个会导致没有authors的也会被筛选出来
    Blog.objects.filter(entry__authors__isnull=False,
        entry__authors__name__isnull=True)  # 这个会是筛选出有作者并且作者名字是null的
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

# 创建
    Model.objects.bulk_create([Model1, Model2]) # 如果后面的创建失败，整个就不会创建。类似事务，但是无法调用每个instance的save函数
    Model.objects.create(name='王')  # 创建一个对象，会调用Model的save函数
    Model.objects.get_or_create(text='w')  # 如果是创建的话会调用save函数
    创建后会把创建对象的列表返回

# 修改
    ```
    objs = model.objects.filter(status=1).update(status=1)
    ```

## 原子操作
    ```
    from django.db.models import F
    obj = Model.objects.get(name='test')
    obj.friends = F('friends') + 1
    obj.save()  # 注意哦，每次save都会触发底层的mysql更新，所以save只能执行一次
    ```

# 求和
    ```
    from django.db.modes import Sum
    >>> Number.objects.filter(id__lte=3).aggregate(s = Sum('integer'))
    >>> {'s': 10}  # 如果没有搜索到，返回的会是None，而不是0哦
    ```


# 操作符号

## [官方教程](https://docs.djangoproject.com/en/1.10/ref/models/querysets/#field-lookups)

## 基础
* 过滤: Model.objects.filter()  Model.objects.all()  # 如果是外键，可以使用 user=obj, user=id, user_id=id 这三种方式。 id可以字符串，也可以是数字
* 排除: Model.objects.exclude()  

## 操作符列表
* =: 值等于 或者 field__exact="value"
* iexact: 忽略大小写  name_iexact="wang"
* contains: 包含区分大小写。但是注意，sqlite默认不区分的，所以仍旧不区分
* icontains: 不区分大小写的包含
* startswith, endswith, istartswith, iendswith

# 创建数据
* 基础
    ```
    instance = Text(text='text')
    instance.save()
    ```

* 其他
    ```
    Shop.objects.bulk_create([  # 这个create需要把foriegnkey的对象传递进去，但是不会去校验, 只要这个对象有pk这个属性就可以了
        Shop(user=user, name='test'),
        Shop(user=user, name='test2')])
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
* [官方文档](https://docs.djangoproject.com/en/1.11/topics/db/aggregation/)
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
* groupby
    ```python
    Travel.objects.values('interest2').annotate(Count('user', distinct=True))
    # 对所有的旅行记录排序，看看那个经典(去的人次/去过的人, 有distinct就是一个人只能算去一次)最多
    Book.objects.values('name').annotate(Count('id')).order_by()
    # group the book by its name, order_by is required or the the group will not have effect.
    GetOrCreateModel.objects.annotate(date=TruncDate('time')).values('date').annotate(Count('id'))
    ```
