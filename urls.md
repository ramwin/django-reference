直接调用：
    ulr(r'^polls/index/$','polls.views.index', name='index'),
间接调用
    url(r'^polls/', include('polls.urls', namespace="polls")),
    内部调用
        url( r'^polls/index/$' , 'blog.views.index'),


from django.conf.urls import include, url        如果已经是app的url，一般都不需要include了
ulr(r'^polls/index/$','polls.views.index'),    第一个参数是正则表达式,第二个参数
但是每个方法的URL不一样，如何做到不大量修改就能重复利用一个app呢：
url(r'^polls/', include('polls.urls')),
如果碰巧两个api路径一样的（具体没遇到）用一个namespace来区分就好了：
url(r'^polls/', include('polls.urls', namespace="polls")),

当我们在浏览器中url形式匹配url正则表达式,就把处理转移到处理方法views下面的index函数

url右边的值除了可以是路径,还可以是参数.
from polls.view import index
url( r'^polls/index/$' , index),
这样也可以.

ulr可以写成
urlpatterns = [
url(),
]
也可以写成
urlpatterns = patterns( '',
url(),
)
这样的话就可以多输入一个字符串参数,这个参数代表这下面url值的默认前缀.
如果参数是'polls.views',后面只要写
url(r^polls/index/$','index')就可以了.

除了可以设置正则表达式, url 还可以进行参数的传递.
url(r'^polls/index/(?P<id>\d{2})/$','index'),
这个就是浏览器在浏览网页的时候传递了一个名为id的两位数的参数.
对应的,我们需要index能够对这个参数进行处理
def index(req,id):
    return render_to_response( 'index.html' , { 'id' : id})
在index.html里面就可以使用id这个参数了
    <p>the convey of parameter</p>
    <p>id: {{id}}</p>

