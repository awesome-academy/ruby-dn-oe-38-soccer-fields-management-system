class StaticPagesController < ApplicationController
  before_action :load_location, only: :show
  def index
    @locations = Location.order_by_name
                         .paginate(page: params[:page],
                            per_page: Settings.paginate.home)
  end

  def show; end

  private

  def load_location
    @location = Location.find_by(id: params[:id])
    return if @location

    flash[:warning] = t "message.update_booking.not_exist_id"
    redirect_to root_path
  end
end
