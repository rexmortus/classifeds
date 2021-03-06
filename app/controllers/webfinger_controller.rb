class WebfingerController < ApplicationController

  before_action :authenticate_user!, :except => [:account]

  def account

    username = params[:resource].match('(?<=\:).+?(?=\@)').to_s
    user = User.find_by username: username

    if user.present?
      render :json => user.webfinger
    else
      render json: {'error': "User #{username} found."}, status: 400
    end

  end

end
