# encoding: utf-8
source 'https://rubygems.org'

# Gem's dependencies in simver.gemspec
gemspec

# More development-only (and actually optional) gems: these are for the
# 'listen' gem used by guard. Each is actually platform-specific for
# getting notifications from that system's filesystem. However, each can
# be silently installed on any platform. See the 'guard' gem's README
# for more explanation.
group :development do
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

