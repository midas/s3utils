require 'spec_helper'

describe S3utils::Batch do

  let :batch do
    S3utils::Batch.new 'my-queue',
                       '20110911114831127'
  end

  let :batch_with_different_queue_name do
    S3utils::Batch.new 'my-different-queue',
                       '20110911114831127'
  end

  let :batch_with_different_name do
    S3utils::Batch.new 'my-queue',
                       '20110911114831128'
  end

  context '#initialize' do

    context '#queue_name' do

      subject { batch.queue_name }

      it { should == 'my-queue' }

    end

    context '#name' do

      subject { batch.name }

      it { should == '20110911114831127' }

    end

  end

  context '#==' do

    context 'when the compared object is not a S3utils::Batch' do

      subject { batch == "string" }

      it { should be_false }

    end

    context 'when the compared object is an S3utils::Batch with a different queue name' do

      subject { batch == batch_with_different_queue_name }

      it { should be_false }

    end

    context 'when the compared object is an S3utils::Batch with a different name' do

      subject { batch == batch_with_different_name }

      it { should be_false }

    end

  end

end
