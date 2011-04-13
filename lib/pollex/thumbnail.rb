require 'mini_magick'
require 'tempfile'

class Pollex
  class Thumbnail < Struct.new(:drop)

    class NotImage < StandardError; end

    def initialize(drop)
      raise NotImage.new unless drop['item_type'] == 'image'

      super
    end

    def self.generate(slug)
      Thumbnail.new Drop.find(slug)
    end

    def file
      @file ||= begin
                  resize_image
                  image.
                    write(tempfile).
                    flush
                end
    end

    def filename
      File.basename remote_url
    end

    def type
      File.extname remote_url
    end

  protected

    def remote_url
      drop['remote_url']
    end

    def image
      @image ||= MiniMagick::Image.open(remote_url)
    end

    def resize_image
      image.combine_options do |c|
        c.resize  '200x150^' if image_too_large?
        c.gravity 'northwest'
        c.crop    '200x150+0+0'
        c.repage.+
      end
    end

    def image_too_large?
      image[:width] > 200 && image[:height] > 150
    end

    def tempfile
      @tempfile ||= Tempfile.new(File.basename(remote_url))
    end
  end

end
