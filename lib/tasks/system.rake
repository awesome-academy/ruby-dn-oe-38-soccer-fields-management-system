namespace :system do
  desc "Run framgia-ci run--local"
  task framgia_ci: :environment do
    sh %(framgia-ci run --local)
  end

  desc "Check rubocop and rspec"
  task rubocop_rspec: :environment do
    sh %(rubocop)
    sh %(bundle exec rspec)
  end

  desc "Running sidekiq server"
  task run_sidekig: :environment do
    sh %(bundle exec sidekiq --environment development -C config/sidekiq.yml)
  end

  desc "Running redis server"
  task run_redis: :environment do
    sh %(redis-server)
  end
end
