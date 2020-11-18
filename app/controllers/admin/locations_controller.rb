class Admin::LocationsController < ApplicationController
  def index
    @locations = Location.order_by_name
                         .paginate(page: params[:page],
                            per_page: Settings.paginate.manage)
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update(location_params)
      redirect_to admin_locations_path
      flash[:success] = t "message.update_location"
    else
      render :edit
    end
  end

  private

  def location_params
    params.require(:location)
          .permit(:name, :phone, :address, :distric, :description)
  end
end
