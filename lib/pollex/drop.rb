require 'em-synchrony'
require 'em-synchrony/em-http'
require 'ostruct'
require 'yajl'

class Pollex
  class Drop < OpenStruct

    class NotFound < StandardError; end

    def self.base_uri
      @@base_uri
    end
    @@base_uri = ENV.fetch 'CLOUDAPP_DOMAIN', 'api.cld.me'

    def self.find(slug)
      request = EM::HttpRequest.new("http://#{ base_uri }/#{ slug }").
      get(:head => { 'Accept'=> 'application/json' })

      raise NotFound unless request.response_header.status == 200

      Drop.new Yajl::Parser.parse(request.response)
    end

    def image?
      item_type == 'image'
    end

  end
end
