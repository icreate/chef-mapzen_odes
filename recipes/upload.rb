#
# Cookbook Name:: mapzen_odes
# Recipe:: upload
#
# Copyright 2013, Mapzen
#
# All rights reserved - Do Not Redistribute
#

# get region
stack = search("aws_opsworks_stack").first
node.set[:mapzen_odes][:region] = stack['region']

chef_gem 'aws-sdk' do
  version       node[:mapzen_odes][:upload][:aws_sdk_version]
  compile_time  false
  retries       2
  retry_delay   30
end

# upload
#
ruby_block 'upload extracts and shapes to S3' do
  block do
    require 'aws-sdk'

    upload_dirs = [
      "#{node[:mapzen_odes][:setup][:basedir]}/ex",
      "#{node[:mapzen_odes][:setup][:basedir]}/shp",
      "#{node[:mapzen_odes][:setup][:basedir]}/coast"
    ]

    region  = node[:mapzen_odes][:region]
    bucket  = node[:mapzen_odes][:upload][:s3bucket]
    s3      = Aws::S3::Resource.new(region: region)

    upload_dirs.each do |dir|
      Dir.foreach(dir) do |file|
        next if file == '.' || file == '..'

        begin
          obj = s3.bucket(bucket).object(file)
          obj.upload_file("#{dir}/#{file}", content_type: 'binary/octet-stream')
        rescue StandardError => e
          Chef::Log.info("Caught exception while uploading object #{file} to S3 bucket #{bucket}: #{e}")
          abort
        else
          Chef::Log.info("Completed successful upload of #{file} to #{bucket}!")
        end
      end
    end
  end

  notifies :run, 'execute[cleanup]', :immediately
  only_if { node[:mapzen_odes][:upload_data] == true }
end

execute 'cleanup' do
  action  :nothing
  user    node[:mapzen_odes][:user][:id]
  command <<-EOH
    rm -f #{node[:mapzen_odes][:setup][:basedir]}/ex/* &&
    rm -f #{node[:mapzen_odes][:setup][:basedir]}/shp/* &&
    rm -f #{node[:mapzen_odes][:setup][:basedir]}/coast/*
  EOH
end
