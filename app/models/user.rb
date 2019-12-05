class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :generate_keys, :generate_actor, :generate_webfinger
  after_find :set_actor_id

  has_many :followers
  has_many :notes
  has_many :advertisements

  attr_reader :actor_id

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  def actor_as_hash
    return JSON.parse(self.actor)
  end

  def followers_as_collection
    return {
      "@context": ["https://www.w3.org/ns/activitystreams"],
      "type": "Collection",
      "totalItems": self.followers.length,
      "id": "#{JSON.parse(self.actor)['id']}/followers",
      "items": self.followers.map { |follower| follower.actor }
    }
  end

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

  def set_actor_id
    @actor_id = self.actor_as_hash["id"]
  end

end
