require 'sinatra'
require './owl.rb'
require './search.rb'

configure do
end

get '/random' do
  search = Owls::Search.new
  generator = Owls::OwlGenerator.new
  urls = search.get_owl_urls

  url = urls.sample

  image = generator.generate_owl(url)

  "<pre style='line-height: 0.7em; font-size: 0.8em;'>#{image}</pre>"
end