require './parsable'

class Category
  attr_accessor :url , :filename

  def initialize(url, filename)
    @url = url
    @filename = filename
  end

  include Parsable

  def get_all_pages()
    puts "идет запись на файл..."
    doc = get_doc(@url)
    count_of_pages = doc.xpath(PARAMS['pagination']).text.to_i
    parse_by_url(count_of_pages, @url)
    puts "записано!!"
  end
end
