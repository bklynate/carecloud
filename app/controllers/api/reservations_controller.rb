class Api::ReservationsController < ApplicationController

  # url for list all appointments in a time range i.e. /api/reservations/201101130700/201102130700, will return all appointments if no parameters given
  def list

    start_time=convert_input(params[:start_time]) if params[:start_time]
    end_time=convert_input(params[:end_time]) if params[:end_time]
    sort_by=params[:sort_by]? params[:sort_by] : "start_time"

    if !start_time.nil? and !end_time.nil?

        if end_time>start_time
            raw_data=Appointment.where("start_time>=? AND end_time<=?",start_time,end_time)
        else
            raw_data=[]
        end

    elsif !start_time.nil?
        raw_data=Appointment.where("start_time>=?",start_time)

    else
        raw_data=Appointment.all

    end

    if !raw_data.empty?
        selected_appointments=raw_data.select{|appointment| appointment.send('is_valid_appointment') }

        # sort appointments by sort_by criteria, default by "start_time" and grouped by date for easy reference

        sorted_appointments= sort_results(selected_appointments,sort_by)
        grouped_selected_appointments=sorted_appointments.group_by{|appointment| appointment.send('appointment_date')}

        # delete unnecessary meta data and data with empty value to downsize data sent
        @selected_appointments=grouped_selected_appointments.map{|k,v| build_item(k,v)}

        result={
                "total_appointments"=>raw_data.size,
                "valid_appointments"=>sorted_appointments.size,
                "total_appointments_dates"=>@selected_appointments.size,
                "start_time"=>start_time,
                "end_time"=>end_time,"sort_by"=>"start_time",
                "appointments"=>@selected_appointments
                }.delete_if{|k,v| v.nil?}
    else

      result={"error"=>"Please check your start time and end time and try again."}

    end

    render json: result, status: :ok

  end


  private

  def sort_results(original_result,sort_by)
    original_result.sort{|item1,item2| item1.send(sort_by)<=>item2.send(sort_by)}
  end

  def appointment_duplicates(arr)

    new_arr=arr.map{|a|{"start_time"=>a.send('start_time')}}

    return new_arr.size-new_arr.uniq.size

  end

  def build_item(k,v)

    {"date"=>k,
     "number_of_overlapped_appointments"=>appointment_duplicates(v),
     "number_of_appointments"=>v.size,
     "items"=>v.map{|a|a.send('clean_appointment')}
    }.delete_if{|k,v| v==0}


  end

  def convert_input(input)
    DateTime.iso8601(input)
  end


end