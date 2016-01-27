# key=request_date-uri
CREATE TABLE wa_page_load_time_uri(
	key STRING,
	site STRING,
	request_date STRING,
	uri STRING,
	pv INT,
	request_time_total INT
)  
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key, data:site, data:request_date, data:uri, data:pv, data:request_time_total")
TBLPROPERTIES ("hbase.table.name" = "wa_page_load_time_uri");