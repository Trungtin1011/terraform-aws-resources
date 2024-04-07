# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_partition
resource "aws_glue_partition" "this" {
  count = var.create_partition != false ? length(var.partitions) : 0

  partition_values = var.partitions[count.index].partition_values
  table_name       = var.partitions[count.index].table_name
  database_name    = var.partitions[count.index].database_name
  catalog_id       = try(var.partitions[count.index].catalog_id, null)
  parameters       = try(var.partitions[count.index].parameters, null)

  dynamic "storage_descriptor" {
    for_each = try(var.partitions[count.index].storage_descriptor, null) != null ? [true] : []

    content {
      bucket_columns            = try(var.partitions[count.index].storage_descriptor.bucket_columns, null)
      compressed                = try(var.partitions[count.index].storage_descriptor.compressed, null)
      input_format              = try(var.partitions[count.index].storage_descriptor.input_format, null)
      location                  = try(var.partitions[count.index].storage_descriptor.location, null)
      number_of_buckets         = try(var.partitions[count.index].storage_descriptor.number_of_buckets, null)
      output_format             = try(var.partitions[count.index].storage_descriptor.output_format, null)
      parameters                = try(var.partitions[count.index].storage_descriptor.parameters, null)
      stored_as_sub_directories = try(var.partitions[count.index].storage_descriptor.stored_as_sub_directories, null)

      dynamic "columns" {
        for_each = try(var.partitions[count.index].storage_descriptor.columns, null) != null ? [true] : []

        content {
          name    = var.partitions[count.index].storage_descriptor.columns.name
          comment = try(var.partitions[count.index].storage_descriptor.columns.comment, null)
          type    = try(var.partitions[count.index].storage_descriptor.columns.type, null)
        }
      }

      dynamic "ser_de_info" {
        for_each = try(var.partitions[count.index].storage_descriptor.ser_de_info, null) != null ? [true] : []

        content {
          name                  = try(var.partitions[count.index].storage_descriptor.ser_de_info.name, null)
          parameters            = try(var.partitions[count.index].storage_descriptor.ser_de_info.parameters, null)
          serialization_library = try(var.partitions[count.index].storage_descriptor.ser_de_info.serialization_library, null)
        }
      }

      dynamic "skewed_info" {
        for_each = try(var.partitions[count.index].storage_descriptor.skewed_info, null) != null ? [true] : []

        content {
          skewed_column_names               = try(var.partitions[count.index].storage_descriptor.skewed_info.skewed_column_names, null)
          skewed_column_value_location_maps = try(var.partitions[count.index].storage_descriptor.skewed_info.skewed_column_value_location_maps, null)
          skewed_column_values              = try(var.partitions[count.index].storage_descriptor.skewed_info.skewed_column_values, null)
        }
      }

      dynamic "sort_columns" {
        for_each = try(var.partitions[count.index].storage_descriptor.sort_columns, null) != null ? [true] : []

        content {
          column     = var.partitions[count.index].storage_descriptor.sort_columns.column
          sort_order = var.partitions[count.index].storage_descriptor.sort_columns.sort_order
        }
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_partition_index
resource "aws_glue_partition_index" "this" {
  count = var.create_partition_index != false ? length(var.indexes) : 0

  table_name    = var.indexes[count.index].table_name
  database_name = var.indexes[count.index].database_name
  catalog_id    = try(var.indexes[count.index].catalog_id, null)

  partition_index {
    index_name = var.indexes[count.index].partition_index.index_name
    keys       = var.indexes[count.index].partition_index.keys
  }

  lifecycle {
    create_before_destroy = true
  }
}


###### Below code blocks require additional out-of-box argument when creating Partitions/Partition-Indexes
# So it was replaced by above code blocks

# resource "aws_glue_partition" "this" {
#   for_each = {
#     for key in var.partitions : key.partition_order => {
#       # partition_order used as a unique ID for each partition
#       partition_values   = try(key.partition_values, null)
#       table_name         = try(key.table_name, null)
#       database_name      = try(key.database_name, null)
#       catalog_id         = try(key.catalog_id, null)
#       partition_index    = try(key.partition_index, null)
#       parameters         = try(key.parameters, null)
#       storage_descriptor = try(key.storage_descriptor, null)
#     }
#     if var.create_partition != false
#   }

#   partition_values = each.value.partition_values
#   table_name       = each.value.table_name
#   database_name    = each.value.database_name
#   catalog_id       = each.value.catalog_id
#   parameters       = each.value.parameters

#   dynamic "storage_descriptor" {
#     for_each = "${each.value.storage_descriptor}" != null ? [true] : []

#     content {
#       bucket_columns            = try(var.partitions[count.index].storage_descriptor.bucket_columns, null)
#       compressed                = try(var.partitions[count.index].storage_descriptor.compressed, null)
#       input_format              = try(var.partitions[count.index].storage_descriptor.input_format, null)
#       location                  = try(var.partitions[count.index].storage_descriptor.location, null)
#       number_of_buckets         = try(var.partitions[count.index].storage_descriptor.number_of_buckets, null)
#       output_format             = try(var.partitions[count.index].storage_descriptor.output_format, null)
#       parameters                = try(var.partitions[count.index].storage_descriptor.parameters, null)
#       stored_as_sub_directories = try(var.partitions[count.index].storage_descriptor.stored_as_sub_directories, null)

#       dynamic "columns" {
#         for_each = try(var.partitions[count.index].storage_descriptor.columns, null) != null ? [true] : []

#         content {
#           name    = each.value.storage_descriptor.columns.name
#           comment = try(var.partitions[count.index].storage_descriptor.columns.comment, null)
#           type    = try(var.partitions[count.index].storage_descriptor.columns.type, null)
#         }
#       }

#       dynamic "ser_de_info" {
#         for_each = try(var.partitions[count.index].storage_descriptor.ser_de_info, null) != null ? [true] : []

#         content {
#           name                  = try(var.partitions[count.index].storage_descriptor.ser_de_info.name, null)
#           parameters            = try(var.partitions[count.index].storage_descriptor.ser_de_info.parameters, null)
#           serialization_library = try(var.partitions[count.index].storage_descriptor.ser_de_info.serialization_library, null)
#         }
#       }

#       dynamic "skewed_info" {
#         for_each = try(var.partitions[count.index].storage_descriptor.skewed_info, null) != null ? [true] : []

#         content {
#           skewed_column_names               = try(var.partitions[count.index].storage_descriptor.skewed_info.skewed_column_names, null)
#           skewed_column_value_location_maps = try(var.partitions[count.index].storage_descriptor.skewed_info.skewed_column_value_location_maps, null)
#           skewed_column_values              = try(var.partitions[count.index].storage_descriptor.skewed_info.skewed_column_values, null)
#         }
#       }

#       dynamic "sort_columns" {
#         for_each = try(var.partitions[count.index].storage_descriptor.sort_columns, null) != null ? [true] : []

#         content {
#           column     = each.value.storage_descriptor.sort_columns.column
#           sort_order = each.value.storage_descriptor.sort_columns.sort_order
#         }
#       }
#     }
#   }
# }

# resource "aws_glue_partition_index" "this" {
#   for_each = {
#     for key in var.indexes : key.index_order => {
#       # index_order used as a unique ID for each index
#       table_name      = try(key.table_name, null)
#       database_name   = try(key.database_name, null)
#       catalog_id      = try(key.catalog_id, null)
#       partition_index = try(key.partition_index, null)
#     }
#     if var.create_partition_index != false
#   }

#   table_name    = each.value.table_name
#   database_name = each.value.database_name
#   catalog_id    = each.value.catalog_id

#   partition_index {
#     index_name = each.value.partition_index.index_name
#     keys       = each.value.partition_index.keys
#   }
# }