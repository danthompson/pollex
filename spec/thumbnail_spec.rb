require 'spec_helper'
require 'support/vcr'
require 'mini_magick'

require 'drop'
require 'thumbnail'

describe Thumbnail do

  it 'generates a thumbnail' do
    EM.synchrony do
      VCR.use_cassette 'same_size' do
        drop  = Drop.find 'hhgttg'
        thumb = Thumbnail.new drop

        deny   { thumb.nil? }
        assert { thumb.is_a? Thumbnail }

        deny { thumb.file.closed? }
        assert do
          MiniMagick::Image.open(thumb.file.path)['dimensions'] == [ 200, 150 ]
        end

        assert { thumb.filename == 'cover.png' }
        assert { thumb.type     == '.png' }

        EM.stop
      end
    end
  end

  it 'scales down a large image' do
    EM.synchrony do
      VCR.use_cassette 'large_same_dimensions' do
        drop  = Drop.find 'hhgttg'
        thumb = Thumbnail.new drop

        assert do
          MiniMagick::Image.open(thumb.file.path)['dimensions'] == [ 200, 150 ]
        end

        EM.stop
      end
    end
  end

  it 'scales down and crops a large image' do
    EM.synchrony do
      VCR.use_cassette 'large_square' do
        drop  = Drop.find 'hhgttg'
        thumb = Thumbnail.new drop

        assert do
          MiniMagick::Image.open(thumb.file.path)['dimensions'] == [ 200, 150 ]
        end

        EM.stop
      end
    end
  end

  it "doesn't scale up a small image" do
    EM.synchrony do
      VCR.use_cassette 'small' do
        drop  = Drop.find 'hhgttg'
        thumb = Thumbnail.new drop

        assert do
          MiniMagick::Image.open(thumb.file.path)['dimensions'] == [ 1, 1 ]
        end

        EM.stop
      end
    end
  end

  it "doesn't thumbnail a non-image" do
    EM.synchrony do
      VCR.use_cassette 'text' do
        drop  = Drop.find 'hhgttg'
        thumb = Thumbnail.new drop

        assert { rescuing { thumb.file }.is_a? Thumbnail::NotImage }

        EM.stop
      end
    end
  end

  it 'handles unicode urls' do
    EM.synchrony do
      VCR.use_cassette 'unicode' do
        drop  = Drop.find 'hhgttg'
        thumb = Thumbnail.new drop

        deny { thumb.file.nil? }

        EM.stop
      end
    end
  end

end
