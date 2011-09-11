module S3utils
  class Queue

    attr_reader :name, :batches

    def initialize( name, *batches )
      @name = name

      @batches = batches.map do |batch|
        S3utils::Batch.new( *batch.split( '/' ) )
      end
    end

  end
end
