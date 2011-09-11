module S3utils
  class FileSystem

    def named_queue_path( name )
      File.join base_path,
                name
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
      'to-do'
    end

    def done_filename
      'done'
    end

    def base_path
      File.join current_home,
                s3_utils_home
    end

    def s3_utils_home
      '.s3utils'
    end

    def current_home
      File.expand_path '~'
    end

  private

    def timestamp
      Time.now.strftime "%Y%m%d%H%M%S%L"
    end

  end
end
