class Admin::TimeCostsController < ApplicationController
  before_action :load_yard

  def show
    @time_cost = @yard.time_costs
  end

  private

  def load_yard
    @yard = Yard.find_by id: params[:id]
    return if @yard

    flash[:warning] = t "message.fail"
    redirect_to admin_locations_path
  end
end
