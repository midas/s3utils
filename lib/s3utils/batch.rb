module S3utils
  class Batch

    attr_reader :queue, :name

    def initialize( queue, name )
      @queue      = queue
      @name       = name.gsub( /\//, '' )
    end

    def queue_name
      queue.name
    end

    def ==( another_batch )
      return false unless another_batch.is_a?( S3utils::Batch )
      return false unless another_batch.queue_name == queue_name
      return false unless another_batch.name == name

      true
    end

    def <=>( another_batch )
      return -1 if name < another_batch.name
      return  1 if name > another_batch.name

      0
    end

  end
end
