# 功能

# Filters过滤
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
* `default`: 默认的值
* `default_if_none`: None才是default
* `dictsort`: 按照dict的某个key排序
    {{ value|dictsort:"name" }}
* `dictsortreversed`: 逆序排列
* `divisibleby`: 能否被值整除
* `length`: 长度
* `filesizeformat`: 文件尺寸,自动从Byte变成 KB MB
