require 'spec_helper'

feature 'Lead' do
  scenario "sign up" do
    lead = attributes_for(:lead)

    expect {
      visit root_path
      fill_in 'First name', with: lead[:first_name]
      fill_in 'Last name', with: lead[:last_name]
      fill_in 'Email', with: lead[:email]
      click_button 'Create Lead'
    }.to change(Lead, :count).by(1)

    expect(current_path).to eq thank_you_path

    expect(page).to have_title 'Thanks'

    expect(page).to have_content 'Your unique download link has been emailed to you!'

    expect(page).to have_content "#{lead[:first_name]}"

    pending "lead receives an email and mailchimp gets a new subscirber"
  end
end