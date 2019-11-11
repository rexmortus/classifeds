class AcceptFollowJob < ApplicationJob
  queue_as :default

  def perform(user, local_actor, remote_action)
    accept_message = generate_accept_message(local_actor, remote_action)
    response = send_accept_message(accept_message, user, local_actor, remote_action["actor"])
    logger.info 'RESPONSE FROM SERVER'
    logger.info response.status
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
    signed_string   = "(request-target): post #{inboxPath}\nhost: #{targetDomain}\ndate: #{date}"
    keypair         = OpenSSL::PKey::RSA.new(user.privkey)
    signature       = Base64.strict_encode64(keypair.sign(OpenSSL::Digest::SHA256.new, signed_string))

    header          = "keyId=\"#{local_actor['id']}\",headers=\"(request-target) host date\",signature=\"#{signature}\"";

    response = HTTP[
      :Host => targetDomain,
      :Date => date,
      :Signature => header
    ]
    .post("#{remote_actor}/inbox", body: accept_message.to_json)

    return response

  end
end
