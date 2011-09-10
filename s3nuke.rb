#!/usr/bin/env ruby

# s3nuke.rb
# by: Stephen Eley (sfeley@gmail.com)
# A simple script to delete a very large bucket in Amazon S3.
# Licensed under the Apache License v2.0 (http://apache.org/licenses)
#
# RATIONALE: Deleting buckets containing many thousands or millions of
# objects in S3 is a huge pain, because the buckets must be empty before
# deletion and each object must be deleted individually.  Amazon provides
# no shortcuts for this.  This script uses the AWS::S3 gem and
# multiple threads to run a number of delete operations simultaneously,
# shortening the round-trip HTTP wait and making more efficient use of
# network bandwidth.

require 'rubygems'
require 'optparse'
require 'logger'
require 'thread'
begin
  require 'right_aws'
rescue LoadError
  puts "Missing the RightAWS gem! Try: sudo gem install right_aws"
  puts "or for Ruby 1.9: sudo gem install dmarkow-right_aws --source http://gems.github.com"
end

access_key = nil
secret_key = nil
thread_count = 10
buckets = []

# Parse the command line
begin
  opts = OptionParser.new
  opts.banner = "Usage: #{$PROGRAM_NAME} [options] buckets..."
  opts.separator ''
  opts.separator 'Options:'
  opts.on('-a',
          '--access ACCESS',
          String,
          'Amazon Access Key (required)') {|key| access_key = key}
  opts.on('-s',
          '--secret SECRET',
          String,
          'Amazon Secret Key (required)') {|key| secret_key = key}
  opts.on('-t',
          '--threads COUNT',
          Integer,
          "Number of simultaneous threads (default #{thread_count})") {|val| thread_count = val}
  opts.on('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
  opts.separator ''
  # opts.separator 'If the --access and --secret options are not used, the environment variables'
  # opts.separator 'AMAZON_ACCESS_KEY_ID and AMAZON_SECRET_ACCESS_KEY must be set.'
  opts.separator ''
  buckets = opts.parse(ARGV)
  if buckets.empty?
    puts "You must specify at least one bucket to delete!"
    puts opts
    exit
  end
  unless access_key and secret_key
    puts "The --access and --secret options are required!"
    puts opts
    exit
  end
rescue OptionParser::ParseError
  puts "Oops... #{$!}"
  puts opts
  exit
end

# Make a connection for bucket deletion
log = Logger.new(STDOUT)
log.level = Logger::ERROR
mains3 = RightAws::S3Interface.new(access_key, secret_key, :multi_thread => true, :port => 80, :protocol => 'http', :logger => log)
begin
  mains3.list_all_my_buckets  # Confirm credentials
rescue RightAws::AwsError => e
  puts e.message
  puts opts
  exit
end

buckets.each do |bucket|
  puts "DELETING: #{bucket}"

  # Thread management
  threads = []
  queue = Queue.new
  mutex_total = Mutex.new

  # Tracking variables
  total_listed = 0
  total_deleted = 0

  # Key retrieval thread
  threads << Thread.new do
    Thread.current[:number] = "CATALOG"
    print "Starting catalog thread...\n"
    s3 = RightAws::S3Interface.new(access_key, secret_key, :multi_thread => true, :port => 80, :protocol => 'http', :logger => log)
    prefix = ''
    begin
      keys = s3.list_bucket(bucket, :marker => prefix)
      prefix = keys.last[:key] unless keys.empty?
      keys.each do |key|
        queue.enq(key[:key])
        total_listed += 1
      end
    end until keys.empty?
    thread_count.times {queue.enq(:END_OF_BUCKET)}
  end

  thread_count.times do |count|
    threads << Thread.new(count) do |number|
      Thread.current[:number] = number
      print "Starting deletion thread #{number}...\n"
      s3 = RightAws::S3Interface.new(access_key, secret_key, :multi_thread => true, :port => 80, :protocol => 'http', :logger => log)
      begin
        key = queue.deq
        unless key == :END_OF_BUCKET
          s3.delete(bucket, key)
          mutex_total.synchronize {total_deleted += 1}
          print "Deleted #{total_deleted} out of #{total_listed}\n" if (rand(1000) == 1)
        end
      end until (key == :END_OF_BUCKET)
    end
  end

  threads.each do |t|
    begin
      t.join
    rescue RuntimeError => e
      puts "Failure on thread #{t[:number]}: #{e.message}"
    end
  end

  # Clean up any stragglers and kill the bucket
  puts "Bucket #{bucket} deleted!" if mains3.force_delete_bucket(bucket)
  puts
end
