class Appointment < ActiveRecord::Base
  attr_accessible :comments, :end_time, :first_name, :last_name, :start_time
end
