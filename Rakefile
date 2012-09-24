#!/usr/bin/env ruby"

require 'rake/clean'

CLEAN.include("tmp", "html")

desc "Run all the specs"
task :default => [:specs, :stories]

desc "Run the unit level specs"
task :specs do
  sh "rspec spec"
end

desc "Run the story specs"
task :stories do |task|
  sh "rspec stories"
end
