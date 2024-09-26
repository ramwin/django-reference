# 一种利用pending状态实现锁的方案

## 问题背景
开发网站时经常遇到数据竞争的情况.  
比如一个图书馆网站，对于Book1

* 学生还书,把Book1的status变成可借阅
```
book = Book1.objects.get(id=1)  # 初始 use, naem, 错别字
book.status = "free"
book.save()  # free naem
```

* 管理员修改名称
```
book = Book1.objects.get(id=1)  # 初始 use, naem, 错别字
book.name = "name"
book.save()  # use, name
```

无论是学生的对象先保存还是管理员的对象先保存, 都会导致book的status或者name有一个有问题.

## 已有解决方案的缺陷
* 添加锁  
一旦加锁意味着所有拿Book, 改Book的地方都要加锁. 对于已有项目改动工作量太大了.
比如
    1. 每天对书本进行统计要加锁
    2. 每次借阅书籍后保存书籍的借阅次数需要加锁
    3. 修改书本的标签号需要加锁
    4. 给书本添加标签要加锁(利用arrayfield直接保存在书本的标签)

* 只允许改里面部分字段  
和加锁一样,改动也很大.每个保存book的代码都要把status排除. 并且django-rest-framework的serializer还不支持update_fields

## 利用pending状态实现锁
### 原理
* 线程A和线程B占用对象Book1时, 创建一个占用记录
```
occupy_A/B = BookOccupy.objects.create(status="pending", book=Book1)
```

* 占用完毕后查看处于pending的记录是否存在
```
pending = BookOccupy.objects.filter(status="pending", book=Book1).exclude(id=occupy_A).first()
# 顺序很重要,先看pending后看using. 避免看完using后正好有个pending的状态变成using
using = BookOccupy.objects.filter(status="using", book=Book1).exclude(id=occupy_A).first()
```

* 如果已经被其他人占用了就退出
```
if using:
    return
```
* 如果有其他pending,就取消占用随机等待后重拾
```
if pending:
    occupy_A/B.delete()
    time.sleep(random.random())
    occupy_A/B = BookOccupy(status="pending", book=Book1)
```

* 证明  
可以看到对于每次占用都有空-pending-using的状态. 任意状态下, 

|A状态|B状态|A操作|B操作|
|-----|-----|-----|-----|
|None |Any  |进入pending |Continue|
|Pending|None|进入using|进入Pending|
|Pending|Pending|进入None随机等待|进入None随机等待|
|Pending|Using|Exit|Using|
|Using|Any|Using|Exit|

## 具体实现
* 数据库实现  
上面的原理里就是利用数据库的ORM实现.

* redis缓存实现  
利用using:key保存已经占用的.
利用pending:set保存等待的
```
while True:
    occupy_A/B = redis.sadd("set", "id_A/B")
    if redis.scard("set") >= 2:
        redis.srem("set", "id_A/B")
        time.sleep(random.random())
        continue
    if redis.get("using:key"):
        return None
    # 没有using, 没有pending 
    redis.set("using:key", "id_A")
    redis.srem("set", "id_A")
```

* 文件系统实现  
创建2个文件夹, pending和using. 每次都查看using文件夹里是否有文件, pending文件夹的数量是否大于1
