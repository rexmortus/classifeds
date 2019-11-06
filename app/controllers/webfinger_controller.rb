class WebfingerController < ApplicationController

  before_action :authenticate_user!, :except => [:account]

  def account

    username = params[:resource].match('(?<=\:).+?(?=\@)').to_s
    # binding.pry

    if User.where(username: username).exists?(conditions = :none)
      response = {
        "subject": params[:resource],
        "links": [
          {
            "rel": "self",
            "type": "application/activity+json",
            "href": "#{root_url}actor"
          }
        ]
      }
      render :json => response.to_json
    else
      render :json => {'error': 'doesnt exist'}.to_json
    end

  end

end
