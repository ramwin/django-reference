# 权限设置
Apache用的用户是 www-data 用户组是 www-data
    为了能够不影响编辑的情况下对文件进行编辑，一般把文件和文件夹的用户组改成www-data，这样互相之间就不会影响了。
html 模板文件：
    需要能够读取
templates文件夹:
    需要能够进入改目录，所以是x
    不需要能够浏览目录，所以不需要r
project 文件夹:
    需要能够读取里面的文件，而不需要浏览文件夹内容，所以给 711
app 文件夹:
    全部能够执行 711 即可
    views.py 需要744
    其实，下面的文件都是到时候需要发送给客户的，所有都是需要读取即可
    templates:    
         读取html文件     744
     css:
        读取css文件    744
        css 文件夹        711即可
    js
        读取js文件    744

project 下的同名主文件夹:
    同样也只要 711 就可以了。
project 下的文件
    settings.py    __init__.py    urls.py    wsgi.py    manage.py    都是744即可
wsgi.py    744 需要能够读取
views.py    744 
urls.py    711 能够执行就可以
