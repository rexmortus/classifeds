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
      body = JSON.parse(request.body.read)
      actor = JSON.parse(user.actor)

      case body["type"]
      when "Follow"
        accept_message_body = {
          "@context": "https://www.w3.org/ns/activitystreams",
          "id": "#{ENV['ROOT_CLASSIFEDS_URL']}#{SecureRandom.uuid}",
          "type": "Accept",
          "actor": "#{user.actor["id"]}",
          "object": body
        }
        logger.info accept_message_body
      else
        render json: {'error', "#{body['type']} not supported"}, status: 500
      end
    else
      render json: {'error': "User #{username} found."}, status: 400
    end


  end
end
