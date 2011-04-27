require 'spec_helper'
require 'rack/test'
require 'support/vcr'

require 'pollex'
require 'pollex/app'

describe Pollex::App do

  include Rack::Test::Methods

  def app
    Pollex::App
  end

  it 'redirects the home page to the CloudApp product page' do
    get '/'

    last_response.redirect?.must_equal true
    last_response.headers['Location'].must_equal 'http://getcloudapp.com'
    last_response.headers['Cache-Control'].must_equal 'public, max-age=31557600'
  end

  it 'redirects the favicon to the CloudApp favicon' do
    get '/favicon.ico'

    last_response.redirect?.must_equal true
    last_response.headers['Location'].must_equal 'http://cl.ly/favicon.ico'
    last_response.headers['Cache-Control'].must_equal 'public, max-age=31557600'
  end

  it 'returns thunbnail for drop' do
    VCR.use_cassette 'small', :record => :none do
      get '/hhgttg'

      last_response.ok?.must_equal true
      last_response.headers['Content-Type'].must_equal 'image/png'
      last_response.headers['Content-Disposition'].must_equal 'inline'
      last_response.headers['Cache-Control'].must_equal 'public, max-age=900'
    end
  end

  it 'returns not found for a nonexistent drop' do
    VCR.use_cassette 'nonexistent', :record => :none do
      get '/hhgttg'

      last_response.not_found?.must_equal true
      last_response.body.must_equal '<h1>Not Found</h1>'
    end
  end

  it 'returns a glyph for a non-image drop' do
    VCR.use_cassette 'text', :record => :none do
      get '/hhgttg'

      last_response.status.must_equal 301
      last_response.headers['Location'].must_equal 'http://example.org/icons/text.png'
      last_response.headers['Cache-Control'].must_equal 'public, max-age=31557600'
    end
  end

end
