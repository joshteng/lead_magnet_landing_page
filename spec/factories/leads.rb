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

# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

FactoryGirl.define do
  factory :lead do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email { Faker::Internet.email }

    factory :invalid_lead do
      email "invalid@invalid"
    end
  end
end
