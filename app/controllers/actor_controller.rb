class ActorController < ApplicationController

  skip_before_action :authenticate_user!, :verify_authenticity_token
  before_action :load_user

  def load_user
    @user = User.find_by username: params[:username]
    unless @user.present?
      render json: { 'error': "User #{params[:username]} found." }, status: 404
    end
  end

  def show_actor_for_user
    render :json => @user.actor
  end

  def inbox_for_actor
    local_actor = JSON.parse(@user.actor)
    remote_action = JSON.parse(request.body.read)

    case remote_action["type"]
    when "Follow"
      AcceptFollowJob.perform_now(@user, local_actor, remote_action)
    else
      render json: {'error': "Action not supported."}, status: 501
    end
  end
end
