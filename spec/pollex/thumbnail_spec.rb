require 'spec_helper'
require 'support/vcr'
require 'mini_magick'

require 'pollex'

describe Pollex::Thumbnail do

  it 'generates a thumbnail' do
    VCR.use_cassette 'same_size', :record => :none do
      thumb = Pollex::Thumbnail.generate 'hhgttg'

      thumb.wont_be_nil
      thumb.must_be_kind_of Pollex::Thumbnail

      thumb.file.closed?.wont_equal true
      MiniMagick::Image.open(thumb.file.path)['dimensions'].
        must_equal [ 200, 150 ]

      thumb.filename.must_equal 'cover.png'
      thumb.type.must_equal    '.png'
    end
  end

  it 'scales down a large image' do
    VCR.use_cassette 'large_same_dimensions', :record => :none do
      thumb = Pollex::Thumbnail.generate 'hhgttg'

      MiniMagick::Image.open(thumb.file.path)['dimensions'].
        must_equal [ 200, 150 ]
    end
  end

  it 'scales down and crops a large image' do
    VCR.use_cassette 'large_square', :record => :none do
      thumb = Pollex::Thumbnail.generate 'hhgttg'

      MiniMagick::Image.open(thumb.file.path)['dimensions'].
        must_equal [ 200, 150 ]
    end
  end

  it "doesn't scale up a small image" do
    VCR.use_cassette 'small', :record => :none do
      thumb = Pollex::Thumbnail.generate 'hhgttg'

      MiniMagick::Image.open(thumb.file.path)['dimensions'].
        must_equal [ 1, 1 ]
    end
  end

  it "doesn't thumbmail a nonexistent drop" do
    VCR.use_cassette 'nonexistent', :record => :none do
      lambda { Pollex::Thumbnail.generate 'hhgttg' }.must_raise Pollex::Drop::NotFound
    end
  end

  it "doesn't thumbnail a non-image" do
    VCR.use_cassette 'text', :record => :none do
      lambda { Pollex::Thumbnail.generate 'hhgttg' }.must_raise Pollex::Thumbnail::NotImage
    end
  end

  it 'handles unicode urls' do
    VCR.use_cassette 'unicode', :record => :none do
      Pollex::Thumbnail.generate('hhgttg').file.wont_equal nil
    end
  end

end
