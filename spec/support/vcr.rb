require 'curb'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join 'spec', 'vcr_tapes'
  c.hook_into :fakeweb
  c.ignore_localhost = true
end
