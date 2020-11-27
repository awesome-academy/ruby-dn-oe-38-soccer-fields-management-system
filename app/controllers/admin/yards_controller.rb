class Admin::YardsController < ApplicationController
  before_action :load_location, only: :show
  def show
    @yard = @location.yards
  end

  private

  def load_location
    @location = Location.find_by id: params[:id]
    return if @location

    flash[:warning] = t "message.fail"
    redirect_to admin_yard_path @location
  end
end
