#!/usr/bin/env ruby
# _*_ coding: utf-8 _*_

require 'logger'
log = Logger.new(STDOUT)
log.level = Logger::WARN

require 'clockwork'
include Clockwork

handler do |job|
    Thread.new do
        begin
            job.call
        rescue => exc
            log.error("#{job.class} failed: #{exc.to_s}")
        else
            log.info("#{job.class} succeeded")
        end
    end
end

require './job/update_ddns_job'
every( 1.day, UpdateDdnsJob.new("config/field.yaml"), :at => '04:00')

