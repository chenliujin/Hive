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

| Type | Approach | Pros | Conditions |
| --- | --- | --- | --- |
| Shuffle Join | Join keys are shuffled using map/reduce and joins performed join side. | Works regardless of data size or layout. | Most resource intensive and slowest join type. |
| map-side Joint (Broadcast Join) | Small tables are loaded into memory in all nodes,mapper scans through the large table and joins. | Very fast, single scan through largest tables. | All but one table must be small enough to fit in RAM. |
| Sort-Merge-Bucket Joint | Mappers take advantage of co-location of keys to do efficient joins. | Very fast for tables of any size. | Data must be sorted and bucketed ahead of time. |

## 1. map-side join

```
hive> set hive.auto.convert.join=true;
hive> set hive.mapjoin.smalltable.filesize=25000000; #//设置小表的数据文件的大小小于25M时，就使用map-side join
```

## 2. 大表 join 大表
* 桶表: 大表化成小表，map side join 解决（`注意`：分桶的判断字段 0 值或空值过多的情况）

```
hive> set hive.optimize.bucketmapjoin=true;
```
