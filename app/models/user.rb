class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :generate_keys, :generate_actor, :generate_webfinger

  private

  def generate_keys
    key = OpenSSL::PKey::RSA.new 2048
    self.pubkey = key.public_key.to_s
    self.privkey = key.to_s
    self.save
  end

  def generate_actor

    actor = {
      "@context": [
        "https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1"
      ],

      "id": "#{ENV['ROOT_CLASSIFEDS_URL']}u/#{self.username}",
      "type": "Person",
      "preferredUsername": "#{self.username}",
      "inbox": "#{ENV['ROOT_CLASSIFEDS_URL']}u/#{self.username}/inbox",
      "followers": "#{ENV['ROOT_CLASSIFEDS_URL']}u/#{self.username}/followers",

      "publicKey": {
        "id": "#{ENV['ROOT_CLASSIFEDS_URL']}u/#{self.username}#main-key",
        "owner": "#{ENV['ROOT_CLASSIFEDS_URL']}u/#{self.username}",
        "publicKeyPem": self.pubkey
      }
    }
    self.actor = actor.to_json.to_s
    self.save

  end

  def generate_webfinger

    webfinger = {
      "subject": "acct:#{self.username}@#{ENV['CLASSIFEDS_DOMAIN']}",
      "links": [
        {
          "rel": "self",
          "type": "application/activity+json",
          "href": "#{ENV['ROOT_CLASSIFEDS_URL']}u/#{self.username}"
        }
      ]
    }
    self.webfinger = webfinger.to_json.to_s
    self.save

  end

end
