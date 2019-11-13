class Note < ApplicationRecord
  belongs_to :user

  # Create a note object reflecting the creation of a new advertisement
  def self.note_for_advertisement(advertisement)
    view_url = "#{ENV['ROOT_CLASSIFEDS_URL']}advertisements/#{advertisement.id}"
    content = """
      #{advertisement.user.username}@#{ENV['CLASSIFEDS_DOMAIN']}
      posted: #{advertisement.title}\n\n
      #{advertisement.body[0..50]}...\n\n
      <a href=\"#{view_url}\">View it here!</a>
    """
    Note.create!({
      "user": advertisement.user,
      "object_id": SecureRandom.uuid,
      "attributedTo": advertisement.user.actor_id,
      "content": content,
    })
  end

  def as_object
    return {
      'id': "#{ENV['ROOT_CLASSIFEDS_URL']}n/#{self.object_id}",
      'type': 'Note',
      'published': self.created_at.utc.httpdate,
      'attributedTo': self.user.actor_id,
      'content': self.content,
      'to': ['https://www.w3.org/ns/activitystreams#Public'],
    }
  end

end
