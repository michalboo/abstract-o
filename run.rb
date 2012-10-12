require 'rubygems'
require 'watir-webdriver'
require 'net/http'
require 'json'


consumer_key = '4654e0c31ad8fa1dbaed683f1e47027404d357753'
print "Type in your search term: "
search_term = gets.chomp
print "What language do you like? Describe it using two letters. (Examples that work nicely: es, pl, it, la, de, ar, fr, hu, sv, ja, ko, zh-TW: "
language = gets.chomp



search_result = Net::HTTP.get('api.mendeley.com', URI.escape('/oapi/documents/search/' + search_term + '/?consumer_key=' + consumer_key + '&items=5'))
search_result_json = JSON.parse(search_result)
search_documents = search_result_json['documents']

doc_ids = []
search_documents.each do |f|
  doc_ids << f["uuid"]
end

doc_details = JSON.parse(Net::HTTP.get('api.mendeley.com', URI.escape('/oapi/documents/details/' + doc_ids[0] + '/?consumer_key=' + consumer_key)))
doc_title = doc_details["title"]
doc_abstract = doc_details["abstract"]

translate_request_url = 'http://translate.google.com/#auto/' + language + '/' + URI.escape("Title: " + doc_title + " Abstract: " + doc_abstract)

$rain = Watir::Browser.new(:firefox)
$rain.goto('http://www.rainymood.com/')

$b = Watir::Browser.new(:firefox)

if translate_request_url.length > 2000
  $b.goto('http://translate.google.com/#auto/' + language + '/')
  $b.textarea(:id => 'source').set("Title: " + doc_title + " Abstract: " + doc_abstract)
else
  $b.goto(translate_request_url)
end

Watir::Wait.until(5, "Waiting for the 'listen' button.") { $b.div(:id => 'gt-res-listen').present? }
$b.div(:id => 'gt-res-listen').click  


puts "Say something once you're done with listening... "
bye1 = gets.chomp

$b.close
$rain.goto('http://hooooooooo.com/')

puts "Yeah Boiiiiii!"
bye2 = gets.chomp
$rain.close