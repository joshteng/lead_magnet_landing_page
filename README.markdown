[![Code Climate](https://codeclimate.com/github/joshteng/lead_magnet_landing_page.png)](https://codeclimate.com/github/joshteng/lead_magnet_landing_page)
[![Code Climate](https://codeclimate.com/github/joshteng/lead_magnet_landing_page/coverage.png)](https://codeclimate.com/github/joshteng/lead_magnet_landing_page)
[![Build Status](https://travis-ci.org/joshteng/lead_magnet_landing_page.svg?branch=master)](https://travis-ci.org/joshteng/lead_magnet_landing_page)
[![Dependency Status](https://gemnasium.com/joshteng/lead_magnet_landing_page.svg)](https://gemnasium.com/joshteng/lead_magnet_landing_page)

# Lead Magnet Landing Page

This app allows you to create landing pages to capture lead (collect name and email) in exchange of some bribery (ebook, video, etc+)
Emails will be added to your chosen mailchimp list.

## To Do
1. Use VCR for mailchimp specs
2. Fix user model and Clearance
3. Admin notification on new lead
4. Admin dashboard to view leads


## To start the application in development
1. `bundle install`
2. `bundle exec rake db:migrate && bundle exec annotate && bundle exec rake db:test:clone`
3. Define environment variables in `application.yml` in `config` *(this app uses figaro gem to manage environment variables)*
4. `bundle exec rails s`

Environment Variables to define
* ADMIN_EMAIL *email address you want your transactional emails to be sent from*
* SECRET_TOKEN *a random 128 character long string for your app*
* MAILCHIMP_KEY *your mailchimp api key*
* MAILCHIMP_LIST_ID *the mailchimp list you want leads to subscribed to*

#### Sample application.yml file
```
ADMIN_EMAIL: "josh@example.com"
SECRET_TOKEN: "ae6f4909a3d4725ab716fe1b56jab895f43bd47558f6d0baa6db52eedc266b01555057c740kb76cd03cec46a4y70ffdcaa355dd9c1fbe993e2c2114f678ecc20"
```

## Test!
Just run `bundle exec rspec spec`  
Run with zeus

1. `zeus start`
2. `zeus rspec spec`

Time the difference!  
`zeus rspec spec` vs `bundle exec rspec spec`

#### Automate testing during development
1. Create a Guardfile *see below*
2. Start zeus: `zeus start`
2. Just run `bundle exec guard`

I've included growl and guard for auto testing. To use growl, please make sure your Mac has growl installed.

You should also set up `Guardfile` based on your system set up

This is a sample of my Guardfile that uses growl as notification. This Guardfile is modified to suit the test suit I use

```
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :growl

guard :rspec do
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"] }
end
```

## Developed with
1. Ruby 2.1.0
2. Rails 4.0.4
3. Postgresql

## Misc
1. When running test suite, new subscribers will be added to mailchimp, to clean mailchimp list occassionally run `RAILS_ENV=test be rake mailchimp_list:wipe`
2. Consider stubbing out invocation of Lead#add_to_mailchimp method except for unit test (currently using VCR to speed up test without making actual API calls). The current 4 specs that uses that method: (1) Lead sign up, (2) LeadsController POST #create with valid attributes saves the new lead in the database, (3) LeadsController POST #create with valid attributes redirects to lead#show, (4) LeadsController POST #create with valid attributes emails the lead

