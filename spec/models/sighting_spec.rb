require 'rails_helper'


RSpec.describe Sighting, type: :model do
  it "sighting must include latitude, longitude, and a date" do

    sight1 = Sighting.create animal_id: '', sighting_date: '2022-02-04', location: 'akdljfgadklfjg'

    sight2 = Sighting.create animal_id: '3', sighting_date: '', location: 'akdljfgadklfjg'

    sight3 = Sighting.create animal_id: '3', sighting_date: 'asdgsadg', location: ''

    expect(sight1.errors[:animal_id]).to_not be_empty
    expect(sight2.errors[:sighting_date]).to_not be_empty
    expect(sight3.errors[:location]).to_not be_empty
  end
end
