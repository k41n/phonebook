class PhoneNumber < ActiveRecord::Base
  attr_accessible :number
  belongs_to :person

  validates_presence_of :number
  validates_uniqueness_of :number, scope: :person_id
  validates_presence_of :person

end
