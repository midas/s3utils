module S3utils
  autoload :Batch,      's3utils/batch'
  autoload :FileSystem, 's3utils/file_system'
  autoload :Operations, 's3utils/operations'
  autoload :Queue,      's3utils/queue'

  HOME           = '.s3utils'
  DONE_FILENAME  = 'done'
  TO_DO_FILENAME = 'to-do'
end
