*admin界面设置*

# 最简单的
```
admin.site.register(models)
@admin.register(models.Model)
class MyModelAdmin(admin.ModelAdmin):
    ...
```

# [全局参数](https://docs.djangoproject.com/en/2.0/ref/contrib/admin/#adminsite-attributes)
```
admin.site.site_header = 'Django administration'
```
* `site_header`: 修改全局的标题，默认 `Django administration`
* `site_title`: 页面的title

# [ModelAdmin](https://docs.djangoproject.com/en/2.0/ref/contrib/admin/#modeladmin-objects):
* `list_display`: 在列表页面需要显示的字段数据
* `list_filter`: 在列表页面，可以进行分类查看的数据
* `search_fields`: 在列表页面的搜索框搜索的字段
* `readonly_fields`: 在详情页面，哪些字段只能读，不能写。一般用于auto_now_add 和 auto_now 的时间，以及id
## 参数
    * [get_readonly_fields](https://docs.djangoproject.com/en/2.0/ref/contrib/admin/#django.contrib.admin.ModelAdmin.get_readonly_fields):  
        看到[stackoverflow](https://stackoverflow.com/questions/7860612/django-admin-make-field-editable-in-add-but-not-edit)上的问题，如何自定义一个字段，创建的时候有，编辑的时候没有
        ```
        def get_readonly_fields(self, request, obj=None):
            if obj is None:
                return []
            else: return self.readonly_fields

        ```

# [自定义]
* [自定义一个字段](#设置样式)
* [自定义缩略图](https://docs.djangoproject.com/en/2.0/ref/contrib/admin/#django.contrib.admin.ModelAdmin.list_display)
```python
    from django.utils.html import format_html

    class PersonAdmin(admin.ModelAdmin):
        list_display = ('name', 'thumbnail')

        def thumbnail(self, obj):
            return format_html('<img src="%s">' % obj.avatar)
```

# [设置](https://docs.djangoproject.com/en/2.0/ref/contrib/admin/#django.contrib.admin.ModelAdmin.has_add_permission)
* `has_add_permission(request)`: 能否添加
* `has_delete_permission(request, obj=None)`: 能否删除

# 设置样式
```python
    class SampleAdmin(admin.ModelAdmin):
        fieldsets = [
            (None, {'fields': ['text']})
        ]
        list_display = ('text','project')
        list_filter = ['time','leve']
        search_fields = ['text','project', 'get_users']
        def get_users(self, obj):  # 自定义一个字段
            return obj.users.all()
        get_users.short_description = '用户'
    admin.site.register(<models>, SampleAdmin)
```
