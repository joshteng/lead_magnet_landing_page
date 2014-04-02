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

  def add_to_mailchimp
    # return nil unless Rails.env.production? #skip this if test & development
    return nil if Rails.env.development? #skip this if development
    LeadJob.new.async.perform(:new_lead, { lead_id: self.id })
  end

  def send_welcome_email
    EmailJob.new.async.perform(:new_lead, { lead_id: self.id })
  end
end
