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
