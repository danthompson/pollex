require 'spec_helper'
require 'rack/test'
require 'support/vcr'

require 'pollex'
require 'pollex/app'

describe Pollex::App do

  include Rack::Test::Methods

  def app
    Pollex::App.tap { |app| app.set :environment, :test }
  end

  it 'redirects the home page to the CloudApp product page' do
    get '/'

    assert { last_response.redirect? }

    headers = last_response.headers
    assert { headers['Location'] == 'http://getcloudapp.com' }
    assert { headers['Cache-Control'] == 'public, max-age=31557600' }
  end

  it 'redirects the favicon to the CloudApp favicon' do
    get '/favicon.ico'

    assert {last_response.redirect? }

    headers = last_response.headers
    assert { headers['Location'] == 'http://cl.ly/favicon.ico' }
    assert { headers['Cache-Control'] == 'public, max-age=31557600' }
  end

  it 'returns thunbnail for drop' do
    VCR.use_cassette 'small' do
      EM.synchrony do
        get '/hhgttg'
        EM.stop

        assert { last_response.ok? }

        headers = last_response.headers
        assert { headers['Content-Type'] == 'image/png' }
        assert { headers['Content-Disposition'] == 'inline' }
        assert { headers['Cache-Control'] == 'public, max-age=900' }
      end
    end
  end

  it 'returns not found for a nonexistent drop' do
    VCR.use_cassette 'nonexistent' do
      EM.synchrony do
        get '/hhgttg'
        EM.stop

        assert { last_response.not_found? }
        last_response.body == '<h1>Not Found</h1>'
      end
    end
  end

  it 'redirects to the icon for a non-image drop' do
    VCR.use_cassette 'text' do
      EM.synchrony do
        get '/hhgttg'
        EM.stop

        assert { last_response.redirect? }

        headers = last_response.headers
        assert { headers['Location'] == 'http://example.org/icons/text.png' }
        assert { headers['Cache-Control'] == 'public, max-age=31557600' }
      end
    end
  end

  it 'redirects to the unknown icon for a file type without an icon' do
    VCR.use_cassette 'pdf' do
      EM.synchrony do
        get '/hhgttg'
        EM.stop

        assert { last_response.redirect? }

        headers = last_response.headers
        assert { headers['Location'] == 'http://example.org/icons/unknown.png' }
        assert { headers['Cache-Control'] == 'public, max-age=31557600' }
      end
    end
  end

end
