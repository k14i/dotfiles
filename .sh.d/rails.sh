_check_cmd bundle
if test $? -eq 0; then
  alias bundle-exec-rails-s='bundle exec rails s'
  alias bundle-exec-rails-c='bundle exec rails c'
  alias bundle-exec-rake='bundle exec rake'
  alias bundle-exec-rspec='bundle exec rspec'
  alias bundle-exec-rspec-fail-fast='bundle exec rspec --fail-fast'
  alias bundle-exec-rspec-order-default='bundle exec rspec --order default'
  alias bundle-exec-rspec-order-default-fail-fast='bundle exec rspec --order default --fail-fast'
  alias bundle-exec-rspec-f-d='bundle exec rspec --format d'
  alias bundle-exec-rspec-f-d-fail-fast='bundle exec rspec --format d --fail-fast'
  alias bundle-exec-rspec-f-d-order-default='bundle exec rspec -f d --order default'
  alias bundle-exec-rspec-f-d-order-default-fail-fast='bundle exec rspec -f d --order default --fail-fast'
  alias bundle-exec-spork='bundle exec spork'
  alias rails-env-development-bundle-exec-rails-s='RAILS_ENV=development bundle exec rails s'
  alias rails-env-development-bundle-exec-rails-c='RAILS_ENV=development bundle exec rails c'
  alias rails-env-development-bundle-exec-rspec='RAILS_ENV=development bundle exec rspec'
  alias rails-env-development-bundle-exec-rspec-order-default='RAILS_ENV=development bundle exec rspec --order default'
  alias rails-env-development-bundle-exec-rspec-f-d='RAILS_ENV=development bundle exec rspec --format d'
  alias rails-env-development-bundle-exec-rspec-f-d-order-default='RAILS_ENV=development bundle exec rspec -f d --order default'
  alias rails-env-development-bundle-exec-spork='RAILS_ENV=development bundle exec spork'
fi

