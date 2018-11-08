# 性能问题
* 数据倾斜
* 小文件


# GROUP BY

```
hive> set hive.groupby.mapaggr.checkinterval=100000;
hive> set hive.optimize.groupby=true;
```

## 数据倾斜

### COUNT(DISTINCT)

```
hive> set hive.groupby.skewindata=true; #group by 存在数据倾斜
hive> SELECT COUNT(DISTINCT uid) FROM log;
hive> SELECT ip, COUNT(DISTINCT uid) FROM log GROUP BY ip;
hive> SELECT ip, COUNT(DISTINCT uid, uname) FROM log GROUP BY ip;
```

当启用时，能够解决数据倾斜的问题，但如果要在查询语句中对多个字段进行去重统计时会报错。

```
hive> set hive.groupby.skewindata=true;
hive> SELECT ip, COUNT(DISTINCT uid), COUNT(DISTINCT uname) FROM log GROUP BY ip
```

FAILED: SemanticException [Error 10022]: DISTINCT on different columns not supported with skew in data

---

# JOIN

## 1. map-side join

```
hive> set hive.auto.convert.join=true;
hive> set hive.mapjoin.smalltable.filesize=25000000; #//设置小表的数据文件的大小小于25M时，就使用map-side join
```

## 2. 大表 join 大表
