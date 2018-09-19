## Relationship fields

### 多对一
* 请使用ForeignKey [参考](https://docs.djangoproject.com/en/1.10/topics/db/examples/many_to_one/)

### 多对多 [参考文档](https://docs.djangoproject.com/en/1.10/ref/models/fields/#manytomanyfield)
[api](https://docs.djangoproject.com/en/1.11/topics/db/examples/many_to_many/)

* 基础
    ```
    label = models.ManyToManyField(Label, verbose_name=u'标签', null=True)
    todos = models.ManyToManyField(TodoList, through="WeeklyPaperTodoRef")
    ```

* add:
    ```
    model.todos.add('1','2')  # 可以是数字，可以是字符串，可以是对象。只要是一个一个传入的即可，add以后就立刻添加进入了数据库
    1. return None
    2. 如果已经在里面了，不会二次添加
    3. 如果不再这个里面，就会直接加进去
    return None
    ```

* remove:
    ```
    model.label.remove(label1, label2)  # 可以重复，可以多个
    ```

* set:
    ```
    model.label.set([label1, label2])
    ```

* clear:
    ```
    model.label.clear()
    ```

#### 参数
```
    through = "ModelRefName"  # 可以把中间关联的表拿出来写成model加参数
    db_table = "关联的表名"  # 关联的数据库的表名称
```

### 其他
* 如果调用了本身，可以使用 `models.ForeignKey('self', on_delete=models.CASCADE)`
* 如果单独的manytomany, 可以使用through获取那个隐藏的model
```
    school.students.through.objects.filter(school=school)
```


## 特殊
### Meta的作用
```
    class Meta:
        unique_together = ("user","date")   # 同一个用户同一个时间只允许一次(比如投票)
    如果不符合，会报错  django.db.utils.IntegrityError
        ordering = "-id"  # 指定默认排序方式
        db_table = "table"  # 指定表的名称
        abstract = True # 表不进行创建，只用来继承
        verbose_name = '显示名字'
        verbose_name_plural = '显示名字'
```
### property的作用
* views里面可以直接调用,不用加括号
**但是不能在aggregrate或者filter里面使用**

### str的作用
* 可以让shell里面查看model更加好看一点，但是要注意，尽量不要把id放在里面，
* 不然在model没有save的时候，会报错。就算放，也用 instance.pk or 0的形式


## 其他属性设置

### Meta
```
    db_table: "设置使用的表的名称"
    verbose_name: "在admin界面显示的内容"
    verbose_name_plural: "用于复数的时候显示的内容"
```

## Signal
**注意,model的signal不是异步的，而是同步的。如果有异步的需求，请使用celery**
