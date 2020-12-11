class User::BookingsController < UserController
  before_action :load_booking, :check_param_status,
                :check_current_user, :check_status_booking,
                only: :update
  before_action :check_date_time, :check_booking_exist, only: :create
  before_action :check_search_location, only: :index

  def seach_yard_for_booking
    yard_arr = Yard.all_yard_by_type(params[:location_id],
                                     params[:type_yard]).pluck(:id)
    @yards = TimeCost.time_yard yard_arr, params[:hours]
    @booked = Booking.find_date_booking(@yards.pluck(:id),
                                        params[:date]).pluck(:time_cost_id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @booking = current_user.bookings.build @booking_param
    respond_to do |format|
      handle_message @booking.save, @data
      format.json{render json: @data.to_json, status: :created}
    end
  end

  def index
    @booking_user = current_user.bookings.ransack(params[:q])
    @bookings = @booking_user.result.status_asc.paginate page: params[:page],
      per_page: Settings.admin_booking.per_page
  end

  def update
    respond_to do |format|
      if @booking.update_status params[:stt]
        send_mail_when_update
        format.json{render json: @booking, status: :created}
      else
        format.html{render js: "window.location='#{user_bookings_path}'"}
      end
    end
  end

  private

  def handle_message condition, data
    if condition
      data[:success] = true
      data[:title] = t "message.booking.booking_succ"
      data[:content] = t "message.booking.booking_succ_mess"
      send_mail_when_booking
    else
      data[:title] = t "message.booking.booking_fail"
      data[:content] = t "message.booking.booking_fail_mess"
    end
  end

  def send_mail_when_booking
    @user = User.admin[0]
    @user&.send_notify_booking_to_user_email(@booking) if @user
  end

  def send_mail_when_update
    @user = User.admin[0]
    @user&.send_notify_cancel_by_user_email(@booking) if @user
  end

  def load_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    handle_redirect_and_message t("message.update_booking.not_exist_id")
  end

  def check_current_user
    return if current_user? @booking.user

    handle_redirect_and_message t("message.update_booking.check_current_user")
  end

  def check_status_booking
    return if @booking.pending?

    handle_redirect_and_message t("message.update_booking.check_status")
  end

  def check_date_time
    time_booking = params[:time].to_s.split("-").map(&:to_i)[0]
    date_booking = params[:date].to_date
    @data = Hash.new
    unless Time.zone.today < date_booking || Time.zone.today == date_booking &&
                                             Time.zone.now.hour < time_booking
      handle_send_data_check_date_time @data
    end
  end

  def handle_send_data_check_date_time data
    data[:title] = t "message.booking.booking_fail"
    data[:content] = t "message.booking.booking_logic"
    respond_to do |format|
      format.json{render json: data.to_json, status: :created}
    end
  end

  def check_param_status
    return if params[:stt].to_s == Settings.admin_booking.enum_status.cancel

    handle_redirect_and_message t("message.update_booking.check_status_edit")
  end

  def handle_redirect_and_message message
    flash[:warning] = message
    redirect_to user_bookings_path
  end

  def check_booking_exist
    @booking_param = Hash.new
    @booking_param[:time_cost_id] = params[:id_timecost]
    @booking_param[:booking_date] = params[:date]
    booking = current_user.bookings.find_by @booking_param
    return unless booking

    return unless booking&.pending? || booking&.accept?

    handle_redirect_by_ajax @data
  end

  def handle_redirect_by_ajax data
    data[:title] = t "message.booking.booking_fail"
    data[:content] = t "message.booking.booking_fail_mess"
    respond_to do |format|
      format.json{render json: data.to_json, status: :created}
    end
  end
end
