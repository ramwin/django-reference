**django template language**

# built-in tags and filters
## [build-in tags reference](https://docs.djangoproject.com/en/2.0/ref/templates/builtins/#built-in-tag-reference)
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

## Filters过滤
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
* `default`: 默认的值  {{ event.source|default:"未知来源" }}
* `default_if_none`: None才是default
* `dictsort`: 按照dict的某个key排序
    {{ value|dictsort:"name" }}
* `dictsortreversed`: 逆序排列
* `divisibleby`: 能否被值整除
* `length`: 长度
* `filesizeformat`: 文件尺寸,自动从Byte变成 KB MB
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
    {% templatetag openvariable %} message {% templatetag closevariable %}  # 临时输出个花括号标签
    {% verbatim %}
        {{if dying}}Still alive.{{/if}}  # 这样中间的代码就不会进行渲染了。
    {% endverbatim %}


## for
    {% for i in list %}
    {% empty %}
    {% endfor %}


## 时间
* [官方文档](https://docs.djangoproject.com/en/1.11/ref/templates/builtins/#date)
* {{register_time|date:"o年m月d日"}}
