namespace :partitions do
  desc "Create new daily partitions for posts table"
  task create_posts_partitions: :environment do
    puts "Creating new daily partitions for posts table..."
    
    # Calculate the date range for new partitions
    # Start from the last existing partition or today
    last_partition_date = ActiveRecord::Base.connection.execute(<<-SQL).first&.dig('max_date')
      SELECT MAX(SUBSTRING(tablename FROM 'posts_y(\d{4})m(\d{2})d(\d{2})')::DATE) as max_date
      FROM pg_tables 
      WHERE tablename LIKE 'posts_y%m%d%'
    SQL
    
    start_date = last_partition_date || Date.current
    end_date = Date.current + 30.days # Create partitions for next 30 days
    
    puts "Creating partitions from #{start_date} to #{end_date}"
    
    (start_date..end_date).each do |date|
      partition_name = "posts_y#{date.year}m#{date.strftime('%m')}d#{date.strftime('%d')}"
      
      # Check if partition already exists
      exists = ActiveRecord::Base.connection.execute(<<-SQL).first&.dig('exists')
        SELECT EXISTS(
          SELECT 1 FROM pg_tables 
          WHERE tablename = '#{partition_name}'
        ) as exists
      SQL
      
      unless exists
        ActiveRecord::Base.connection.execute(<<-SQL)
          CREATE TABLE #{partition_name} PARTITION OF posts
          FOR VALUES FROM ('#{date}') TO ('#{date + 1.day}');
        SQL
        puts "Created partition: #{partition_name}"
      else
        puts "Partition already exists: #{partition_name}"
      end
    end
    
    puts "Partition creation completed!"
  end

  desc "List all partitions for posts table"
  task list_posts_partitions: :environment do
    puts "Listing all partitions for posts table:"
    
    partitions = ActiveRecord::Base.connection.execute(<<-SQL)
      SELECT 
        tablename,
        SUBSTRING(tablename FROM 'posts_y(\d{4})m(\d{2})d(\d{2})')::DATE as partition_date
      FROM pg_tables 
      WHERE tablename LIKE 'posts_y%m%d%'
      ORDER BY partition_date
    SQL
    
    partitions.each do |partition|
      puts "  #{partition['tablename']} (#{partition['partition_date']})"
    end
    
    puts "Total partitions: #{partitions.count}"
  end

  desc "Drop old partitions (older than specified days)"
  task :drop_old_posts_partitions, [:days_to_keep] => :environment do |task, args|
    days_to_keep = (args[:days_to_keep] || 90).to_i
    cutoff_date = Date.current - days_to_keep.days
    
    puts "Dropping partitions older than #{cutoff_date} (keeping #{days_to_keep} days)..."
    
    partitions_to_drop = ActiveRecord::Base.connection.execute(<<-SQL)
      SELECT tablename
      FROM pg_tables 
      WHERE tablename LIKE 'posts_y%m%d%'
        AND SUBSTRING(tablename FROM 'posts_y(\d{4})m(\d{2})d(\d{2})')::DATE < '#{cutoff_date}'
      ORDER BY tablename
    SQL
    
    if partitions_to_drop.any?
      partitions_to_drop.each do |partition|
        puts "Dropping partition: #{partition['tablename']}"
        ActiveRecord::Base.connection.execute("DROP TABLE #{partition['tablename']}")
      end
      puts "Dropped #{partitions_to_drop.count} partitions"
    else
      puts "No partitions to drop"
    end
  end
end 