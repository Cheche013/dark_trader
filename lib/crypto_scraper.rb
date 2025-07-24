require 'nokogiri'
require 'open-uri'

def fetch_crypto_prices
  url = 'https://coinmarketcap.com/all/views/all/'
  doc = Nokogiri::HTML(URI.open(url))

  cryptos = []

  doc.css('tbody tr').each do |row|
    name = row.at_css('.coin-item-symbol')&.text
    price = row.css('td')[3]&.text

    next if name.nil? || price.nil?

    price_value = price.gsub(/[^\d\.]/, '').to_f
    cryptos << { name => price_value }
  end

  cryptos
end