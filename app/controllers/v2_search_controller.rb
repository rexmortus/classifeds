class V2SearchController < ApplicationController

  # This can all be done without logging in
  skip_before_action :authenticate_user!, only: [:search]

  # The main (only) search method 👈
  def search
    set_params
  end

  # Everything else is private

  # param_exists?(parameter) : checks if a search parameter has been supplied
  # set_params() : sets the search parameters as instance variables
  # filter(ads) : applies filters to the search
  # search_params : list of allowed parameters (strong params)

  private

  # Check if parameter is supplied for filtering or search ❓
  def param_exists?(parameter)
    params[:search].present? && !params[:search][parameter].nil? && params[:search][parameter] != ""
  end

  # Safely (and with sensible defaults) 🎯
  # set the search parameters
  def set_params

    # Location/geocode param are set from current_user or application default
    if param_exists?(:location)
      @location_param       = params[:search][:location]
    elsif user_signed_in?
      @location_param       = current_user.location
    else
      @location_param       = Rails.application.config.classifeds_default_location
    end

    # FYI Geocoder results are cached 🌐
    # but this takes a long time when it's a location that hasn't been visited before
    # (by this instance)
    # but otherwise it's fast (redis🔥)
    @geocode_param = Geocoder.search(@location_param).first.coordinates

    # If a paramter was supplied 🔎      use the supplied param                                      OR Use some default value
    param_exists?(:distance)             ? @distance_param   = params[:search][:distance].to_i        : @distance_param     = Rails.application.config.classifeds_default_search_distance
    param_exists?(:types)                ? @types_param      = params[:search][:types]                : @types_param        = []
    param_exists?(:category_subcategory) ? @categories_param = params[:search][:category_subcategory] : @categories_param   = []
    param_exists?(:query)                ? @query_param      = params[:search][:query]                : @query_param        = ""
    param_exists?(:view_type)            ? @view_type_param  = params[:search][:view_type]            : @view_type_param    = "masonry"

    # Apply the filters ⚡️
    @advertisements = filter(Advertisement.all)

  end

  # Apply the filters to the ads ☕️
  def filter(ads)

    # Only get those ads that are within the search distance (in km) 🌎
    ads = ads.near(@geocode_param, @distance_param, units: :km)

    # If they have supplied a query string, search the title and body for it 🗣
    if param_exists?(:query)
      ads = ads.where('title ILIKE ? OR body ILIKE ?', "%#{@query_param}%", "%#{@query_param}%") if @query_param
    end

    # If they have supplied a "types" filter, apply it 😎
    if param_exists?(:types)
      ads = ads.where(for: @types_param)
    end

    # If they have supplied a "category_subcategory" filter, apply it 💰
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

    # Return the filtered (or not) ads ✅
    return ads
  end

  # List of allowed params ☑️☑️🛑
  def search_params
    params.require(:search).permit(:query, :location, :distance, :types, :category_subcategory, :view_type)
  end

end
