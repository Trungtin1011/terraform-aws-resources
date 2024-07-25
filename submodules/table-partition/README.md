# table-partition

Terraform module to provision AWS Glue Catalog Tables.

## Usage

For Partition Indexes, only 1 index can be created or deleted simultaneously per table. So create **more than 1** Index at a time will cause error!

Please refer to [`table-partition`](../../examples/table_partition/main.tf) example file