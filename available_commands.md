# 可用命令
## dumpdata
导出数据
```
python3 manage.py dumpdata <app>.<model>
```

* 参数
```
-o table.json[.gz]  # 输出文件路径
--indent 4  # 缩进
--pk 1,2,3  # 导出哪些数据
```

## loaddata
dump出来的数据到fixture, 可以直接用在testcase里
