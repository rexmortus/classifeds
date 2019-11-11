require 'http'
require 'openssl'

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
      # {
      #   '@context': 'https://www.w3.org/ns/activitystreams',
      #   id: 'https://aus.social/cd7037a7-1d6c-49a3-8450-cf206548cc98',
      #   type: 'Follow',
      #   actor: 'https://aus.social/users/rexmortus',
      #   object: 'https://89a1028f.ngrok.io/u/rexmortus'
      # }
      remote_action = JSON.parse(request.body.read)

      # The remote actor, taking the action (a string), e.g.
      # https://aus.social/users/rexmortus
      remote_actor = remote_action["actor"]

      # Generate a response message based on action type
      case remote_action["type"]
      when "Follow"
        accept_message = generate_accept_message(local_actor, remote_action)
        send_accept_message(accept_message, user, local_actor, remote_actor)
      else
        render json: {'error': "Action not supported."}, status: 400
      end
    else
      render json: {'error': "User #{username} not found."}, status: 400
    end


  end

  private

  # Generate an 'Accept' message on behalf of the receiving actor
  def generate_accept_message(local_actor, remote_action)
    return {
      "@context": "https://www.w3.org/ns/activitystreams",
      "id": "#{ENV['ROOT_CLASSIFEDS_URL']}#{SecureRandom.uuid}",
      "type": "Accept",
      "actor": "#{local_actor["id"]}",
      "object": remote_action
    }
  end

  def send_accept_message(accept_message, user, local_actor, remote_actor)

    date            = Time.now.utc.httpdate
    inboxPath       = "#{URI(remote_actor).path}/inbox"
    targetDomain    = URI(remote_actor).host
    signed_string  = "(request-target): post #{inboxPath}\nhost: #{targetDomain}\ndate: #{date}"
    keypair         = OpenSSL::PKey::RSA.new(user.privkey)
    signature       = Base64.strict_encode64(keypair.sign(OpenSSL::Digest::SHA256.new, signed_string))

    header          = "keyId=\"#{local_actor['id']}\",headers=\"(request-target) host date\",signature=\"#{signature}\"";

    HTTP.headers(
      {
        'Host': targetDomain,
        'Date': date,
        'Signature': header
      })
    .post("#{remote_actor}/inbox", body: accept_message.to_json)

  end

end
