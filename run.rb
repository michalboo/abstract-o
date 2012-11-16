require 'rubygems'
require 'watir-webdriver'
require 'net/http'
require 'json'
require 'yaml'


key = YAML.load_file('keys.yml')["consumer_key"]

print "Type in your search term: "
search_term = gets.chomp
print "What language do you like? Describe it using two (or more, if you want Chinese) letters. (Examples that work nicely: es, pl, it, la, de, ar, fr, hu, sv, ja, ko, zh-TW: "
language = gets.chomp



search_result = Net::HTTP.get('api.mendeley.com', URI.escape('/oapi/documents/search/' + search_term + '/?consumer_key=' + key + '&items=10'))
search_result_json = JSON.parse(search_result)
search_documents = search_result_json['documents']

doc_ids = []
search_documents.each do |f|
  doc_ids << f["uuid"]
end

n = 0
doc_title = nil
doc_abstract = nil

until (doc_title != nil && doc_abstract != nil) do
  doc_details = JSON.parse(Net::HTTP.get('api.mendeley.com', URI.escape('/oapi/documents/details/' + doc_ids[n] + '/?consumer_key=' + key)))
  doc_title = doc_details["title"]
  doc_abstract = doc_details["abstract"]
  n = n + 1
end

translate_request_url = 'http://translate.google.com/#auto/' + language + '/' + URI.escape(doc_title + ". " + doc_abstract)

$rain = Watir::Browser.new(:firefox)
$rain.goto('http://www.rainymood.com/')

$b = Watir::Browser.new(:firefox)

if translate_request_url.length > 2000
  $b.goto('http://translate.google.com/#auto/' + language + '/')
  $b.textarea(:id => 'source').set(doc_title + ". " + doc_abstract)
else
  $b.goto(translate_request_url)
end

Watir::Wait.until(5, "Waiting for the 'listen' button.") { $b.div(:id => 'gt-res-listen').present? }
$b.div(:id => 'gt-res-listen').click  


puts "Say something once you're done with listening... "
bye1 = gets.chomp

$b.close
$rain.goto('http://heeeeeeeey.com/')

puts "Yeah Boiiiiii!"
bye2 = gets.chomp
$rain.close