class ActorController < ApplicationController

  skip_before_action :authenticate_user!, :verify_authenticity_token

  # show an activitypub actor for a given username
  def show_actor_for_user
    username = params[:username]
    user = User.find_by username: username

    if user.present?
      render :json => user.actor
    else
      render json: {'error': "User #{username} found."}, status: 400
    end
  end

  # the inbox for a individual activitypub actor
  def inbox_for_actor

    username = params[:username]
    user = User.find_by username: username

    if user.present?
      # The local actor, receiving the action
      local_actor = JSON.parse(user.actor)

      # The remote action, e.g.:
      remote_action = JSON.parse(request.body.read)

      # Generate a response message based on action type
      case remote_action["type"]
      when "Follow"
        AcceptFollowJob.perform(user, local_actor, remote_action)
      else
        render json: {'error': "Action not supported."}, status: 400
      end
    else
      render json: {'error': "User #{username} not found."}, status: 400
    end


  end

end
