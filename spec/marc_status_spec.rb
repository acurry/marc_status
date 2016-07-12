require 'spec_helper'

describe MarcStatus do
  it 'has a version number' do
    expect(MarcStatus::VERSION).to be
  end

  [
    'get_camden_north_status',
    'get_camden_south_status',
    'get_brunswick_east_status',
    'get_brunswick_west_status',
    'get_penn_north_status',
    'get_penn_south_status'
    ].each do |method|
      it "responds to #{method}" do
        expect(MarcStatus.respond_to?(method)).to be_truthy
      end
    end
end
