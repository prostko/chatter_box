class AddPartitioningToPosts < ActiveRecord::Migration[7.2]
  def up
    # This is by and large taken from the internet, but these are generally the step to partition the 
    # Posts table created_at by day.
    # This is a native PostGreSQL feature, and is not a gem or rails feature. I believe Rails 8 does have native partition support 
    # Otherwise, probably a good idea to use a solid external library for this kind of thing.
    # Other considerations for a partitioned table are:
    # - The partitions need to be created and pruned, likely by a background job trigged by chron of some sort
    # - the partitions need to be monitored  
    return true 

    # Step 1: Create a new partitioned table with the same structure
    create_table :partitioned_posts, id: :bigint do |t|
      t.string :title, limit: 100
      t.string :body, limit: 1000
      t.timestamp :deleted_at, null: true
      t.timestamp :published_at, null: true
      t.timestamps
    end

    # Step 2: Convert the new table to a partitioned table
    execute <<-SQL
      ALTER TABLE partitioned_posts PARTITION BY RANGE (created_at);
    SQL

    # Step 3: Create partitions for existing data and future data
    execute <<-SQL
      DO $$
      DECLARE
        min_date DATE;
        max_date DATE;
        current_date DATE;
      BEGIN
        -- Get the date range of existing data
        SELECT 
          DATE(MIN(created_at)), 
          DATE(MAX(created_at))
        INTO min_date, max_date
        FROM posts;
        
        -- If no data exists, start from today
        IF min_date IS NULL THEN
          min_date := CURRENT_DATE;
          max_date := CURRENT_DATE + INTERVAL '30 days';
        END IF;
        
        -- Create partitions for each day in the range
        current_date := min_date;
        WHILE current_date <= max_date + INTERVAL '30 days' LOOP
          EXECUTE format(
            'CREATE TABLE partitioned_posts_y%sm%sd%s PARTITION OF partitioned_posts
             FOR VALUES FROM (%L) TO (%L)',
            EXTRACT(YEAR FROM current_date),
            LPAD(EXTRACT(MONTH FROM current_date)::TEXT, 2, '0'),
            LPAD(EXTRACT(DAY FROM current_date)::TEXT, 2, '0'),
            current_date,
            current_date + INTERVAL '1 day'
          );
          current_date := current_date + INTERVAL '1 day';
        END LOOP;
      END $$;
    SQL
  end

  def down
  end
end
