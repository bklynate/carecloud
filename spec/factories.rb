FactoryGirl.define do

  factory :appointment do
    start_time "2014-03-05 09:30:00"
    end_time  "2014-03-05 10:30:00"
    first_name  "Jason"
    last_name "Jiang"
    comments  "no comments"
  end

end


Dir[Rails.root + "factories/*.rb"].each do |file|
  require file
end