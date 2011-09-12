module S3utils::Operations
  class BucketCopy

    attr_reader :source_bucket, :destination_bucket, :batch_size

    def self.identifier
      'bucket-copy'
    end

    def initialize( source_bucket, destination_bucket, batch_size=nil )
      @source_bucket      = source_bucket
      @destination_bucket = destination_bucket
      @batch_size         = batch_size || default_batch_size
    end

    def default_batch_size
      1000
    end

    def name
      [
        self.class.identifier,
        source_bucket,
        'to',
        destination_bucket,
        timestamp
      ].join( '-' )
    end

    def enqueue
      queue = S3utils::Queue.new( name )

      each_batch_of_keys do |response|

        queue.add_batch( response.map { |c| c[:key] } )

      end

    end

  private

    def each_batch_of_keys
      raise 'Requires block' unless block_given?

      marker = ''

      while 1 == 1
        response = s3.list_bucket( 'archivalock-production', { 'marker'   => marker,
                                                               'max-keys' => batch_size,
                                                               'prefix'   => 'pages/nacogdochestx-cc' } )
        break if response == []
        marker = response.last[:key]
        yield response
      end
    end

    def s3
      @s3 ||= RightAws::S3Interface.new( s3_credentials[:access_key_id],
                                         s3_credentials[:secret_access_key],
                                         :multi_thread => true,
                                         :port         => 80,
                                         :protocol     => 'http',
                                         :logger       => logger )
    end

    def s3_credentials
      @s3_credentials ||= YAML::load_file( File.join( File.expand_path( '~' ), '.s3-credentials.yml' ) )[:archivalock]
    end

    def logger
      @logger ||= nil
      # log       = Logger.new( STDOUT )
      # log.level = Logger::ERROR
    end

    def file_system
      @file_system ||= S3utils::FileSystem.new
    end

    def timestamp
      file_system.timestamp
    end

  end
end