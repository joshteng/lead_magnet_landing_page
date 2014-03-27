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
    before :each do
      @lead = build(:lead)
    end

    it "is valid with a first name, last name and email address" do
      expect(@lead).to be_valid
    end

    it "is invalid without email address" do
      blank_emails = [nil, ""]
      blank_emails.each do |e|
        @lead.email = e
        expect(@lead).to have(2).errors_on(:email)
      end
    end

    it "is invalid with wrong email syntax" do
      invalid_emails = ["@example.com", "john.com", "john@example", "john"]
      invalid_emails.each do |e|
        @lead.email = e
        expect(@lead).to have(1).errors_on(:email)
      end
    end

    it "is invalid when a lead with similar email already exists" do
      Lead.create(email: @lead.email)
      expect(@lead).to have(1).error_on(:email)
    end
  end
end
