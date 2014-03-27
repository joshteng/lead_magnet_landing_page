# Lead Magnet Landing Page

This app allows you to create landing pages to capture lead (collect name and email) in exchange of some bribery (ebook, video, etc+)
Emails will be added to your chosen mailchimp list.

## To start the application in development
1. `bundle install`
2. `rake db:migrate && annotate && rake db:test:clone`
3. Define environments in `application.yml` in `config` *(this app uses figaro to manage environment variables)*
4. `rails s`

Environment Variables to define
* ADMIN_EMAIL
* SECRET_TOKEN

#### Sample application.yml file
```
ADMIN_EMAIL: "josh@example.com"
SECRET_TOKEN: "ae6f4909a3d4725ab716fe1b56jab895f43bd47558f6d0baa6db52eedc266b01555057c740kb76cd03cec46a4y70ffdcaa355dd9c1fbe993e2c2114f678ecc20"
```

## Test!
Just run `rspec spec`

#### Automate testing during development
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

## Tech stack
1. Ruby 2.1.0
2. Rails 4.0.4
3. Postgresql