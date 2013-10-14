require "spec_helper"



describe "/api/appointments", :type => :api do


  before do
    @appointment = FactoryGirl.create(:appointment)
  end

  #let(:appointment) {FactoryGirl.create(:appointment) }

  context "creating an appointment" do

    let(:url) { "/api/appointments" }

    it "sucessful JSON" do
      post "#{url}",
           appointment={
               :start_time => "2014-05-05 11:30:00",
               :end_time =>"2014-05-05 12:30:00",
               :first_name =>"John",
               :last_name => "White",
               :comments =>"some comments"
           }

      appointment = Appointment.where("start_time=?","2014-05-05 11:30:00").first

      response.status.should eql(201)
      response.body.should eql({"appointment"=>appointment}.to_json)
    end

    it "unsuccessful JSON" do
      post "#{url}",
           :appointment => {}
      response.status.should eql(422)
      errors = {"error"=>{"first_name" =>["can't be blank"],"last_name" =>["can't be blank"],"start_time" =>["can't be blank","has already been taken"],"end_time" =>["can't be blank","has already been taken"]}}.to_json
      response.body.should eql(errors)
    end
  end

  context "updating an appointment" do

    let(:url) { "/api/appointments/#{@appointment.id}" }
    it "successful JSON" do
      @appointment.first_name.should eql("Jason")
      put "#{url}",
          appointment ={
              :first_name => "John"
          }
      response.status.should eql(202)

      @appointment.reload
      @appointment.first_name.should eql("John")
      message={"appointment"=>@appointment}
      response.body.should eql(message.to_json)
    end

    it "unsuccessful JSON" do
      @appointment.first_name.should eql("Jason")
      put "#{url}",
          appointment = {
              :first_name => ""
          }
      response.status.should eql(422)

      @appointment.reload
      @appointment.first_name.should eql("Jason")
      message = { "error"=>{:first_name => ["can't be blank"]}}
      response.body.should eql(message.to_json)
    end
  end

  context "deleting an appointment" do

    let(:url) { "/api/appointments/#{@appointment.id}" }
    it "JSON" do
      delete "#{url}"
      response.status.should eql(202)
    end
  end

end