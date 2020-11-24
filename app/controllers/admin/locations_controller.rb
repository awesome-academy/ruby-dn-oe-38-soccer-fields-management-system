class Admin::LocationsController < ApplicationController
  before_action :load_location, only: [:update, :edit]

  def index
    @locations = Location.order_by_name
                         .paginate(page: params[:page],
                            per_page: Settings.paginate.manage)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new location_params
    if @location.save
      flash[:success] = t "message.add_location"
      redirect_to admin_locations_path
    else
      flash.now[:warning] = t "message.fail"
      render :new
    end
  end

  def edit; end

  def update
    if @location.update location_params
      flash[:success] = t "message.update_location"
      redirect_to admin_locations_path
    else
      flash.now[:warning] = t "message.update_fail"
      render :edit
    end
  end

  private

  def location_params
    params.require(:location)
          .permit(:name, :phone, :address, :district, :description)
  end

  def load_location
    @location = Location.find_by id: params[:id]
    return if @location

    flash[:warning] = t "message.fail"
    redirect_to admin_locations_path
  end
end
