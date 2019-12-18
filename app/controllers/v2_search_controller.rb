class V2SearchController < ApplicationController

  skip_before_action :authenticate_user!, only: [:search]

  def search
    set_params
  end

  private

  def filter(ads)

    ads = ads.near(@geocode_param, @distance_param, units: :km)

    if param_exists?(:query)
      ads = ads.where('title ILIKE ? OR body ILIKE ?', "%#{@query_param}%", "%#{@query_param}%") if @query_param
    end

    if param_exists?(:types)
      ads = ads.where(for: @types_param)
    end

    if param_exists?(:category_subcategory)
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
  def param_exists?(parameter)
    params[:search].present? && !params[:search][parameter].nil? && params[:search][parameter] != ""
  end

  def set_params

    puts params

    # Location/geocode param set from current_user or application default
    if param_exists?(:location)
      @location_param       = params[:search][:location]
    elsif user_signed_in?
      @location_param       = current_user.location
    else
      @location_param       = Rails.application.config.classifeds_default_location
    end

    # FYI Geocoder results are cached, so this shouldn't take long each time
    @geocode_param = Geocoder.search(@location_param).first.coordinates

    # Check for other search params
    param_exists?(:distance)             ? @distance_param   = params[:search][:distance].to_i        : @distance_param     = Rails.application.config.classifeds_default_search_distance
    param_exists?(:types)                ? @types_param      = params[:search][:types]                : @types_param        = []
    param_exists?(:category_subcategory) ? @categories_param = params[:search][:category_subcategory] : @categories_param  = []
    param_exists?(:query)                ? @query_param      = params[:search][:query]                : @query_param        = ""
    param_exists?(:view_type)            ? @view_type_param  = params[:search][:view_type]            : @view_type_param    = "masonry"

    # Apply the filters
    @advertisements = filter(Advertisement.all)

  end

  def search_params
    params.require(:search).permit(:query, :location, :distance, :types, :category_subcategory, :view_type)
  end


end
