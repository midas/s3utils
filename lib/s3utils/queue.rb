module S3utils
  class Queue

    attr_reader   :name
    attr_accessor :batches

    def initialize( name, *batches )
      @name = name

      @batches = batches.map do |batch|
        parts = batch.split( '/' )
        parts.shift if parts.first == name
        batch_name = parts.compact.join

        S3utils::Batch.new( self,
                            batch_name )
      end
    end

    def add_batch( keys )
      Batch.create( self, keys )
    end

  end
end
