pt-online-schema-change-analyze
===============================

Analyze a MySQL table after migrating it.

In certain cases it is recommended not to allow MySQL to recalculate table statistics as it can cause a drift in query plans. More info [here](http://www.mysqlperformanceblog.com/2011/10/06/when-does-innodb-update-table-statistics-and-when-it-can-bite/) and [here](http://www.mysqlperformanceblog.com/2013/12/03/innodb_stats_on_metadata-slow-queries-information_schema/).

This can cause a problems when using [pt-online-schema-change](http://www.percona.com/doc/percona-toolkit/2.2/pt-online-schema-change.html) as the statistics might not be correct on the new table. This plugin analyzes the table right after the swap is done which allows MySQL to recalculate the statistics.

To use the plugin just add:
```
--plugin /path/to/plugin/pt-online-schema-change-analyze.pl
```
to your `pt-online-schema-change` command.
