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
        accept_message_body = generate_accept_message(actor["id"], body)
        send_accept_message(accept_message_body, user)
      else
        render json: {'error': "Action not supported."}, status: 400
      end
    else
      render json: {'error': "User #{username} not found."}, status: 400
    end


  end

  private

  def generate_accept_message(actor_id, body)
    {
      "@context": "https://www.w3.org/ns/activitystreams",
      "id": "#{ENV['ROOT_CLASSIFEDS_URL']}#{SecureRandom.uuid}",
      "type": "Accept",
      "actor": "#{actor_id}",
      "object": body
    }
  end

  def send_accept_message(accept_message_body, user)

    logger.info 'Sending accept message...'
    time = Time.now.utc.to_s

    inboxFragment = "something"
    targetDomain = "some.domain"
    string_to_sign = "(request-target): post #{inboxFragment}\nhost: #{targetDomain}\ndate: #{time}`;"
    digest = OpenSSL::Digest.new('sha256')
    signature = OpenSSL::HMAC.hexdigest(digest, user.privkey, string_to_sign)
    signature_b64 = Base64.strict_encode64(signature)

    header = "keyId=\"#{accept_message_body["id"]}\",headers=\"(request-target) host date\",signature=\"#{signature_b64}\"";
    logger.info header
  end

end
