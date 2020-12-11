class StaticPagesController < ApplicationController
  before_action :load_location, only: :show
  before_action :check_search_location, only: :index
  def index
    @locations = @q.result(distinct: true).paginate(page: params[:page],
                           per_page: Settings.paginate.home)
  end

  def show
    yards =  @location.yards.pluck(:id)
    @times = TimeCost.all_time(yards).pluck(:time)
    @comments = @location.comments.newest
    @comment = Comment.new
  end

  private

  def load_location
    @location = Location.find_by(id: params[:id])
    return if @location

    flash[:warning] = t "message.update_booking.not_exist_id"
    redirect_to root_path
  end
end
