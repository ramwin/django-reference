**Xiang Wang @ 2020-06-22 13:37:43**


## Advanced

### Query Expressions
[官网](https://docs.djangoproject.com/en/3.0/ref/models/expressions/)
一些可以计算出结果，并用来过滤修改的方法。
#### `F() expressions`
> F() 代表了一个从model获取的数据，但是不会取出到python内存里。
* 例子
```
reporter = Reporters.objects.get(name="Tintin")
reporter.stories_filed += 1  # 取出数据，放入python，加1
reporter.save()  # 保存到sql
```
```
from django.db.models import F
reporter.stories_filed = F('stories_filed') + 1
reporter.save()
reporter.stories_filed  # <CombinedExpression: F(stories_filed) + Value(1)>
如果需要获取数据，要使用
reporter.refresh_from_db()
```
```
reporter = Reporters.objects.filter(name="Tintin")
reporter.update(stories_filed=F("stories_filed") + 1)
```
* 通过F可以避免多线程操作同一个数据字段的问题
* 注意，每次save时，F都会计算一遍，都会加1.如果不想这么做，请save后`refresh_from_db`
* 这个字段可以用在queries, 参见 [Filters can reference fields on the model](#获取数据-Retrieving-objects)
* [ ] 用在annotations
* [ ] 用在null来排序

### [Database Functions][database functions]
#### Math Functions
* Abs: 求绝对值
```
流水总量
Transaction.objects.aggregate(Sum(Abs('amount')))
```


[database functions]: https://docs.djangoproject.com/en/3.0/ref/models/database-functions/