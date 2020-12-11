# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
set :environment, "development"
set :output, "log/cron_error.log"
# set :path, "#{path}/to/app"
#
every 1.minute do
  command "echo 'Update sucess!'"
  rake "db:accept_booking"
end
