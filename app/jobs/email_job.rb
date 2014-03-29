class EmailJob
  include SuckerPunch::Job

  def perform(event, options = {})
    case event
    when :new_lead
      LeadMailer.new(options[:lead_id]).deliver
    end
  end
end