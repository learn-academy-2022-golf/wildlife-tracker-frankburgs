class Animal < ApplicationRecord

    has_many :sightings
    
    validates :common_name, :scientific_binomial, presence: true
end
