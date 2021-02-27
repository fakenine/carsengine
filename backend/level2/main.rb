# frozen_string_literal: true

require 'json'
require './getaround_service'

data = JSON.parse(File.open('./data/input.json').read)
service = GetaroundService.new(data)

service.compute

puts service.serialize.to_json
