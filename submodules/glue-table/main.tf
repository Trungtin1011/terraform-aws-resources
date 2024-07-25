# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table
resource "aws_glue_catalog_table" "this" {
  name               = var.table_name
  description        = var.table_description
  database_name      = var.database_name
  catalog_id         = var.table_catalog_id
  owner              = var.table_owner
  retention          = var.table_retention
  table_type         = var.table_type
  view_expanded_text = var.table_view_expanded_text
  view_original_text = var.table_view_original_text
  parameters         = var.table_parameters

  dynamic "open_table_format_input" {
    for_each = var.open_table_format_input != null ? [true] : []

    content {
      iceberg_input {
        metadata_operation = var.open_table_format_input.iceberg_input.metadata_operation
        version            = try(var.open_table_format_input.iceberg_input.version, 2)
      }
    }
  }

  dynamic "partition_index" {
    iterator = partition_indexes
    for_each = var.table_partition_index

    content {
      index_name = lookup(partition_indexes.value, "index_name", null)
      keys       = lookup(partition_indexes.value, "keys", null)
    }
    # for_each = var.table_partition_index

    # content {
    #   index_name = var.table_partition_index.index_name
    #   keys       = var.table_partition_index.keys
    # }
  }

  dynamic "partition_keys" {
    iterator = partition_keys
    for_each = var.table_partition_keys

    content {
      name    = lookup(partition_keys.value, "name", null)
      comment = lookup(partition_keys.value, "comment", null)
      type    = lookup(partition_keys.value, "type", null)
    }
  }

  dynamic "target_table" {
    for_each = var.target_table != null ? [true] : []

    content {
      catalog_id    = var.target_table.catalog_id
      database_name = var.target_table.database_name
      name          = var.target_table.name
      region        = try(var.target_table.region, null)
    }
  }

  dynamic "storage_descriptor" {
    for_each = var.table_storage_descriptor != null ? [true] : []

    content {
      bucket_columns            = try(var.table_storage_descriptor.bucket_columns, null)
      compressed                = try(var.table_storage_descriptor.compressed, null)
      input_format              = try(var.table_storage_descriptor.input_format, null)
      location                  = try(var.table_storage_descriptor.location, null)
      number_of_buckets         = try(var.table_storage_descriptor.number_of_buckets, null)
      output_format             = try(var.table_storage_descriptor.output_format, null)
      parameters                = try(var.table_storage_descriptor.parameters, null)
      stored_as_sub_directories = try(var.table_storage_descriptor.stored_as_sub_directories, null)

      dynamic "columns" {
        for_each = try(var.table_storage_descriptor.columns, null) != null ? [true] : []

        content {
          name       = var.table_storage_descriptor.columns.name
          comment    = try(var.table_storage_descriptor.columns.comment, null)
          parameters = try(var.table_storage_descriptor.columns.parameters, null)
          type       = try(var.table_storage_descriptor.columns.type, null)
        }
      }

      dynamic "schema_reference" {
        for_each = try(var.table_storage_descriptor.schema_reference, null) != null ? [true] : []

        content {
          schema_version_number = var.table_storage_descriptor.schema_reference.schema_version_number
          schema_version_id     = try(var.table_storage_descriptor.schema_reference.schema_version_id, null)

          dynamic "schema_id" {
            for_each = try(var.table_storage_descriptor.schema_reference.schema_id, null) != null ? [true] : []

            content {
              registry_name = try(var.table_storage_descriptor.schema_reference.schema_id.registry_name, null)
              schema_arn    = try(var.table_storage_descriptor.schema_reference.schema_id.schema_arn, null)
              schema_name   = try(var.table_storage_descriptor.schema_reference.schema_id.schema_name, null)
            }
          }
        }
      }

      dynamic "ser_de_info" {
        for_each = try(var.table_storage_descriptor.ser_de_info, null) != null ? [true] : []

        content {
          name                  = try(var.table_storage_descriptor.ser_de_info.name, null)
          parameters            = try(var.table_storage_descriptor.ser_de_info.parameters, null)
          serialization_library = try(var.table_storage_descriptor.ser_de_info.serialization_library, null)
        }
      }

      dynamic "skewed_info" {
        for_each = try(var.table_storage_descriptor.skewed_info, null) != null ? [true] : []

        content {
          skewed_column_names               = try(var.table_storage_descriptor.skewed_info.skewed_column_names, null)
          skewed_column_value_location_maps = try(var.table_storage_descriptor.skewed_info.skewed_column_value_location_maps, null)
          skewed_column_values              = try(var.table_storage_descriptor.skewed_info.skewed_column_values, null)
        }
      }

      dynamic "sort_columns" {
        for_each = try(var.table_storage_descriptor.sort_columns, null) != null ? [true] : []

        content {
          column     = var.table_storage_descriptor.sort_columns.column
          sort_order = var.table_storage_descriptor.sort_columns.sort_order
        }
      }
    }
  }
}