require 'spec_helper'

describe S3utils::Queue do

  let :queue do
    S3utils::Queue.new 'my-queue',
                       *queue_directories
  end

  let :queue_directories do
    %w(
      /201/109/111/148/311/27
      my-queue/20110911114833567
    )
  end

  def new_batch( queue, name )
    S3utils::Batch.new queue,
                       name
  end

  context '#initialize' do

    context '#name' do

      subject { queue.name }

      it { should == 'my-queue' }

    end

    context '#batches' do

      subject { queue.batches }

      it { should == [new_batch( queue, '20110911114831127' ),
                      new_batch( queue, '20110911114833567' )] }

    end

  end

end
