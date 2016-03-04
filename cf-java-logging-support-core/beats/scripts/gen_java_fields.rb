require 'yaml'
require 'set'
require 'pp'

file_names = []

fields = Set.new


ARGV.each do |fname|
  file_names << fname.split('/')[-4..-1].join('/')
  f = File.new(fname, 'r')
  spec = YAML::load(f)
  f.close
  spec.keys.each do |k|
    if spec[k].class == Hash && spec[k].has_key?('fields')
      spec[k]['fields'].each do |f|
        fields.add(f['name'])
      end
    end
  end
end

puts <<EOD
/*
 * THIS FILE IS AUTOMATICALLY GENERATED FROM THE FOLLOWING SEPCIFICATION FILES:
 *
 * - #{file_names.join("\n * - ")}
 *
 */

package com.sap.hcp.cf.logging.common;

public interface Fields {
EOD

fields.each do |f|
  puts "  public String #{f.upcase} = \"#{f}\";"
end

puts "}"