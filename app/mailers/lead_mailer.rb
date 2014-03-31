class LeadMailer < ActionMailer::Base
  default from: ENV["ADMIN_EMAIL"]

  def new(lead_id)
    @lead = Lead.find(lead_id)
    mail to: @lead.email, subject: "Thanks!"
  end
end
