class LeadJob
  include SuckerPunch::Job

  def perform(event, options={})
    case event
    when :new_lead
      lead = Lead.find(options[:lead_id])
      Mailchimp::Lists.new(MAILCHIMP).subscribe(ENV["MAILCHIMP_LIST_ID"], {email: lead.email}, { fname: lead.first_name, lname: lead.last_name})
    end
  end

end