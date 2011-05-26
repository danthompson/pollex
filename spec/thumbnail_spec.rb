require 'spec_helper'
require 'support/vcr'
require 'mini_magick'

require 'drop'
require 'thumbnail'

describe Thumbnail do

  it 'generates a thumbnail' do
    EM.synchrony do
      VCR.use_cassette 'same_size' do
        thumb = Thumbnail.new Drop.find('hhgttg')
        image = MiniMagick::Image.open thumb.file.path, thumb.extname

        deny   { thumb.nil? }
        assert { thumb.is_a? Thumbnail }

        deny { thumb.file.closed? }

        assert { image['dimensions'] == [ 200, 150 ] }
        assert { thumb.filename == 'cover.png' }
        assert { thumb.type     == '.png' }
        assert { thumb.extname  == '.png' }

        EM.stop
      end
    end
  end

  it 'scales down a large image' do
    EM.synchrony do
      VCR.use_cassette 'large_same_dimensions' do
        thumb = Thumbnail.new Drop.find('hhgttg')
        image = MiniMagick::Image.open thumb.file.path, thumb.extname

        assert { image['dimensions'] == [ 200, 150 ] }

        EM.stop
      end
    end
  end

  it 'scales down and crops a large image' do
    EM.synchrony do
      VCR.use_cassette 'large_square' do
        thumb = Thumbnail.new Drop.find('hhgttg')
        image = MiniMagick::Image.open thumb.file.path, thumb.extname

        assert { image['dimensions'] == [ 200, 150 ] }

        EM.stop
      end
    end
  end

  it "doesn't scale up a small image" do
    EM.synchrony do
      VCR.use_cassette 'small' do
        thumb = Thumbnail.new Drop.find('hhgttg')
        image = MiniMagick::Image.open thumb.file.path, thumb.extname

        assert { image['dimensions'] == [ 1, 1 ] }

        EM.stop
      end
    end
  end

  it "doesn't thumbnail a non-image" do
    EM.synchrony do
      VCR.use_cassette 'text' do
        thumb = Thumbnail.new Drop.find('hhgttg')

        assert { rescuing { thumb.file }.is_a? Thumbnail::NotImage }

        EM.stop
      end
    end
  end

  it 'handles ico files' do
    EM.synchrony do
      VCR.use_cassette 'favicon' do
        thumb = Thumbnail.new Drop.find('hhgttg')
        image = MiniMagick::Image.open thumb.file.path, thumb.extname

        assert { image['dimensions'] == [ 16, 16 ] }

        EM.stop
      end
    end
  end

  it 'handles unicode urls' do
    EM.synchrony do
      VCR.use_cassette 'unicode' do
        thumb = Thumbnail.new Drop.find('hhgttg')

        deny { thumb.file.nil? }

        EM.stop
      end
    end
  end

end
