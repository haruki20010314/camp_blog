class UsersController < ApplicationController
  def new
  #   super
  end

  # POST /resource
  def create
  #   super
    render plain: params[:user].inspect
  end


end
