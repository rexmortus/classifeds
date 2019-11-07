class ActorController < ApplicationController

  before_action :authenticate_user!, :except => [
    :show_actor_for_user,
    :inbox_for_actor
  ]

  # show an activitypub actor for a given username
  def show_actor_for_user
    user = User.find_by username: params[:username]
    render :json => user.actor
  end

  # the inbox for a individual activitypub actor
  def inbox_for_actor

    body = request.body.read.to_json

    case body[:type]
    when "Follow"
      logger.info "Follow request for #{params[:username]} received."
    else
      logger.info "#{body[:type]} received."
    end
  end
end
