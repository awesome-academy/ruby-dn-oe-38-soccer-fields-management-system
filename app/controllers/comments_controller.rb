class CommentsController < ApplicationController
  authorize_resource
  before_action :find_location, only: :create

  def create
    @comment = current_user.comments.build comment_params
    @comment.location_id = @location.id
    if @comment.save
      flash[:success] = t "message.comment"
      redirect_to static_page_path @location
    else
      value_return
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_location
    @location = Location.find_by id: params[:comment][:location_id]
    return if @location

    value_return
  end

  def value_return
    flash[:warning] = t "message.fail"
    redirect_to static_page_path params[:location_id]
  end
end
