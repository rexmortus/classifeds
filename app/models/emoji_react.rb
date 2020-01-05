class EmojiReact < ApplicationRecord
  belongs_to :advertisement

  acts_as_notifiable :users,

    targets: ->(react) {
      ([react.advertisement.user])
    },
    notifiable_path: :emoji_notifiable_path

  def emoji_notifiable_path
    advertisement_path(self.advertisement)
  end

end
