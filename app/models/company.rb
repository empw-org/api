class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial

  field :name
  field :location, type: Mongoid::Geospatial::Point, sphere: true
  # sphere: true sets the db index for this field

  validates_presence_of :location, :name
  validates :location, location: true

  has_many :water_orders
end
