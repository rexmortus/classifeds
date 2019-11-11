class ActorController < ApplicationController

  before_action :load_user
  skip_before_action :authenticate_user!, :verify_authenticity_token

  def load_user
    @user = User.find_by username: params[:username]
    unless @user.present?
      render json: { 'error': "User #{params[:username]} found." }, status: 404
    end
  end

  def actor_for_user
    render :json => @user.actor
  end

  def followers_for_user
    actor = JSON.parse(@user.actor)
    followers = @user.followers.map do |follower| { follower.actor }

    render :json => {
      "@context": ["https://www.w3.org/ns/activitystreams"],
      "type": "Collection",
      "totalItems": @user.followers.length,
      "id": "#{actor['id']}/followers",
      "items": followers,
    }
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
