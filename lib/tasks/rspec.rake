namespace :rspec do
  desc "Run all rspec and open coverage."
  task all: :environment do
    sh %(bundle exec rspec)
    sh %(xdg-open coverage/index.html)
  end

  desc "Run rspec of model"
  task models: :environment do
    sh %(bundle exec rspec spec/models)
  end

  desc "Run rspec of request"
  task request: :environment do
    sh %(bundle exec rspec spec/request)
  end
end
