module S3utils
  class FileSystem

    def named_queue_path( name )
      path = File.join( base_path,
                        name )

      FileUtils.mkdir_p path

      path
    end

    def named_batch_path( name )
      File.join named_queue_path( name ),
                timestamp
    end

    def to_do_file_path( queue_name )
      File.join named_batch_path( queue_name ),
                to_do_filename
    end

    def to_do_filename
      S3utils::TO_DO_FILENAME
    end

    def done_filename
      S3utils::DONE_FILENAME
    end

    def base_path
      File.join current_home,
                s3_utils_home
    end

    def s3_utils_home
      S3utils::HOME
    end

    def current_home
      File.expand_path '~'
    end

  private

    def timestamp
      Time.now.strftime "%Y%m%d%H%M%S%L"
    end
    
    def partitioned_timestamp
      a_timestamp = timestamp
      partitioned = []
      
      while a_timestamp.size > 0
        partitioned << a_timestamp.slice!( 0..2 )
      end
      
      "/#{File.join( *partitioned )}"
    end

  end
end
