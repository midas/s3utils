require 'spec_helper'

describe S3utils::Operations::BucketCopy do

  let :bucket_copy do
    S3utils::Operations::BucketCopy.new 'bucket-1',
                                        'bucket-2'
  end

  context '.identifier' do

    subject { described_class.identifier }

    it { should == 'bucket-copy' }

  end

  context '#initialize' do

    context '#source_bucket' do

      subject { bucket_copy.source_bucket }

      it { should == 'bucket-1' }

    end

    context '#destination_bucket' do

      subject { bucket_copy.destination_bucket }

      it { should == 'bucket-2' }

    end

  end

  context '#name' do

    subject { bucket_copy.name }

    it { should == 'bucket-copy-bucket-1-to-bucket-2' }

  end

  context '#enqueue' do

    def remove_queue_directory
      path = File.join( File.expand_path( '~' ),
                              S3utils::HOME,
                              bucket_copy.name )
      FileUtils.rm_rf( path ) if File.exists?( path )
    end

    before :each do
      remove_queue_directory
      bucket_copy.enqueue
    end

    after :each do
      remove_queue_directory
    end

    it "should create a base directory for the bucket copy" do
      File.exists?( File.join( File.expand_path( '~' ),
                               S3utils::HOME,
                               bucket_copy.name )
                  ).should be_true
    end

  end

end
