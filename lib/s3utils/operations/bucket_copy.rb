module S3utils::Operations
  class BucketCopy

    attr_reader :source_bucket, :destination_bucket, :batch_size

    def self.identifier
      'bucket-copy'
    end

    def initialize( source_bucket, destination_bucket, batch_size=500 )
      @source_bucket      = source_bucket
      @destination_bucket = destination_bucket
      @batch_size         = batch_size
    end

    def name
      [
        self.class.identifier,
        source_bucket,
        'to',
        destination_bucket
      ].join( '-' )
    end

    def enqueue
      file_system.named_queue_path( name )
    end

  private

    def file_system
      S3utils::FileSystem.new
    end

  end
end