require 'em-synchrony'
require 'em-synchrony/em-http'
require 'ostruct'
require 'yajl'

class Drop < OpenStruct

  class NotFound < StandardError; end

  def self.base_uri
    @@base_uri
  end
  @@base_uri = ENV.fetch 'CLOUDAPP_DOMAIN', 'api.cld.me'

  def self.find(slug)
    Drop.new Yajl::Parser.parse(fetch_drop_content(slug))
  end

  def image?
    %w( bmp
        gif
        ico
        jp2
        jpe
        jpeg
        jpf
        jpg
        jpg2
        jpgm
        png ).include? extension
  end

private

  def self.fetch_drop_content(slug)
    request = EM::HttpRequest.new("http://#{ base_uri }/#{ slug }").
                              get(:head => { 'Accept'=> 'application/json' })

    raise NotFound unless request.response_header.status == 200

    request.response
  end

  def extension
    File.extname(content_url)[1..-1].to_s.downcase if content_url
  end

end
