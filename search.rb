module Owls
  class Search
    ACCOUNT_KEY = 'ZJeiKyE3lzxZN/9bMZYPuEQrpmRUISjaO5QaSovBi6U'

    BING_API_URL = 'https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%27image%27&Query=%27owl%27&Adult=%27Strict%27&ImageFilters=%27size%3Amedium%27&$format=json'

    def get_owl_urls
      result = search_for_owls
      retrieve_image_urls(result)
    end

    private

    def search_for_owls
      uri = URI(BING_API_URL)

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth '', ACCOUNT_KEY

      Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end
    end

    def retrieve_image_urls(str)
      results = JSON.parse(str)

      results['d']['results'][0]['Image'].inject([]) { |images, result| images << result['MediaUrl'] }
    end
  end
end