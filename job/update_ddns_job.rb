#!/usr/bin/env ruby
# _*_ coding: utf-8 _*_

require 'yaml'
require 'mechanize'

class UpdateDdnsJob
    def initialize(config)
        @agent = Mechanize.new
        @conf = YAML.load_file(config)
        @conf["fields"].each do |idx, val|
            @conf["fields"][idx] = val.unpack("m")[0] if idx =~ /password/
        end
    end

    def call
        @agent.get(@conf["uri"]) do |page|
            conf_page = page.form_with(action: @conf["login_action"]) do |f|
                @conf["fields"].each do |idx, val|
                    f.field_with(name: idx).value = val
                end
            end.click_button
        end
    end
end
