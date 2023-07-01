**Xiang Wang @ 2018-11-27 14:10:45**

[官网][queryset]

### [My Reference(以前我的文档)](./queries.md)  
### [ ] Making Queries  
#### 创建数据 Creating objects
#### 修改数据 Saving changes to objects
#### 获取数据 Retrieving objects
* [ ] Lookups that span relationships
* Filters can reference fields on the model
```
from django.db.models import F
Entry.objects.filter(number_of_comments__gt=F('number_of_pingbacks'))
Entry.objects.filter(number_of_comments__gt=F('number_of_pingbacks') * 2)
Entry.objects.filter(rating__lt=F('number_of_comments') + F('number_of_pingbacks'))
Entry.objects.filter(authors__name=F('blog__name'))
from datetime import timedelta
Entry.objects.filter(mod_date__gt=F('pub_date') + timedelta(days=3))  找到发布3天后，仍然被修改的书籍
```
* [ ] The pk lookup shortcut

#### [删除数据](https://docs.djangoproject.com/en/3.1/topics/db/queries/#deleting-objects)
* [查询关联的删除](https://stackoverflow.com/questions/26807858/how-can-i-check-what-objects-will-be-cascade-deleted-in-django/66540097#66540097)
```
from django.contrib.admin.utils import NestedObjects
nested_object = NestedObjects("default")
nested_object.collect([Item])
print(nested_object.nested())
```

#### 待整理
一些基础的知识，创建数据，删除数据等等
* 查看查询的SQL语句
    * 例子
    ```
    from django.db import connection
    print connection.queries
    ```
* Lookups that span relationships 通过**关联**的外键来查询 [官网文档](https://docs.djangoproject.com/en/3.0/topics/db/queries/#lookups-that-span-relationships)
    * 例子django会把没有的字段当作None来处理。所以:
    ```
    Search.objects.filter(user__username='wx')  # left join式的过滤。如果没有user，也会被过滤掉
    Search.objects.exclude(user__username='wx')  # 如果没有user，也不会过滤掉

    TestQuery.objects.exclude(user__id=4001)  # 会搜索出user为None的
    TestQuery.objects.filter(user__id=None)  # 会搜索出user为None的
    # user都没有，更没有id，id更不可能属于这个列表
    TestQuery.objects.filter(user__id__in=[4001])  # 不会搜索出user为None的
    # exclude并不没有user__id必须存在这个前提条件
    TestQuery.objects.exclude(user__id__in=[4001])  # 会搜索出user为None的

    Blog.objects.filter(entry__authors__name='Lennon')  # 如果author不存在的Blog不会返回
    Blog.objects.filter(entry__authors__name__isnull=True)  # 这时候author不存在的也会返回
    Blog.objects.filter(entry__authors__isnull=False, entry__authors__name__isnull=True)  # 这样就能指定必须含有authors，并且authors为空
    ```
* 多字段查询关联的歧义
```
User.objects.filter(shop__title__contains='shop', shop__gmt_create__year=2008)  # 于2008年注册过商店名包含'shop'的所有用户
User.objects.filter(shop__title__contains='shop').filter(shop__gmt_create__year=2008)  # 商店名有shop，并且于2008年注册过商店的用户
User.objects.exclude(shop__title__contains='shop', shop__id=3)  # 过滤到有店id是3并且名字有shop的用户
User.objects.exclude(shop__title__contains='shop', shop__name__contains='ew')  # 过滤所有title包含shop和name包含ew的
User.objects.exclude(shop = Shop.objects.filter(location__contains='tian', name__contains='test'))  # 用户
ClassRoom.objects.filter(student__name__contains='王')  # 找到包含名字有王学生的的班级
# 但是如果有两个人都包含"王"，那这个班级就会出现两次，所以用distinct()
Blog.objects.filter(entry__authors__name__isnull=True)
```
* [ ] 如果是exclude的话会怎么样(暂时没遇到这个需求，以后再说)

### QuerySet method reference
1. django的各种查询语句: **filter**, *exclude*, *annotate*等  
2. django的各种过滤方法: **in**, *exact*, *contains*等

#### [When Querysets Are Evaluated](https://docs.djangoproject.com/en/2.0/ref/models/querysets/#when-querysets-are-evaluated)

#### [QuerySet API][queryset_api]

##### Methods that return new Querysets 返回Queryset的方法
* [ ] annotate
* order_by
直接按照字段排序
```
Entry.objects.order_by("-pub_date", "headline")  # 直接按照字段排序
Entry.objects.order_by("?")  # 随机排序
Entry.objects.order_by("blog__name", "headline")  # 按照外键排序
ManyModel.objects.annotate(text_id=Min("texts__id")).order_by("text_id")  # 按照ManyToMany的表的某个字段排序
```
* [ ] reverse
* distinct
* values
```
TestFilterModel2.objects.values('_bool', '_int').annotate(Count('id'))  # 利用_bool, _int进行分组，查看数量
MingpianChange.objects.order_by("amount").values("amount").annotate(Count("id"))  # 查看各个amount对应的数量
```
###### values_list
[官网][values_list]  
`values_list(*fields, flat=False, named=False)`  
原理是通过select只看部分字段, 所以遇到外键是会有None, 遇到ManyToMany时数据会重复  
named可以返回`django.db.models.utils.Row`, 直接获取属性  

```python
Entry.objects.values("id", flat=True)
<Queryset [1, 2]>  可以继续过滤, 也可以直接迭代得到1, 2
```

* defer
`Entry.objects.defer("body")`: only access the body field when you use the `body` field to optimize the performance

##### Methods that do not return Querysets 不返回Queryset的方法
`get, create, get_or_create`
* `update_or_create(defaults=None, **kwargs)`
通过kwargs来查找数据. 如果没有就创建
* [bulk_create](http://ramwin.com:8888/ref/models/querysets.html#bulk-create): 一次性创建多个instance
    * 如果某个创建失败了,会导致之后的也创建失败, 类似事务
    * 如果把foreignkey的对象传进去,不会校验,而是直接读取pk属性
```
Shop.objects.bulk_create([
    Shop(user=user, name='test'),
    Shop(user=user, name='test2')])
])
```

##### [Field lookups 查询field的方法](https://docs.djangoproject.com/en/3.0/ref/models/querysets/#field-lookups)
* exact
* iexact
* contains
* icontains
* startswith
* ###### [date](https://docs.djangoproject.com/en/2.2/ref/models/querysets/#date)  
> When `USE_TZ` is True, fields are converted to the current time zone before filtering.  
`Entry.objects.filter(pub_date__date=datetime.date(2005, 1, 1))`  
But the date is filtered by the date of server timezone. What if you want to filter the date create by customer living in other timezone district? I find the only way is to use time range.  

    * 这个date过滤还直接输入一个时间来过滤。这个时候会先把datetime转化成local的时间，然后再取date过滤
    ```
    Entry.objects.filter(pub_date__date=datetime)
    ```

##### [Query Expressions 查询语句][expressions]
* Example  
	```python
	from django.db.models import Count, F, Value
	from django.db.models.functions import Length, Upper

	# Find companies that have more employees than chairs. 找到职工比凳子多的公司
	# F 把表的某个值当作判断
	Company.objects.filter(num_employees__gt=F('num_chairs'))

	# Find companies that have at least twice as many employees
	# as chairs. Both the querysets below are equivalent.
	# 找到员工数比椅子两倍还多的公司
	Company.objects.filter(num_employees__gt=F('num_chairs') * 2)
	Company.objects.filter(
		num_employees__gt=F('num_chairs') + F('num_chairs'))

	# How many chairs are needed for each company to seat all employees?
	# 添加每个公司还需要多少椅子的信息
	>>> company = Company.objects.filter(
	...    num_employees__gt=F('num_chairs')).annotate(
	...    chairs_needed=F('num_employees') - F('num_chairs')).first()
	>>> company.num_employees
	120
	>>> company.num_chairs
	50
	>>> company.chairs_needed
	70

	# Create a new company using expressions.
	>>> company = Company.objects.create(name='Google', ticker=Upper(Value('goog')))
	# Be sure to refresh it if you need to access the field.
	>>> company.refresh_from_db()
	>>> company.ticker
	'GOOG'

	# Annotate models with an aggregated value. Both forms
	# below are equivalent.
	Company.objects.annotate(num_products=Count('products'))
	Company.objects.annotate(num_products=Count(F('products')))

	# Aggregates can contain complex computations also
	Company.objects.annotate(num_offerings=Count(F('products') + F('services')))

	# Expressions can also be used in order_by()
	Company.objects.order_by(Length('name').asc())
	Company.objects.order_by(Length('name').desc())
	```
* [ ] Build-in Expressions

#### Query-related tools
##### [Q() objects][q-objects]
用这个以后可以使用 |(or), &(and), ^(XOR), ~(NOT)操作
```
from django.db.models import Q
q1 = Q(name0="name0") | Q(name1="name1") & Q(name2="name2")
q2 = Q(name0="name0") | Q(name1="name1")
q2 &= Q(name2="name2")
注意，因为一句一句执行，所以q2的顺序和q1不一样. q1因为执行顺序的原因，先执行&
```

### [ ] ~~~Lookup expressions  ~~~  
比较高端，暂时没用过


[queryset_api]: https://docs.djangoproject.com/en/4.2/ref/models/querysets/#queryset-api

[expressions]: https://docs.djangoproject.com/en/4.1/ref/models/expressions/
[q-objects]: https://docs.djangoproject.com/en/4.1/topics/db/queries/#complex-lookups-with-q
[queryset]: https://docs.djangoproject.com/en/4.2/topics/db/queries/
[values_list]: https://docs.djangoproject.com/en/4.2/ref/models/querysets/#values-list
