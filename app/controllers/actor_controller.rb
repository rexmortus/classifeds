class ActorController < ApplicationController

  skip_before_action :authenticate_user!, :verify_authenticity_token

  # show an activitypub actor for a given username
  def show_actor_for_user
    user = User.find_by username: params[:username]
    render :json => user.actor
  end

  # the inbox for a individual activitypub actor
  def inbox_for_actor
    body = JSON.parse(request.body.read)
    logger.info body
  end
end
