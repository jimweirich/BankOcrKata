#!/usr/bin/env ruby"

require 'rake/clean'

CLEAN.include("tmp")

task :default => [:specs, :stories]

task :specs do
  sh "rspec spec"
end

task :stories do |task|
  sh "rspec stories"
end
