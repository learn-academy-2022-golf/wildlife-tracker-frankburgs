class Sighting < ApplicationRecord
    belongs_to :animal

    validates :animal_id, :location, :sighting_date, presence: true
end
