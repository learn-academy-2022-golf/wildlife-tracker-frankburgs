class AddDateToSightings < ActiveRecord::Migration[7.0]
  def change
    remove_column :sightings, :sighting_date
    add_column :sightings, :sighting_date, :date
  end
end
