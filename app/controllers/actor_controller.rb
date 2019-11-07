class ActorController < ApplicationController

  before_action :authenticate_user!, :except => [:get_actor]

  def get_actor
    user = User.find_by username: params[:username]
    render :json => user.actor
  end


end
