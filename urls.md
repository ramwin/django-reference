## 基础
    from django.conf.urls import url
    urlpatterns = [
        url(),
    ]
* 直接调用：
    `ulr(r'^polls/index/$','polls.views.index', name='index'),`
* 间接调用
    `url(r'^polls/', include('polls.urls', namespace="polls")),`
    * 内部调用
        `url( r'^polls/index/$' , 'blog.views.index'),`


## 例子
    from django.conf.urls import include, url        如果已经是app的url，一般都不需要include了
    ulr(r'^polls/index/$','polls.views.index'),    第一个参数是正则表达式,第二个参数
    # 但是每个方法的URL不一样，如何做到不大量修改就能重复利用一个app呢：
    url(r'^polls/', include('polls.urls')),
    # 如果碰巧两个api路径一样的（具体没遇到）用一个namespace来区分就好了：
    url(r'^polls/', include('polls.urls', namespace="polls")),

### 带有参数的url


    url(r'^polls/index/(?P<id>\d{2})/$','index'),
    def index(req,id):
        return render_to_response( 'index.html' , { 'id' : id})
    # 在index.html里面就可以使用id这个参数了
        <p>the convey of parameter</p>
        <p>id: {{id}}</p>
