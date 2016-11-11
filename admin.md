# 用户认证
    from django.contrib.auth import authenticate
    authenticate(username='ramwin', password='wangx')
# admin界面设置

## 最简单的
    admin.site.register(models)

## 设置样式
    class SampleAdmin(admin.ModelAdmin):
        fieldsets = [
            (None, {'fields': ['text']})
        ]
        list_display = ('text','project')
        list_filter = ['time','leve']
        search_fields = ['text','project']
    admin.site.register(<models>, SampleAdmin)
