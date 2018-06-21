class Bike < ActiveRecord::Base
  belongs_to :owner, class_name: 'Biker'
end
