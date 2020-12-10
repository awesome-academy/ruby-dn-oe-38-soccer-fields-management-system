namespace :db do
  desc "Accept booking yard from admin "
  task accept_booking: :environment do
    Booking.where(status: "pending").each do |t|
      t.update_attribute :status, "accept"
      t.user.send_notify_accept_to_user_email(t)
    end
    puts "Update sucess !"
  end

  desc "Remake database"
  task remake_db: :environment do
    %w(db:reset db:migrate db:seed).each do |task|
      Rake::Task[task].invoke
    end
  end
end
