require_relative '../lib/crypto_scraper'

describe 'fetch_crypto_prices' do
  it 'retourne un tableau non vide' do
    result = fetch_crypto_prices
    expect(result).not_to be_empty
  end

  it 'contient des hashes avec nom et prix' do
    sample = fetch_crypto_prices.first
    expect(sample).to be_a(Hash)
    expect(sample.keys.first).to be_a(String)
    expect(sample.values.first).to be_a(Float)
  end
end