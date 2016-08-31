#### Xiang Wang @ 2016-08-30 15:41:24

## 基础
    from django.core.pagiator import Paginator
    objects = Model.objects.all()
    p = Paginator(objects, 2)   # 每页显示2个元素
    p.count # 获取一共多少个元素
    p.num_pages # 获取页数
    objectslist = p.page(n)   # 获取第n页
    objectslist.has_previous | has_next # 判断是否有下一页
    objectslist.previous_page_number | next_page_number # 获取上一页或下一页的页码
    objectslist.number  # 当前页码
