namespace :mailchimp_list do
  desc "Deletes all subscribers from mailchimp list (run it only for test)(never run for production)"
  task wipe: :environment do

    if ENV["RAILS_ENV"].blank?
      puts "skipping... RAILS_ENV not defined. Try running `RAILS_ENV=test be rake mailchimp_list:wipe`"
    elsif ENV["RAILS_ENV"] == "test"
      puts "Deleting mailchimp subscribers"
      subscribers = Mailchimp::Lists.new(MAILCHIMP).members(ENV["MAILCHIMP_LIST_ID"])["data"] #retrieving mailchimp list
      subscribers_email = subscribers.map { |subscriber| { email: subscriber["email"] } }
      puts subscribers_email
      Mailchimp::Lists.new(MAILCHIMP).batch_unsubscribe(ENV["MAILCHIMP_LIST_ID"], subscribers_email, true, false, false)
    else
      puts "skipping.. this task is only to be ran in test environment"
    end
  end
end
