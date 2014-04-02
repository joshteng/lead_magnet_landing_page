# require 'rubygems'
# require 'test/unit'
# require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock # or :fakeweb
  c.filter_sensitive_data('APIKEY') { ENV["MAILCHIMP_KEY"] }
  c.filter_sensitive_data('LISTID') { ENV["MAILCHIMP_LIST_ID"] }
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end