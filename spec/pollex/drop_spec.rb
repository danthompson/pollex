require 'spec_helper'
require 'support/vcr'

require 'pollex'

describe Pollex::Drop do

  it 'raises a DropNotFound error' do
    VCR.use_cassette 'nonexistent', :record => :none do
      lambda { Pollex::Drop.find 'hhgttg' }.must_raise Pollex::Drop::NotFound
    end
  end

end
