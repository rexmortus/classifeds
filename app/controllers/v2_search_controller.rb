class V2SearchController < ApplicationController

  skip_before_action :authenticate_user!, only: [:search]

  def search
    if params[:search].present?
      @query_param =        params[:search][:query]
      @location_param =     params[:search][:location]
      @distance_param =     params[:search][:distance].to_i
      @types_param =        params[:search][:types]
      @categories_param =   params[:search][:category_subcategory]
      @advertisements =     filter(Advertisement.all)
    else
      @query_param =    ""
      @location_param = Rails.application.config.classifeds_default_location
      @distance_param = 25
      @type_param = []
      @advertisements = Advertisement.near(@location_param, @distance_param, units: :km).first(10)
    end
    # raise
  end

  private

  def filter(ads)
    ads = ads.where("title ILIKE (?) OR body ILIKE (?)", "%#{@query_param}%", "%#{@query_param}%")

    ads = ads.near(@location_param, @distance_param, units: :km)

    if exists?(params[:search][:query])
      ads = ads.where('title ILIKE (?) OR body ILIKE (?)', @query_param, @query_param)
    end

    if exists?(params[:search][:types])
      ads = ads.where(for: @types_param)
    end

    if exists?(params[:search][:category_subcategory])

      # Split the param (it comes in like 'Category > Subcategory')
      _params = params[:search][:category_subcategory].split(" > ")

      category_param = _params.first

      ads = ads.where(
        category_name: [category_param],
      )

      if _params.second.present?
        ads = ads.where(
          subcategory_name: [_params.second],
        )
      end

    end

    return ads

  end

  # Check if parameter is supplied for filtering or search
  def exists?(parameter)
    parameter != "" && !parameter.nil?
  end

  def search_params
    params.require(:search).permit(:query, :location, :distance, :types, :category_subcategory)
  end


end
