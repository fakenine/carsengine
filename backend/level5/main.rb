require 'json'
require './getaround_service'

data = JSON.parse(File.open('./data/input.json').read)
service = GetaroundService.new(data)

service.compute

puts service.serialize
