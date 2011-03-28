require 'sinatra/base'

# Pollex
# ------
class Pollex
  class App < Sinatra::Base

    # Load New Relic RPM in the production environment.
    configure(:production) { require 'newrelic_rpm' }

    # Nothing to see here. Redirect to the CloudApp product page. Response is
    # cached for a year.
    get '/' do
      cache_control :public, :max_age => 31557600
      redirect 'http://getcloudapp.com'
    end

    # Use the public app's favicon. Response is cached for a year.
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

    def generate_thumbnail(slug)
      thumbnail = Pollex::Thumbnail.generate slug
    rescue Drop::NotFound
      raise Sinatra::NotFound
    rescue Thumbnail::NotImage
      raise Sinatra::NotFound
    end

  end
end
