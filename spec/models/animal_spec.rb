require 'rails_helper'

RSpec.describe Animal, type: :model do
  it 'must include a common name and scientific binomial' do

    weirdo1 = Animal.create common_name: 'Huge Fly', scientific_binomial: ''
    weirdo2 = Animal.create common_name: '', scientific_binomial: 'Somethingus Weirdus'

    expect(weirdo1.errors[:scientific_binomial]).to_not be_empty
    expect(weirdo2.errors[:common_name]).to_not be_empty
  end
end
