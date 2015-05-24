Hadoop, Web and other Unix Tools [![Build Status](https://travis-ci.org/harisekhon/toolbox.svg?branch=master)](https://travis-ci.org/harisekhon/toolbox)
================================

A few of the Hadoop, Web and other nifty "Unixy" tools I've written over the years that are generally useful across environments. All programs have --help to list the available options.

For many more tools, see the Advanced Nagios Plugins Collection which contains many Hadoop, NoSQL, Web and infrastructure monitoring CLI programs that integrate with Nagios - https://github.com/harisekhon/nagios-plugins.

Hari Sekhon

Big Data Contractor, United Kingdom

http://www.linkedin.com/in/harisekhon

##### Make sure you run ```make update``` if updating and not just ```git pull``` as you will often need the latest library submodule and possibly new upstream libraries. #####

### A Sample of cool Programs in this toolbox ###

- ```hadoop_hdfs_time_block_reads.jy``` - Hadoop HDFS per-block read timing debugger with datanode and rack locations for a given file or directory tree. Reports the slowest Hadoop datanodes in descending order at the end
- ```pig-text-to-elasticsearch.pig``` / ```pig-text-to-solr.pig``` - index unstructured files in Hadoop to Elasticsearch or Solr/SolrCloud clusters
- ```scrub.pl``` - anonymizes your logs / configs for pasting online for debug help. Replaces hostnames/domains/FQDNs, IP + MAC addresses, Cisco/Juniper passwords, shared keys and SNMP strings, as well as taking a  configuration file of custom phrases such your name, your company's name etc. Each replacement is replaced with a placeholder saying what was replaced, and there is even an --ip-prefix switch to leave the last IP octect to aid in cluster debugging so vendors/online helpers can still see differentiated nodes communicating with each other in logs
- ```watch_url.pl``` - watches a given url, outputting status code and optionally output, useful for debugging web farms behind load balancers and seeing the distribution to different servers (trick: use a /hostname type url to see what you're hitting in the --output)
- ```solr_cli.pl``` - Solr command line tool with shortcuts under solr/ which make it much easier and quicker to use the Solr APIs instead of always using long tedious curl calls. Supports a lot of environments variables and tricks to allow for minimal typing when administering a Solr/SolrCloud cluster via the Collections and Cores APIs
- ```sql_uppercase_keywords.pl``` - cleans up your SQL / Pig / Neo4j keywords with the correct capitalization. SQL-like dialects supported include Hive, Impala, Cassandra, MySQL, PostgreSQL, Microsoft SQL Server and Oracle
- ```watch_nginx_stats.pl``` - watches nginx stats via the HttpStubStatusModule module
- ```ipython-notebook-pyspark.py``` - per-user authenticated IPython Notebook + PySpark integration to allow each user to auto-create their own password protected IPython Notebook running Spark
- ```difnet.pl``` - print net line additions/removals from diff / patch files or stdin
- ```java_show_classpath.pl``` - shows java classpaths of a running Java program in a sane way
- ```datameer-config-git.pl``` - revision controls Datameer configurations from API to Git
- ```ibm-bigsheets-config-git.pl``` - revision controls IBM BigSheets configurations from API to Git
- ```ambari_freeipa_kerberos_setup.pl``` - Automates Hadoop cluster security Kerberos setup of FreeIPA principals and keytab distribution to the cluster nodes

### Setup ###

The 'make' command will initialize my library submodule and  use 'sudo' to install the required CPAN modules:

```
git clone https://github.com/harisekhon/toolbox
cd toolbox
make
```

#### OR: Manual Setup ####

Enter the toolbox directory and run git submodule init and git submodule update to fetch my library repo and then install the CPAN modules as mentioned further down:

```
git clone https://github.com/harisekhon/toolbox
cd toolbox
git submodule init
git submodule update
```

Then proceed to install the CPAN modules below by hand.

###### CPAN Modules ######

Install the following CPAN modules using the cpan command, use sudo if you're not root:

```
sudo cpan JSON LWP::Simple LWP::UserAgent Term::ReadKey Text::Unidecode Time::HiRes XML::LibXML XML::Validate 
```

You're now ready to use these programs.

### Jython for Hadoop Utils ###

A couple of the Hadoop utilities listed below require Jython (as well as Hadoop to be installed and correctly configured or course)

```
hadoop_hdfs_time_block_reads.jy
hadoop_hdfs_files_native_checksums.jy
hadoop_hdfs_files_stats.jy
```

Jython is a simple download and unpack and can be fetched from http://www.jython.org/downloads.html

Then add the Jython untarred directory to the $PATH or specify the /path/to/jythondir/bin/jython explicitly:

```
/path/to/jython-x.y.z/bin/jython -J-cp `hadoop classpath` hadoop_hdfs_time_block_reads.jy --help
```

The ```-J-cp `hadoop classpath` ``` bit does the right thing in finding the Hadoop java classes required to use the Hadoop APIs.

### Updating ###

Run ```make update```. This will git pull and then git submodule update which is necessary to pick up corresponding library updates, then try to build again using 'make install' to fetch any new CPAN depe
ndencies.

If you update often and want to just quickly git pull + submodule update but skip rebuilding all those dependencies each time then run ```make update2``` (will miss new library dependencies - do full ```m
ake update``` if you encounter issues).

### Usage ###

All programs come with a ```--help``` switch which includes a program description and the list of command line options.

### Contributions ###

Patches, improvements and even general feedback are welcome in the form of GitHub pull requests and issue tickets.

### See Also ###

The Advanced Nagios Plugins Collection which contains hundreds of production grades command line programs for Nagios compatible monitoring systems covering these technologies and others, and can also be used in scripts.

https://github.com/harisekhon/nagios-plugins
