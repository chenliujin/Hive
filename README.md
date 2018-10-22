hive 知识点


# 数据类型

# 分区

---

# 桶

桶是通过对`指定列`进行哈希计算来实现的，通过哈希值`将一个列名下的数据切分为一组桶`，并使`每个桶对应于该列名下的一个存储文件`。

## 1. 优点
* 因为桶的数量是固定的，所以它没有数据波动。(数据倾斜?)
* 数据抽样：桶对于抽样再合适不过。如果两个表都是按照 user_id 进行分桶的话，那么 Hive 可以创建一个逻辑上正确的抽样。
* 分桶同时有利于执行高效的 map-side JOIN

## 2. 分区和桶的区别

##

```
create table student(
  id int,
  age int,
  name string
)
partitioned by (stat_date string)
clustered by (id) sorted by(age) into 100 bucket
```

---

# UDF (用户自定义函数)

# 视图

# 数据抽样

开发和测试阶段如何抽样？

# Q&A
1. 文本字段，很大，hive 如何处理
