class V2SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search]
  def search
    @advertisements = filter(Advertisement.all)
  end

  private
  def filter(ads)
    ads = ads.where("title ILIKE (?) OR body ILIKE (?)", "%#{params["query"]}%", "%#{params["query"]}%") if exists?(params[:query])
    ads = ads.near(params["location"], params["distance"], units: :km) if exists?(params["location"])
    ads = ads.where("category_name = ? OR subcategory_name = ?", params["category"], params["category"]) if exists?(params["category"])
    ads = ads.where("for = ?", params["for"]) if exists?(params["for"])
    return ads
  end
  # Check if parameter is supplied for filtering or search
  def exists?(parameter)
    parameter != "" && !parameter.nil?
  end
end
