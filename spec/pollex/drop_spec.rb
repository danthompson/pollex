require 'spec_helper'
require 'support/vcr'

require 'pollex'

describe Pollex::Drop do

  it 'finds a drop' do
    VCR.use_cassette 'small', :record => :none do
      drop = Pollex::Drop.find 'hhgttg'

      assert drop.is_a?(Pollex::Drop)
    end
  end

  it 'raises a DropNotFound error' do
    VCR.use_cassette 'nonexistent', :record => :none do
      lambda { Pollex::Drop.find 'hhgttg' }.must_raise Pollex::Drop::NotFound
    end
  end

  it 'is not an image' do
    drop = Pollex::Drop.new :item_type => 'text'

    refute drop.image?
  end

  it 'is an image' do
    drop = Pollex::Drop.new :item_type => 'image'

    assert drop.image?
  end

end
