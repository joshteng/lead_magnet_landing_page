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

class Lead < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  def add_lead_to_mailchimp
    return nil unless Rails.env.production?
    m = Mailchimp::API.new(ENV["MAILCHIMP_KEY"])
    Mailchimp::Lists.new(m).subscribe(ENV["MAILCHIMP_LIST_ID"], {email: self.email}, { fname: self.first_name, lname: self.last_name})
  end
end
