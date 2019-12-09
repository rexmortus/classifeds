class V2SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:search]
  def search
  end

  private
  def filter(ads)
    ads = Advertisement.where("title ILIKE (?) OR body ILIKE (?)", "%#{params["query"]}%", "%#{params["query"]}%") if exists?(params[:query])
    ads = Advertisement.near(params["location"], params["distance"], units: :km) if exists?(params["location"])
    ads = Advertisement.where("category = ? OR subcategory = ?", params["category"], params["category"])
  end
  # Check if parameter is supplied for filtering or search
  def exists?(parameter)
    parameter != "" && !parameter.nil?
  end
end
