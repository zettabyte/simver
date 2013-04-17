# encoding: utf-8
notification :off

guard 'bundler' do
  watch('Gemfile')
  watch('simver.gemspec')
end

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})    { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end

guard :cane do
  watch(/.*\.rb/)
end
