class LeadJob
  include SuckerPunch::Job

  def perform(event, options={})
    case event
    when :new_lead
      Lead.find(options[:lead_id]).add_lead_to_mailchimp
    end
  end

end