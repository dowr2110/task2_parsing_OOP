require './product'

module Parsable
  PARAMS = YAML.load(File.read("params.yaml"))

  def get_doc(url)
    convert_to_url = URI.parse(url)
    http = Curl.get(convert_to_url)
    doc = Nokogiri::HTML(http.body)
  end

  def parse_product(url)
    doc = get_doc(url)
    products = []
    doc.xpath(PARAMS['type_product']).each do |row|
      product_price = row.search(PARAMS['price']).text.strip
      product_image = row.at_xpath(PARAMS['image']).text.strip
      product_full_name = row.at_xpath(PARAMS['name']).text.strip + "\n" + row.search(PARAMS['weight']).text.strip
      product = Product.new( product_full_name, product_price, product_image)
      products.push( product )
    end
    products
  end

  def save_to_csv(products)
    column_header = [ "Name", "Price", "Image" ]
    CSV.open(@filename,"a+" ,force_quotes:true ) do |file|
      file << column_header if file.count.eql? 0
      products.each do |product|
        file << [ product.name, product.price, product.image ]
        puts product.to_s
      end
    end
  end

  def count_products_in_one_page(doc)
    count_of_products = 0
    doc.xpath(PARAMS['product_container']).each do |row|
      count_of_products += 1
    end
    count_of_products
  end

  def get_and_save_products(doc)
    count_of_products = count_products_in_one_page(doc)
    products = []
    all_urls = doc.xpath(PARAMS['product_desc']).first(count_of_products)
    all_urls.each do |url|
      products += parse_product(url.text)
    end
    save_to_csv(products)
  end

  def parse_by_url(count_of_pages, url)
    doc = get_doc(url)
    threads = []
    get_and_save_products(doc) #for first page
    (2..count_of_pages).each do |i| #for another pages
      threads << Thread.new(i) do |urll|
        doc = get_doc(url + "?p=#{i}")
        get_and_save_products(doc)
      end
    end
    threads.each {|thr| thr.join }
  end
end
