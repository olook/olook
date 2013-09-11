require 'curb'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join 'spec', 'vcr_tapes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
