module S3utils
  class FileSystem

    attr_reader :base_path

    def initialize
      @base_path = File.join( current_home, '.s3utils' )
    end

    def current_home
      File.expand_path '~'
    end

  end
end
