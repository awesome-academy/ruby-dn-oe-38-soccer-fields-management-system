class Admin::BookingsController < AdminController
  before_action :load_booking, :check_status_booking, only: :update
  before_action :check_search_location, only: :index

  def index
    @b = Booking.includes(:time_cost).ransack(params[:q])
    @bookings = @b.result(distinct: true).paginate page: params[:page],
      per_page: Settings.admin_booking.per_page
  end

  def update
    respond_to do |format|
      if @booking.update_status params[:stt]
        send_mail_when_booking params[:stt].to_s
        format.json{render json: @booking, status: :created}
      else
        format.json{render status: :unprocessable_entity}
      end
    end
  end

  private

  def load_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    flash[:warning] = t "message.update_booking.not_exist_id"
    redirect_to admin_bookings_path
  end

  def check_status_booking
    return if @booking.pending? || @booking.accept?

    flash[:warning] = t "message.update_booking.check_status"
    redirect_to admin_bookings_path
  end

  def send_mail_when_booking status
    @user = @booking.user
    return unless @user

    if status == Settings.admin_booking.enum_status.accept
      @user.send_notify_accept_to_user_email(@booking)
    elsif status == Settings.admin_booking.enum_status.rejected
      @user.send_notify_reject_to_user_email(@booking)
    else
      @user.send_notify_cancel_by_admin_email(@booking)
    end
  end
end
