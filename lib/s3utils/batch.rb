module S3utils
  class Batch

    attr_reader :queue_name, :name

    def initialize( queue_name, name )
      @queue_name = queue_name
      @name       = name
    end

    def ==( another_batch )
      return false unless another_batch.is_a?( S3utils::Batch )
      return false unless another_batch.queue_name == queue_name
      return false unless another_batch.name == name

      true
    end

  end
end
