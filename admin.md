### admin界面设置

### 最简单的
    admin.site.register(models)
    * 参数:
        * `list_display`: 在列表页面需要显示的字段数据
        * `list_filter`: 在列表页面，可以进行分类查看的数据
        * `search_fields`: 在列表页面的搜索框搜索的字段
        * `readonly_fields`: 在详情页面，哪些字段只能读，不能写。一般用于auto_now_add 和 auto_now 的时间，以及id

### 设置样式
    class SampleAdmin(admin.ModelAdmin):
        fieldsets = [
            (None, {'fields': ['text']})
        ]
        list_display = ('text','project')
        list_filter = ['time','leve']
        search_fields = ['text','project']
    admin.site.register(<models>, SampleAdmin)
