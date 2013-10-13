class Appointment < ActiveRecord::Base

  include ActiveModel::Validations
  require 'date'
  class AppointmentTimeValidator< ActiveModel::EachValidator

    # This customized validator checks if the start_time of an appointment is in future and end_time happens after start_time

    def validate_each(appointment, attribute, value)
      if (!value.nil?)
        if !appointment.start_time.nil?
          appointment.errors[attribute] << I18n.t('model.errors.custom.start_time') if appointment.end_time > appointment.start_time and appointment.start_time>Time.now
        end
      end
    end

  end

  attr_accessible :comments, :end_time, :first_name, :last_name, :start_time

  #transformer_for :end_time, :to_s
  #transformer_for :start_time, :to_s

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :start_time, :presence => true,:uniqueness=>true
  validates :end_time, :presence => true, :uniqueness=>true
  validates :start_time, :end_time, :appointment_time=>true


  def appointment_date
       Date.parse(start_time.to_s)
  end

  def clean_appointment
     {
         "start_time"=>start_time,
         "end_time"=>end_time,
         "first_name"=>first_name,
         "last_name"=>last_name,
         "comments"=>comments
     }.delete_if{|k,v| v.blank?}
  end

  def is_valid_appointment
    !start_time.blank? and !end_time.blank? and !first_name.blank? and !last_name.blank?
  end


end

