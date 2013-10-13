#import appt_data.csv into appointment table in postgresql database

namespace :db do
  namespace :import do
    desc "Import appointments from csv"
    task :appointment => :environment do
      csv_file = 'db/appt_data.csv'
      importer = Import::ImportAppointment.new(IO.read(csv_file))
      importer.import
    end
  end
end

require 'csv'

module Import
  class Importer
    attr_accessor :csv_stream

    def initialize(csv_stream)
      @csv_data = {}
      convert_csv_data(csv_stream)
    end

    def convert_csv_data(csv_stream)
      @csv_data = CSV.new csv_stream, {:headers => true, :col_sep => ','}
      @csv_data.convert do |field, info|
        next if field.blank?
        field.strip
      end
    end
  end
end

module Import
  class ImportAppointment < Importer
    def import
      Appointment.transaction do
        import_appointment_data
      end
    end

    def import_appointment_data
      @csv_data.each do |row|
        data = row.to_hash
        save_data_to_db(data)
      end
    end

    def save_data_to_db(data)
      data_hash = {
          :start_time => data['start_time'] || '',
          :end_time => data['end_time'] || '',
          :first_name => data['first_name'] || '',
          :last_name => data['last_name'] || '',
          :comments => data['comments'] || ''
      }

      appointment = Appointment.new(data_hash)
      appointment.save
    end
  end
end