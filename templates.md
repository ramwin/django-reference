# templates模板

[官方文档][templates]

## [build-in tags reference](https://docs.djangoproject.com/en/2.2/ref/templates/builtins/#built-in-tag-reference)
* [extends](https://docs.djangoproject.com/en/2.2/ref/templates/builtins/#extends)
    * `{% extend "base.html" %}`
    使用引号来直接引用一些页面
    * `{% extend variable %}`
    使用变量（可以是字符串或者template object）来引用

* [include](https://docs.djangoproject.com/en/2.0/ref/templates/builtins/#include)
```
{% include "foo/bar.html" %}
{% include template_name %}
{% include "name_snippet.html" with person="Jane" greeting="Hello" %}
{% include "name_snippet.html" with greeting="Hi" only %}
```
### [if](https://docs.djangoproject.com/en/2.0/ref/templates/builtins/#if)
```
{% if condition %}
    block1
{% elif condition %}
    block2
{% else %}
    block3
{% endif %}
```

### [ifequal](https://docs.djangoproject.com/en/2.0/ref/templates/builtins/#ifequal-and-ifnotequal) *deprecated*

### [for](https://docs.djangoproject.com/en/2.2/ref/templates/builtins/#for)
```
<ul>
{% for athlete in athlete_list %}
    <li>{{ athlete.name }}</li>
    {{forloop.counter}} 1-indexed
    {{forloop.counter0}} 0-indexed
{% empty %}
    运动员都累了哦
{% endfor %}
</ul>
```

## [Filters过滤][filters]
* `add`: 增加
    * {{ 4 | add: "2" }}  ==> 6  
    * {{ [1,2,3] | add: [4,5,6] }} ==> [1,2,3,4,5,6]  
* `addslashes`: 增加反斜杠
    * {{ "I'm using Django"| addslashes }} ==> "I\'m using Django"
* `capfirst`: 首字母大写
* `center`: 文字居中
    * "{{ "Django"|center: "15" }} ==> `"     Django      "`
* `cut`: 去除指定字符
* `date`: 格式化时间
    * {{ value|date:"D d M Y" }}
    * {{register_time|date:"o年m月d日"}}
* `default`: 默认的值  {{ event.source|default:"未知来源" }}
* `default_if_none`: None才是default
* `dictsort`: 按照dict的某个key排序
    {{ value|dictsort:"name" }}
* `dictsortreversed`: 逆序排列
* `divisibleby`: 能否被值整除
* `length`: 长度
* `filesizeformat`: 文件尺寸,自动从Byte变成 KB MB
* safe 不进行转译  
`{{ var|safe }}`
* [ ] safeseq
* slice
切断一个列表
```
{{ some_list|slice:":2" }}
```
* [ ] slugify
```
{{ value|slugify }}
Joel is a slug >>> joel-is-a-slug
```
* [ ] stringformat
* `with`:
```
{% with shor_name=longname.longsubname.longrealname %}
{% endwith %}
```

## url 写法
```
{% url 'some-url-name' [v1 v2 arg1=v1 arg2=v2] %}  # 这些参数必须直接放入
{% url 'some-url-name' [v1 v2 arg1=v1 arg2=v2] %}?id=3  # 额外的参数放后面
```

## 自定义标签
```
{% templatetag openvariable %} message {% templatetag closevariable %}  # 临时输出个花括号标签
{% verbatim %}
    {{if dying}}Still alive.{{/if}}  # 这样中间的代码就不会进行渲染了。
{% endverbatim %}
```

## Custom template tags and filters
[官网][custom]

### 自定义Filter
```shell
APP=school
mkdir -p ${APP}/templatestags/
touch ${APP}/templatetags/__init__.py
vim 

```

### Write custom template tags
```
app/
    models.py
    templatetags/
        poll_extra.py
from django import template
register = template.Library()
然后在页面里面
{% load poll_extra %}
```
#### Simple tags
```
import datetime
from django import template
@register.simple_tag
def current_time(format_string):
    return datetime.datetime.now().strftime(format_string)
```

## [Template API](http://ramwin.com:8888/ref/templates/api.html)
### Loading a Template
```
from django.template import Template
template = Template("My name is {{ my_name }}")
```

### Rendering a context
```
from django.template import Context
context = Context({"my_name": "ramwni"})
template.render(context)
```

[templates]: https://docs.djangoproject.com/en/5.0/ref/templates/builtins/
[filters]: https://docs.djangoproject.com/en/5.0/ref/templates/builtins/#built-in-filter-reference
[custom]: https://docs.djangoproject.com/en/5.0/howto/custom-template-tags/
