require 'nokogiri'
require 'curb'
require 'csv'
require 'yaml'
require './category'

PARAMS = YAML.load(File.read("params.yaml"))
url = PARAMS['URL']
filename = PARAMS['FILENAME']
category = Category.new(url , filename)
category.get_all_pages