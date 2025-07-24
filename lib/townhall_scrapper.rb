require 'nokogiri'
require 'open-uri'

# ----------------------------
# Récupère l'e-mail depuis la page d'une mairie
# ----------------------------
def get_townhall_email(townhall_url)
  page = Nokogiri::HTML(URI.open(townhall_url))
  email = page.xpath('//table//tr[td[contains(text(),"Adresse Email")]]/td[2]').text
  email.empty? ? "Email non trouvé" : email
end

# ----------------------------
# Récupère la liste des villes et leurs URLs
# ----------------------------
def get_townhall_urls
  base_url = "http://www.annuaire-des-mairies.com"
  page = Nokogiri::HTML(URI.open("#{base_url}/val-d-oise.html"))

  links = page.css('a.lientxt')
  links.map do |link|
    name = link.text.strip
    href = link['href'].sub(/^\./, '') # enlève le point au début du href
    full_url = base_url + href
    { name => full_url }
  end
end

# ----------------------------
# Combine toutes les infos : villes + e-mails
# ----------------------------
def get_val_doise_emails
  puts "🔎 Chargement des URL des mairies..."
  town_list = get_townhall_urls

  puts "📩 Récupération des e-mails..."
  town_list.map do |town|
    name = town.keys.first
    url = town[name]
    email = get_townhall_email(url)
    puts "✅ #{name} : #{email}"
    { name => email }
  end
end

# ----------------------------
# Lancement du script
# ----------------------------
if __FILE__ == $0
  result = get_val_doise_emails
  puts "\nRésultat final (10 premiers) :"
  puts result.first(10)
end