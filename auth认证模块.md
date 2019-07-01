[官网](https://docs.djangoproject.com/en/2.1/#common-web-application-tools)

### Using the authentication system 使用认证系统 [官网](https://docs.djangoproject.com/en/2.1/topics/auth/default/#authentication-in-web-requests)

#### Authentication in Web requests 网页里面的认证
##### How to log a user in 如何让一个用户登录
* `django.contrib.auth.login(request, user, backend=None)`
```
from django.contrih.auth import login, authenticate
def my_view(request):
    user = authenticate(request, username=username, password=password)
    if user is not None:
        login(request, user)
```

##### Limiting access to logged-in users
* the raw way
```
def my_view(request):
    if not request.user.is_authenticated:
        return redirect("%s?next=%s" % (settings.LOGIN_URL, request.path))
        return render(request, 'myapp/login_error.html')
```

* The `login_required` decorator
* The LoginRequired mixin
注意这个只校验是否认证，不校验`is_active`
```
from django.contrib.auth.mixinx import LoginRequiredMixin
class MyView(LoginRequiredMixin, View):
    login_url = '/login/'
    redirect_field_name = 'redirect_to'
```
* Limiting access to logged-in users that pass a test
* The `permission_required` decorator
* The PermissionRequiredMixin mixin


* to be continued
    * [ ] How to log a user out 如何退出一个用户
    * [ ] Redirecting unauthorized requests in class-based views
    * [ ] other


### API参考
[官网](https://docs.djangoproject.com/en/2.1/ref/contrib/auth/)
> django.contrib.auth

#### User model
* Fields
    * username
    默认支持的是`alphanumeric,_,@,+,.,-`, 必填, 默认为空字符串，所以**如果是自定义的auth或者接口，务必把username设置好**

### [自定义认证系统][自定义认证系统]

#### 自定义User取代
使用一个app里面的User来替换django的User
##### 引用User
使用`settings.AUTH_USER_MODEL`会直接返回字符串
```
from djang.conf import settings
from django.db import models
class Article(models.Model):
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        ob_delete=moedls.CASCADE,
    )
```
如果在运行时，可以使用
```
from django.contrib.auth import get_usre_model
User = get_user_model()  这样可以获取User的model
```

##### 其他
* [ ] reusbale apps and `AUTH_USER_MODEL`
* [ ] Specifying a custom user model

#### 其他
* [ ] 其他认证来源
* [ ] 自定义权限
* [ ] Extending the exsisting User model
可以创建一个proxy model给User或者创建一个OneToOneField

### 创建users:
```
    from django.contrib.auth.models import User
    user = User.objects.create_user('john', 'ramwin@163.com', 'password')
```

### 根据明文创建密码
`from django.contrib.auth.hashers import make_password`

### 修改密码:
```
    u = User.objects.get( username = 'john')
    u.set_password( 'new password' )
    u.save()
```

### 认证 Users
```
    from django.contrib.auth import authenticate
    user = authenticate( username = 'john', password = 'secret')
    authenticate(username='ramwin', password='wangx')
    if user    # 有这个账户
    if user.is_active:    # 账户是激活的
    else:     # 认证失败
```

### 创建超级用户
```
    python manage.py createsuperuser --username=<username> --email=<email>
```

### 使用再classbaseview
    ```
    from django.contrib.auth.mixins import LoginRequiredMixin
    class View(LoginRequiredMixin, GenericView):
        login_url = 'home/login'
        redirect_field_name = 'redirect_to'
    ```


### to be continued
* [ ] api
* [ ] 密码管理


[自定义认证系统]: https://docs.djangoproject.com/en/2.1/topics/auth/customizing/
