### 创建users:
    from django.contrib.auth.models import User
    user = User.objects.create_user('john', 'ramwin@163.com', 'password')
### 修改密码:
    u = User.objects.get( username = 'john')
    u.set_password( 'new password' )
    u.save()
### 认证 Users
    from django.contrib.auth import authenticate
    user = authenticate( username = 'john', password = 'secret')
    if user    # 有这个账户
    if user.is_active:    # 账户是激活的
    else:     # 认证失败
### 创建超级用户
    python manage.py createsuperuser --username=<username> --email=<email>
