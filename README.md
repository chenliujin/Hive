# 数据倾斜

# 数据挖掘流程/架构
* 数据源
* ETL
  - datastage
  - 工作流
  - 生日 -> 星座
  - 0/1 or M/F => 性别：男/女
* OLAP
* 数据可视化

https://blog.csdn.net/orange_spotty_cat/article/details/80252579

hive 知识点


# 数据类型

| 数据类型 | 字节 |
| --- | --- |
| TINYINT | 1 Byte |
| SMALLINT | 2 Byte |
| INT | 4 Byte |
| BIGINT | 8 Byte |
| BOOLEAN | |
| FLOAT | |
| DOUBLE | |
| STRING | |

# 分区


---

# 桶

桶是通过对`指定列`进行哈希计算来实现的，通过哈希值`将一个列名下的数据切分为一组桶`，并使`每个桶对应于该列名下的一个存储文件`。

## 1. 优点
* 因为桶的数量是固定的，所以它没有数据波动。(数据倾斜?)
* 数据抽样：桶对于抽样再合适不过。如果两个表都是按照 user_id 进行分桶的话，那么 Hive 可以创建一个逻辑上正确的抽样。
* 分桶同时有利于执行高效的 map-side JOIN

## 2. 分区和桶的区别(什么时候使用分区，什么时候使用分桶?)
* 数据倾斜：按小时进行分区，数据比较集中在其中几个小时，按小时进行分桶
* 某些字段不适合分区: title (STRING)
* 分区有数量限制：由于 HDFS 并不支持大量的子目录, 当列的基数太大时不适用，如：user_id
* 分桶是按照列的哈希函数进行分割的，相对比较平均；而分区是按照列的值来进行分割的，容易造成数据倾斜。

## 桶表

分区中的数据进行分桶：

```
hive> CREATE TABLE weblog (user_id INT, url STRING, source_ip STRING)
　　> PARTITIONED BY (dt STRING)
　　> CLUSTERED BY (user_id) INTO 96 BUCKETS;
```

插入数据：

```
hive> SET hive.enforce.bucketing = true;

hive> FROM raw_logs
　　> INSERT OVERWRITE TABLE weblog
　　> PARTITION (dt='2009-02-25')
　　> SELECT user_id, url, source_ip WHERE dt='2009-02-25';
```

数据抽样：

```
SELECT * FROM weblog TABLESAMPLE(BUCKET x OUT OF y)
```

x：表示从哪一个桶开始抽样

y：抽样因素，必须是桶数的因子或者倍数,假设桶数是100那么y可以是200,10,20,25,5。假设桶数是100，y=25时抽取(100/25) = 4个bucket数据;当y=200的时候(100/200) = 0.5个bucket的数据

---

# UDF (用户自定义函数)

# 视图

# 数据抽样

开发和测试阶段如何抽样？

# Q&A
1. 文本字段，很大，hive 如何处理
