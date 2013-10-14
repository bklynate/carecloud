class Appointment < ActiveRecord::Base

  require 'date'
  attr_accessible :comments, :end_time, :first_name, :last_name, :start_time


  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :start_time, :presence => true,:uniqueness=>true
  validates :end_time, :presence => true, :uniqueness=>true


  validates_each :start_time, :end_time do |model, attr, value|
    model.errors.add(attr, 'appointment time must start in future') if value<Time.now
  end

  def appointment_date
       Date.parse(start_time.to_s)
  end

  def clean_appointment
     {
         "start_time" =>start_time,
         "end_time" =>end_time,
         "first_name" =>first_name,
         "last_name" =>last_name,
         "comments" =>comments
     }.delete_if{|k,v| v.blank?}
  end

  def is_valid_appointment
    !start_time.blank? and !end_time.blank? and !first_name.blank? and !last_name.blank?
  end

end

