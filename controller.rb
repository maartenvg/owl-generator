require 'sinatra'
require 'json'
require './owl.rb'
require './search.rb'

configure do
end

get '/random/:size' do
  size = params[:size].to_i

  # TODO: cache this
  search = Owls::Search.new
  urls = search.get_owl_urls
  url = urls.sample

  generator = Owls::OwlGenerator.new(size)
  image = generator.generate_owl(url)

  content_type :json
  load = {original: url, image: image}
  load.to_json
end