**Xiang Wang @ 2018-11-27 14:10:45**


## [QuerySets](https://docs.djangoproject.com/en/2.1/topics/db/queries/)
### [My Reference(以前我的文档)](./queries.md)  
### [ ] Making Queries  
一些基础的知识，创建数据，删除数据等等
* 查看查询的SQL语句
    * 例子
    ```
    from django.db import connection
    print connection.queries
    ```
* Lookups that span relationships 通过**关联**的外键来查询 [官网文档](https://docs.djangoproject.com/en/2.0/topics/db/queries/#lookups-that-span-relationships)
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
    * 例子
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

### [QuerySet method reference](queryset_method_reference.md)  
1. django的各种查询语句: **filter**, *exclude*, *annotate*等  
2. django的各种过滤方法: **in**, *exact*, *contains*等
### [ ] ~~~Lookup expressions  ~~~  
比较高端，暂时没用过
### [ ] Advanced: Query Expressions
