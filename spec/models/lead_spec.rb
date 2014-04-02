# == Schema Information
#
# Table name: leads
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Lead do

  describe "basic validations" do
    let(:lead) { build(:lead) }
    subject { lead }

    it "is valid with a first name, last name and email address" do
      expect(lead).to be_valid
    end

    it { should be_valid }

    it "is invalid without email address" do
      blank_emails = [nil, ""]
      blank_emails.each do |e|
        lead.email = e
        expect(lead).to have(2).errors_on(:email)
      end
    end

    it "is invalid with wrong email syntax" do
      invalid_emails = ["@example.com", "john.com", "john@example", "john"]
      invalid_emails.each do |e|
        lead.email = e
        expect(lead).to have(1).errors_on(:email)
      end
    end

    it "is invalid when a lead with similar email already exists" do
      Lead.create(email: lead.email)
      expect(lead).to have(1).error_on(:email)
    end
  end

  describe "#send_welcome_email" do
    let(:lead) { create(:lead) }
    it "delivers an email" do
      expect{
        lead.send_welcome_email
      }.to change{ LeadMailer.deliveries.size }.by(1)
    end
  end

  describe "#add_lead_to_mailchimp" do
    let(:lead) { create(:lead, email: 'joshteng@me.com') }
    it "adds lead to mailchimp" do

      # ##Use VCR to record this
      # lead.add_lead_to_mailchimp
      # #retrieving mailchimp list
      # puts Mailchimp::Lists.new(MAILCHIMP).members(ENV["MAILCHIMP_LIST_ID"])
      # #this lead should be subscribed to the list (mailchimp doesnt subscribe until user clicks on confirm.. how can I hack this? I dont seem to be able to disable double opt-in either)

      #remove lead from mailchimp list (just for the specs.. dont want a growing list) (create a macro so that it would clean mailchimp list everytime I create a new lead)

      pending "should I mock this or test that it added for real?"
    end
  end
end
