require 'spec_helper'
require 'support/vcr'

require 'pollex'

describe Pollex::Drop do

  it 'is not an image' do
    drop = Pollex::Drop.new :item_type => 'text'

    deny { drop.image? }
  end

  it 'is an image' do
    drop = Pollex::Drop.new :item_type => 'image'

    assert { drop.image? }
  end

  it 'finds a drop' do
    EM.synchrony do
      VCR.use_cassette 'small' do
        drop = Pollex::Drop.find 'hhgttg'
        EM.stop

        assert { drop.is_a? Pollex::Drop }
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
          rescuing { Pollex::Drop.find('hhgttg') }.is_a? Pollex::Drop::NotFound
        end

        EM.stop
      end
    end
  end

end
