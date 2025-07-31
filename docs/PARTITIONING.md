# PostgreSQL Table Partitioning

This document explains how to use the partitioning system implemented for the `posts` table.

## Overview

The `posts` table is partitioned by day using `created_at` as the partition key. This provides several benefits:

- **Performance**: Queries filtering by date can skip irrelevant partitions
- **Maintenance**: Old partitions can be dropped easily
- **Storage**: Better data organization and potential storage savings

## Migration

To apply partitioning to an existing table:

```bash
rails db:migrate
```

This migration will:
1. Create a new partitioned table with the same structure
2. Copy all existing data to the new table
3. Drop the old table and rename the new one
4. Recreate all necessary indexes

## Managing Partitions

### Creating New Partitions

To create partitions for the next 30 days:

```bash
rails partitions:create_posts_partitions
```

### Listing All Partitions

To see all existing partitions:

```bash
rails partitions:list_posts_partitions
```

### Dropping Old Partitions

To drop partitions older than a specified number of days (default: 90 days):

```bash
# Drop partitions older than 90 days
rails partitions:drop_old_posts_partitions

# Drop partitions older than 30 days
rails partitions:drop_old_posts_partitions[30]
```

## Partition Naming Convention

Partitions are named using the format: `posts_y{YYYY}m{MM}d{DD}`

Examples:
- `posts_y2024m01d15` - January 15, 2024
- `posts_y2024m12d31` - December 31, 2024

## Automatic Partition Management

For production environments, consider setting up a cron job to automatically create new partitions:

```bash
# Add to crontab to run daily at 2 AM
0 2 * * * cd /path/to/your/app && rails partitions:create_posts_partitions
```

## Querying Partitioned Tables

When querying the partitioned table, PostgreSQL will automatically use partition pruning when you filter by `created_at`:

```ruby
# This query will only scan relevant partitions
Post.where(created_at: Date.current.beginning_of_day..Date.current.end_of_day)

# This query will scan all partitions (less efficient)
Post.where(title: "Some Title")
```

## Best Practices

1. **Always filter by date** when possible to take advantage of partition pruning
2. **Create partitions in advance** to avoid missing data
3. **Drop old partitions regularly** to manage storage
4. **Monitor partition sizes** to ensure even distribution
5. **Test queries** to ensure they're using partition pruning effectively

## Troubleshooting

### Checking Partition Usage

To see which partitions are being used in a query:

```sql
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM posts 
WHERE created_at >= '2024-01-01' AND created_at < '2024-01-02';
```

### Manual Partition Creation

If you need to create a partition manually:

```sql
CREATE TABLE posts_y2024m01d15 PARTITION OF posts
FOR VALUES FROM ('2024-01-15') TO ('2024-01-16');
```

### Checking Partition Data

To see data distribution across partitions:

```sql
SELECT 
  tablename,
  COUNT(*) as row_count
FROM pg_tables t
LEFT JOIN posts p ON p.created_at::date = 
  SUBSTRING(t.tablename FROM 'posts_y(\d{4})m(\d{2})d(\d{2})')::date
WHERE tablename LIKE 'posts_y%m%d%'
GROUP BY tablename
ORDER BY tablename;
```

## Rollback

If you need to rollback the partitioning migration:

```bash
rails db:rollback
```

**Warning**: The rollback will recreate a non-partitioned table and may lose data if not handled carefully. 