class API::AppointmentsController < ApplicationController

  # post /api/appointments
  def create
   appointment={
        :start_time =>params[:start_time],
        :end_time =>params[:end_time],
        :first_name =>params[:first_name],
        :last_name =>params[:last_name],
        :comments =>params[:comments]
      }

    @appointment = Appointment.new(appointment)

    if @appointment.save

      result = {"appointment"=>@appointment}
      render json: result, status: :created
    else
      result = {"error"=>@appointment.errors}
      render json: result, status: :unprocessable_entity
    end


  end

  # get /api/appointments/201101130700/201102130700, will return all appointments if no parameters given
  def list

    start_time = convert_input(params[:start_time]) if params[:start_time]
    end_time = convert_input(params[:end_time]) if params[:end_time]
    sort_by = params[:sort_by]? params[:sort_by] : "start_time"

    if !start_time.nil? and !end_time.nil?

        if end_time > start_time
            raw_data = Appointment.where("start_time >=? AND end_time <=?",start_time,end_time)
        else
            raw_data = []
        end

    elsif !start_time.nil?
        raw_data = Appointment.where("start_time >=?",start_time)

    else
        raw_data = Appointment.all

    end

    if !raw_data.empty?
        selected_appointments = raw_data.select{|appointment| appointment.send('is_valid_appointment') }

        # sort appointments by sort_by criteria, default by "start_time" and grouped by date for easy reference
        sorted_appointments = sort_results(selected_appointments,sort_by)

        start_time = sorted_appointments.first.start_time
        end_time = sorted_appointments.last.end_time

        grouped_selected_appointments=sorted_appointments.group_by{|appointment| appointment.send('appointment_date')}

        # delete unnecessary meta data and data with empty value to downsize data sent
        @selected_appointments = grouped_selected_appointments.map{|k,v| build_item(k,v)}

        result = {
                "total_appointments" =>raw_data.size,
                "valid_appointments" =>sorted_appointments.size,
                "total_appointments_dates" =>@selected_appointments.size,
                "start_time" =>start_time,
                "end_time" =>end_time,"sort_by"=>"start_time",
                "appointments" =>@selected_appointments
                }.delete_if{|k,v| v.nil?}

        render json: result, status: :ok
    else

      result = {"error"=>"start_time and end_time are invalid."}

      render json: result, status: :bad_request

    end



  end

  # put /api/appointments/:id
  def update

    appointment = {
        :start_time =>params[:start_time],
        :end_time =>params[:end_time],
        :first_name =>params[:first_name],
        :last_name =>params[:last_name],
        :comments =>params[:comments]
    }.delete_if{|k,v| v.nil?}

    @appointment = Appointment.find(params[:id])

      if @appointment.update_attributes(appointment)
        result ={"appointment" =>@appointment}
        render json: result, status: :accepted
      else
        result = {"error" => @appointment.errors}
        render json: result, status: :unprocessable_entity
      end

  end

  #delete /api/appointments/:id
  def destroy
    appointment_id = params[:id]? params[:id].to_i: nil
    if !appointment_id.nil?

        @appointment = Appointment.find(appointment_id)

        if !@appointment.nil?
            @appointment.destroy

            result={"message" => "The appointment of #{@appointment.first_name} #{@appointment.last_name} at #{@appointment.start_time} has been successfully deleted."}
        end

        render json:result, status: :accepted
    else
        result={'error' => "No appointment has been specified"}

        render json:result, status: :bad_request
    end



  rescue ActiveRecord::RecordNotFound
    error_message = "This appointment you are trying to delete doesn't exist"
    result={"error"=>error_message}
    render json:result, status: :unprocessable_entity

  end


  private

  def sort_results(original_result,sort_by)
    original_result.sort{|item1,item2| item1.send(sort_by) <=> item2.send(sort_by)}
  end

  def appointment_duplicates(arr)

    new_arr = arr.map{|a|{"start_time" =>a.send('start_time')}}

    return new_arr.size-new_arr.uniq.size

  end

  def build_item(k,v)

    {"date" =>k,
     "number_of_overlapped_appointments" =>appointment_duplicates(v),
     "number_of_appointments" =>v.size,
     "items" =>v.map{|a|a.send('clean_appointment')}
    }.delete_if{|k,v| v == 0}


  end

  def convert_input(input)
    DateTime.iso8601(input)
  end


end