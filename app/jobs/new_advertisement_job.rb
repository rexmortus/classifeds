# Having created a new advertisement, notify followers

class NewAdvertisementJob < ApplicationJob
  queue_as :default

  def perform(advertisement)
    advertisement_note = Note::note_for_advertisement(advertisement)
    create_activty = generate_create_advertisement_activity(advertisement, advertisement_note)

    advertisement.user.followers each do |follower|

      response = send_create_activity(create_activty, advertisement.user, follower)

      if response.status.success?
        logger.info "#{URI(remote_action["actor"]).host} SUCCESS"
      elsif response.status.client_error?
        logger.warn "#{URI(remote_action["actor"]).host} CLIENT ERROR"
      elsif response.status.server_error?
        logger.error "#{URI(remote_action["actor"]).host} SERVER ERROR"
      end
    end
  end

  # Generate an 'Accept' message on behalf of the receiving actor
  def generate_create_advertisement_activity(advertisement, advertisement_note)
    return {
    	"@context": "https://www.w3.org/ns/activitystreams",
    	"id": "#{ENV['ROOT_CLASSIFEDS_URL']}a/#{SecureRandom.uuid}",
    	"type": "Create",
    	"actor": advertisement.user.actor_id,
    	"object": advertisement_note.as_object
    }
  end

  def send_create_activity(create_activty, user, remote_actor)

    date            = Time.now.utc.httpdate
    inboxPath       = "#{URI(remote_actor).path}/inbox"
    targetDomain    = URI(remote_actor).host
    signed_string   = "(request-target): post #{inboxPath}\nhost: #{targetDomain}\ndate: #{date}"
    keypair         = OpenSSL::PKey::RSA.new(user.privkey)
    signature       = Base64.strict_encode64(keypair.sign(OpenSSL::Digest::SHA256.new, signed_string))

    header          = "keyId=\"#{user.actor_id}\",headers=\"(request-target) host date\",signature=\"#{signature}\"";

    response = HTTP[
      :Host => targetDomain,
      :Date => date,
      :Signature => header
    ]
    .post("#{remote_actor}/inbox", body: create_activty.to_json)

    return response

  end
end
