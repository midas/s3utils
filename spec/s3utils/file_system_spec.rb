require 'spec_helper'

describe S3utils::FileSystem do

  def s3utils;            '.s3utils';         end
  def user_home;          `echo $HOME`.chomp; end
  def queue;              'my-queue';         end
  def to_do_filename;     'to-do';            end
  def done_filename;      'done';             end

  let :file_system do
    S3utils::FileSystem.new
  end

  def remove_queue_directory
    path = File.join( File.expand_path( '~' ),
                            S3utils::HOME,
                            'my-queue' )
    FileUtils.rm_rf( path ) if File.exists?( path )
  end

  after :each do
    remove_queue_directory
  end

  context '#current_home' do

    subject { file_system.current_home }

    it { should == `echo $HOME`.chomp }

  end

  context '#s3_utils_home' do

    subject { file_system.s3_utils_home }

    it { should == s3utils }

  end

  context '#base_path' do

    subject { file_system.base_path }

    it { should == File.join( user_home, s3utils ) }

  end

  context '#named_queue_path' do

    subject { file_system.named_queue_path( queue ) }

    it { should == File.join( user_home, s3utils, queue ) }

  end

  context '#named_batch_path' do

    subject { file_system.named_batch_path( queue ) }

    it { should =~ /^#{File.join( user_home, s3utils, queue )}\/\d{14,17}$/ }

  end

  context '#to_do_filename' do

    subject { file_system.to_do_filename }

    it { should == to_do_filename }

  end

  context '#to_do_file_path' do

    subject { file_system.to_do_file_path( queue ) }

    it { should =~ /^#{File.join( user_home, s3utils, queue )}\/\d{14,17}\/#{to_do_filename}$/ }

  end

  context '#done_filename' do

    subject { file_system.done_filename }

    it { should == done_filename }

  end
  
  context '#partitioned_timestamp' do
    
    it "should return a sane partitioned timestamp" do
      file_system.send( :partitioned_timestamp ).should =~ /\/\d{3}\/\d{3}\/\d{3}\/\d{3}\/\d{3}\/\d{2}/
    end
    
  end

end
