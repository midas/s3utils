module S3utils
  class Bucket

    attr_reader :name

    def initialize( name )
      @name = name
    end

  end
end