require 'sinatra/base'

class Pollex

  # App
  # ------
  #
  # **App** is a simple Sinatra app that generates and returns thumbnails of
  # CloudApp Drops. Images are pulled from their remote location and thumbnailed
  # using **MiniMagick**. Any non-image Drop returns a glyph representing the
  # type of file it is.
  class App < Sinatra::Base

    # Load New Relic RPM and Hoptoad in the production and staging environments.
    configure(:production, :staging) do
      require 'newrelic_rpm'

      # Add your Hoptoad API key to the environment variable `HOPTOAD_API_KEY`
      # to use Hoptoad to catalog your exceptions.
      if ENV['HOPTOAD_API_KEY']
        require 'hoptoad_notifier'
        HoptoadNotifier.configure do |config|
          config.api_key = ENV['HOPTOAD_API_KEY']
        end

        use HoptoadNotifier::Rack
        enable :raise_errors
      end
    end

    # Serve static assets from `/public`
    set :public, 'public'

    # The home page. Nothing to see here. Redirect to the CloudApp product page.
    # Response is cached for one year.
    get '/' do
      cache_control :public, :max_age => 31557600
      redirect 'http://getcloudapp.com'
    end

    # Redirect to the public app's favicon. Response is cached for one year.
    get '/favicon.ico' do
      cache_control :public, :max_age => 31557600
      redirect 'http://cl.ly/favicon.ico'
    end

    # Generate a thumbnail for a `Drop` given its slug. Thumbnails are cached
    # for up to 15 minutes.
    get '/:slug' do |slug|
      thumbnail = generate_thumbnail slug

      cache_control :public, :max_age => 900
      send_file thumbnail.file, :disposition => 'inline',
                                :type        => thumbnail.type
    end

    # Don't need to return anything special for a 404.
    not_found do
      not_found '<h1>Not Found</h1>'
    end

  protected

    # Generate the thumbnail for a given `slug`. Handle `Drop::NotFound` and
    # `Thumbnail::NotImage errors and render the not found response.
    def generate_thumbnail(slug)
      thumbnail = Pollex::Thumbnail.generate slug
    rescue Drop::NotFound
      not_found
    rescue Thumbnail::NotImage
      not_found
    end

  end
end
