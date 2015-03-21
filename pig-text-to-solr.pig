--
--  Author: Hari Sekhon
--  Date: 2015-03-12 22:49:01 +0000 (Thu, 12 Mar 2015)
--
--  vim:ts=4:sts=4:sw=4:et
--

-- Pig script to index [bz2 compressed] text files or logs for fast source file lookups in SolrCloud
--
-- This was a simple use case where I didn't need to parse the logs as it's more oriented around finding source data files based on full-text search.

-- Tested on Pig 0.14 on Tez via Hortonworks HDP 2.2

-- https://docs.lucidworks.com/display/lweug/Using+Pig+with+LucidWorks+Search

-- USAGE:
--
-- must download LucidWorks connector for Hadoop from here (the Hortonworks link is much bigger as it contains a full HDP Search including Solr, Banana and Tika pipeline as well as this connector):
--
-- https://lucidworks.com/product/integrations/hadoop/
-- 
-- hadoop fs -put hadoop-lws-job.jar
--
-- pig -p path=/data/logs -p collection=LOGS -p zkhost=<zookeeper_list>/solr pig-text-to-solr.pig

REGISTER 'hadoop-lws-job.jar';

REGISTER 'pig-udfs.jy' USING jython AS hari;

-- can set defaults for collection, zkhost etc to not have to enter them on command line every time
--%default path '/data';
--%default collection 'collection1';
--%default zkhost 'localhost:2181';

-- use zkhost for SolrCloud, it's more efficient to skip first hop using client side logic and also it's more highly available
set solr.zkhost $zkhost;

-- use solrUrl only for standard old standalone Solr
--set solr.solrUrl $solrUrl;

set solr.collection $collection;
--%declare solr.collection $collection;

-- for file-by-file as one doc each but doesn't scale
--set lww.buffer.docs.size 1;

set lww.buffer.docs.size 1000;
set lww.commit.on.close true;

set mapred.map.tasks.speculation.execution false;
set mapred.reduce.tasks.speculation.execution false;

lines  = LOAD '$path' USING PigStorage('\n', '-tagPath') AS (path:chararray, line:chararray);
-- this causes out of heap errors in Solr because some files may be too large to handle this way - it doesn't scale 
--lines2 = FOREACH (GROUP lines BY path) GENERATE $0 AS path, BagToString($0, ' ') AS line:chararray;
--lines_final = FOREACH lines2 GENERATE UniqueId() AS id, 'path_s', path, 'line_s', line;

-- preserve whitespace but check and remove lines that are only whitespace
lines2 = FILTER lines BY line IS NOT NULL AND TRIM(line) != '';

-- strip redundant prefixes like hdfs://nameservice1 or file: to avoid storing the same bytes over and over without value
--lines3 = FOREACH lines2 GENERATE REPLACE(path, '^file:', '') AS path, line;
lines3 = FOREACH lines2 GENERATE REPLACE(path, '^hdfs://\\w+(?::\\d+)?', '') AS path, line;
-- order by path asc -- to force a sort + shuffle -- to find out if the avg requests per sec are being held back by the mapper phase decompressing bz2 files or something else by forcing a reduce phase

-- since the lines in the file may not be unique was considering using a uuid -- can use UniqueId() from Pig 0.14
-- hari.md5_uuid(line) from Jython UDFs gives a uuid based of concatenated millisecond timestamp, host, pid and md5 of line - this allows to find duplicate lines via a 'id:$path*$md5' type search if wanted
-- going back to using suffixed Solr fields in case someone hasn't configured their schema properly they should be able to fall back on dynamicFields
lines_final = FOREACH lines3 GENERATE CONCAT(path, '|', hari.md5_uuid(line)) AS id, 'path_s', path, 'line_s', line;

STORE lines_final INTO 'IGNORED' USING com.lucidworks.hadoop.pig.SolrStoreFunc();
