web:     bundle exec puma -e ${RAILS_ENV} -C config/puma.rb
worker:  bundle exec sidekiq -e ${RAILS_ENV} -C config/sidekiq.yml
release: bundle exec rails db:migrate db:seed
