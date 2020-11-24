class Admin::YardsController < ApplicationController
  before_action :load_location, only: :show
  before_action :load_yard, only: %i(edit update)
  def show
    @yard = @location.yards
  end

  def edit; end

  def update
    if @yard.update yard_params
      flash[:success] = t "message.update_location"
      redirect_to admin_yard_path @yard.location_id
    else
      flash.now[:warning] = t "message.update_fail"
      render admin_yard_path @yard.location_id
    end
  end

  private

  def yard_params
    params.require(:yard).permit(:code, :type_yard)
  end

  def load_location
    @location = Location.find_by id: params[:id]
    return if @location

    flash[:warning] = t "message.fail"
    redirect_to admin_yard_path
  end

  def load_yard
    @yard = Yard.find_by id: params[:id]
    return if @yard

    flash[:warning] = t "message.fail"
    redirect_to edit_admin_yard_path
  end
end
