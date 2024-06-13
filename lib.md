# [django-bootstrap4](https://github.com/zostera/django-bootstrap4)
```
pip install django-bootstrap4
{% load bootstrap4 %}
{% bootstrap_css %}
{% bootstrap_javascript jquery='full' %}
```

# [django-dirtyfields](https://github.com/romgar/django-dirtyfields/)  
利用`__init__`的时候备份数据，实现知道一个model哪些数据变化了

# django-health-check
[系统健康度检测](https://github.com/revsys/django-health-check)

# [django-guardian](https://django-guardian.readthedocs.io/en/stable/)
设置一个model对象的权限

# [django-performance-monitor](https://github.com/afsal-parseltongue/django-performance-monitor)
超级简单的利用middleware来查看请求耗时

    sudo pip3 install django-performance-monitor
    INSTALLED_APPS.append("django_performance_monitor")
    MIDDLEWARE.append("django_performance_monitor.middleware.LogRequestMiddleware")

## User Guide
* 校验权限
user.has_perm("vip", obj)

## Shortcuts
* assign_perm(perm, user_or_group, obj)
* remove_perm(perm, user_or_group, obj)
```
from guardian.shortcuts import assign_perm, remove_perm
assign_perm("basic", user, obj)
remove_perm("basic", user, obj)
get_objects_for_user(user, "basic", ModelClass)
>>> return Queryset
```
* get_users_with_perms
获取有某个对象权限的用户
```
get_users_with_perms(obj)
```

# [django-simple-history](https://django-simple-history.readthedocs.io/en/latest/quick_start.html)  
利用`post_save`来记录每一次的model变更
```
INSTALLED_APPS = [
    # ...
    'simple_history',
]
MIDDLEWARE = [
    # ...
    'simple_history.middleware.HistoryRequestMiddleware',
]
from simple_history.models import HistoricalRecords
class Model(models.Model):
    history = HistoricalRecords(exclude_fields=["update_datetime"])  # maybe you don't need the update_datetime since the history model contains history_date
model = Model.objects.first()
model.history.latest()
model.as_of(datetime(2021, 1, 1, 0, 0, 0))
```

# [django-dirtyfields](https://github.com/romgar/django-dirtyfields/)  
利用`__init__`的时候备份数据，实现知道一个model哪些数据变化了

# [django-bootstrap4](https://github.com/zostera/django-bootstrap4)
```
pip install django-bootstrap4
{% load bootstrap4 %}
{% bootstrap_css %}
{% bootstrap_javascript jquery='full' %}
```
