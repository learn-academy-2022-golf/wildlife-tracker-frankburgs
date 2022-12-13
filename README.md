# Story 1:
In order to track wildlife sightings, as a user of the API, I need to manage animals.
Branch: animal-crud-actions 🪵
Acceptance Criteria

## Create a resource for animal with the following information: common name and scientific binomial ✅

Created a rails app called animals
Created a Github remote in the foler
Pushed the rails app to main and created new branch
Posted repo link to Slack asking for branch protections

### $ bundle add rspec-rails

### $ rails generate rspec:install

### $ rails generate resource Animal common_name:string scientific_binomial:string

invoke  active_record
      create    db/migrate/20221213192334_create_animals.rb
      create    app/models/animal.rb
      invoke    rspec
      create      spec/models/animal_spec.rb
      invoke  controller
      create    app/controllers/animals_controller.rb
      invoke    erb
      create      app/views/animals
      invoke    rspec
      create      spec/requests/animals_spec.rb
      invoke    helper
      create      app/helpers/animals_helper.rb
      invoke      rspec
      create        spec/helpers/animals_helper_spec.rb
      invoke  resource_route
       route    resources :animals

This generates a model with columns and datatypes, as well as a controller, view folder, and necessary RESTful routes


## Can see the data response of all the animals 
Resource generation did not create a migration file
### $ rails rails db:create
Created database 'animals_development'
Created database 'animals_test'
### $ rails db:migrate
== 20221213192334 CreateAnimals: migrating ====================================
-- create_table(:animals)
   -> 0.0048s
== 20221213192334 CreateAnimals: migrated (0.0048s) ===========================

### $ rails console
### Created two entries

### disable authenticity token

add 
### skip_before_action :verify_authenticity_token
to 
### app/controllers/application_controller.rb
add index method to controller
def index
    animals = Animal.all
    render json: animals
end

Open Postman
### $ rails s  -> checked that server works
sending a "get" request to URL 'localhost:3000/animals' shows entries

### Might as well add the show method to controller while you're at it

def show
    animal = Animal.find(params[:id])
    render json: animal
end

Using Postman, this will return individual entries from url localhost:3000/animals/1 ... 2 ...

## Can create a new animal in the database
Add create method to controller

def create
    animal = Animal.create(animal_params)
    if animal.valid?
        render json: animal
    else
        render json: animal.errors
    end
end

private

def animal_params
        params.require(:animal).permit(:common_name, :scientific_binomial)
end

Doing a "post" request in Postman to localhost:3000/animals with the RAW JSON in the BODY of an object with key value pairs of the two params and values will create a new entry in the database

## Can update an existing animal in the database
Add to controller

def update
    animal = Animal.find(params[:id])
    animal.update(animal_params)
    if animal.valid?
      render json: animal
    else
      render json: animal.errors
    end
end

Send a PATCH request to localhost:3000/animals/3 .. 4 .. whatever
With appropriate JSON object

##  Can remove an animal entry in the database
Add to controller

def destroy
    animal = Animal.find(params[:id])
    if animal.destroy
        render json: animal
    else
        render json: animal.errors
    end
end   

The URL this maps to is .../animals/:id 

### Git hygiene and move on

# Story 2: ✅
In order to track wildlife sightings, as a user of the API, I need to manage animal sightings.
# Branch: sighting-crud-actions 🪵
# Acceptance Criteria

## Create a resource for animal sightings with the following information: latitude, longitude, date ✅ (location)
Hint: An animal has_many sightings (rails g resource Sighting animal_id:integer ...)
Hint: Date is written in Active Record as yyyy-mm-dd (“2022-07-28")

### $ rails g resource Sighting animal_id:integer sighting_date:string
### $ rails db:migrate

Add the following to app/models/animal.rb
has_many :sightings
And the following to the sighting class
belongs_to :animal

### So we totally forgot to add latitute and longitude columns
### $ rails generate migration add_columns_to_sighting

def change
    add_column :sightings, :location, :string
end

### $ rails db:migrate
== 20221213213413 AddColumnsToSighting: migrating =============================
-- add_column(:sightings, :location, :string)
   -> 0.0066s
== 20221213213413 AddColumnsToSighting: migrated (0.0066s) ====================

## Can create a new animal sighting in the database ✅
Copy and paste all the controller methods and change the keywords
That was difficult but I think it works.

## Can update an existing animal sighting in the database✅


## Can remove an animal sighting in the database✅


# Story 3: ✅
In order to see the wildlife sightings, as a user of the API, I need to run reports on animal sightings.
# Branch: animal-sightings-reports
# Acceptance Criteria

## Can see one animal with all its associated sightings ✅
Hint: Checkout this example on how to include associated records

Add to the animal controller

    render json: animals, include: [:sightings]

This works with URL localhost:3000/animals/1 ... 2 etc

## Can see all the all sightings during a given time period ✅
So I need to do another migration,
Removing the "date" column or changing the datatype from string to date

remove_column :sightings, :sighting_date
add_column :sightings, :sighting_date, :date

Hint: Date is written in Active Record as yyyy-mm-dd (“2022-07-28")
Hint: Your controller can use a range to look like this:

class SightingsController < ApplicationController

  def index

    sightings = Sighting.where(date: params[:start_date]..params[:end_date])
    render json: sightings

  end

end

Hint: Be sure to add the start_date and end_date to what is permitted in your strong parameters method

    def sighting_params
            params.require(:sighting).permit(:start_date, :end_date, :animal_id, :sighting_date)
    end

Hint: Utilize the params section in Postman to ease the developer experience

Hint: Routes with params


Stretch Challenges
# Story 4: 
In order to see the wildlife sightings contain valid data, as a user of the API, I need to include proper specs.
Branch: animal-sightings-specs
Acceptance Criteria

Validations will require specs in spec/models and the controller methods will require specs in spec/requests.

## Can see validation errors if an animal doesn't include a common name and scientific binomial

## Can see validation errors if a sighting doesn't include latitude, longitude, or a date

## Can see a validation error if an animal's common name exactly matches the scientific binomial


## Can see a validation error if the animal's common name and scientific binomial are not unique


## Can see a status code of 422 when a post request can not be completed because of validation errors
Hint: Handling Errors in an API Application the Rails Way

# Story 5: In order to increase efficiency, as a user of the API, I need to add an animal and a sighting at the same time.
Branch: submit-animal-with-sightings
Acceptance Criteria

## Can create new animal along with sighting data in a single API request
Hint: Look into accepts_nested_attributes_for