* [官网](https://docs.djangoproject.com/en/2.1/#common-web-application-tools)

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

* to be continued
    * [ ] How to log a user out 如何退出一个用户
    * [ ] Limiting access to logged-in users
    * [ ] Redirecting unauthorized requests in class-based views
    * [ ] other

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
