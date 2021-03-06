require 'spec_helper'
require 'support/vcr'

require 'drop'

describe Drop do

  def self.subject(&block)
    define_method :subject, &block
  end


  describe 'an image' do
    subject do
      Drop.new :content_url => 'http://cl.ly/hhgttg/cover.png'
    end

    it 'is an image' do
      assert { subject.image? }
    end
  end

  describe 'a text file' do
    subject do
      Drop.new :content_url => 'http://cl.ly/hhgttg/chapter1.txt'
    end

    it 'is not an image' do
      deny { subject.image? }
    end
  end

  it 'finds a drop' do
    EM.synchrony do
      VCR.use_cassette 'small' do
        drop = Drop.find 'hhgttg'
        EM.stop

        assert { drop.is_a? Drop }
        assert { drop.href       == 'http://my.cl.ly/items/307' }
        assert { drop.remote_url == 'http://f.cl.ly/items/hhgttg/cover.png' }
        assert { drop.redirect_url.nil? }
      end
    end
  end

  it 'raises a DropNotFound error' do
    EM.synchrony do
      VCR.use_cassette 'nonexistent' do
        assert do
          rescuing { Drop.find('hhgttg') }.is_a? Drop::NotFound
        end

        EM.stop
      end
    end
  end

end
