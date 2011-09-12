module S3utils
  class Batch

    attr_reader :queue, :name, :new_batch

    attr_accessor :keys

    def initialize( queue, name=nil )
      @queue      = queue
      @name       = name.nil? ? nil : name.gsub( /\//, '' )
      @new_batch  = true
    end

    def queue_name
      queue.name
    end

    def self.create( queue, keys )
      batch      = Batch.new( queue )
      batch.keys = keys

      batch.save
    end

    def new_batch?
      new_batch
    end

    def save
      return save_new if new_batch?

      save_existing
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

  private

    def save_new
      batch_path = new_batch_path
puts batch_path
      FileUtils.mkdir_p( batch_path )

      write_keys File.join( batch_path,
                            to_do_filename )

      new_batch = false

      true
    end

    def save_existing
      #TODO implement this

      true
    end

    def write_keys( file_path )
      File.open( file_path, 'w' ) do |f|
        keys.each do |key|
          f.puts key
        end
      end
    end


    def new_batch_path
      File.join( base_path,
                 queue_name,
                 partitioned_timestamp )
    end

    # def timestamp
    #   file_system.timestamp
    # end

    def partitioned_timestamp
      file_system.partitioned_timestamp
    end

    # def partition( timestamp )
    #   file_system.partition( timestamp )
    # end

    def file_system
      @file_system ||= S3utils::FileSystem.new
    end

    def base_path
      file_system.base_path
    end

    def to_do_filename
      file_system.to_do_filename
    end

  end
end
