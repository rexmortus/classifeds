class EmojireactController < ApplicationController

  before_action :set_advertisement, :set_emoji_react

  def create

    # If there is no Emoji react, then create one and notify the poster
    if @emoji_react.nil?
      emoji = EmojiReact.create!(emoji: params[:emoji][:emoji], advertisement: @advertisement, actor: current_user.username)
      emoji.notify :users
    else
      @emoji_react.destroy
    end

    respond_to do |format|
      format.html { redirect_to advertisement_path(@advertisement) }
      format.js
    end
  end

  private

  def set_advertisement
    @advertisement = Advertisement.find(params[:advertisement_uuid])
  end

  def set_emoji_react
    @emoji_react = EmojiReact.find_by(advertisement: @advertisement, emoji: params[:emoji][:emoji], actor: current_user.username)
  end

end
