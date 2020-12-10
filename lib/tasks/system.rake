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
end
