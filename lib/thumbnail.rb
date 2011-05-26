require 'mini_magick'
require 'tempfile'

# Thumbnail
# ---------
#
# **Thumbnail** accepts a **Drop** as JSON and generates a thumbnail if it's
# an image. For all other file type, `NotImage` is raised.
class Thumbnail < Struct.new(:drop)

  # Raised when the drop being thumbaniled is not an image.
  class NotImage < StandardError; end

  def file
    raise NotImage.new unless drop.image?

    @file ||= begin
                resize_image
                image.
                  write(tempfile).
                  flush
              end
  end

  # Returns the remote file's filename.
  def filename
    File.basename remote_url
  end

  # Returns the remote file's extension.
  def type
    File.extname remote_url
  end

protected

  # The URL of the **Drop's** remote file.
  def remote_url
    drop.remote_url
  end

  # Load and return the **Drop's** remote file.
  def image
    @image ||= MiniMagick::Image.open(remote_url)
  end

  # Resize `image` preserving aspect ratio and crop to fit within 250x150.
  # Images smaller are not altered.
  def resize_image
    image.combine_options do |c|
      c.resize  '200x150^' if image_too_large?
      c.gravity 'northwest'
      c.crop    '200x150+0+0'
      c.repage.+
    end
  end

  # Checks the image and returns true if either of its dimensions exceed
  # 250x150.
  def image_too_large?
    image[:width] > 200 && image[:height] > 150
  end

  # The temporary file used to hold the thumbnailed **Drop**.
  def tempfile
    @tempfile ||= Tempfile.new(File.basename(remote_url))
  end
end
