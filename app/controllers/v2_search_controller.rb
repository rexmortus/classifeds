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

    if param_exists?(:type)
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

    # Location/geocode param set from current_user or application default
    user_signed_in? ? @location_param   = current_user.location : @location_param   = Rails.application.config.classifeds_default_location
    user_signed_in? ? @geocode_param    = current_user.geocode  : @geocode_param    = Rails.application.config.classifeds_default_geocode

    # Check for params
    param_exists?(:distance)             ? @distance_param   = params[:search][:distance].to_i        : @distance_param     = Rails.application.config.classifeds_default_search_distance
    param_exists?(:types)                ? @types_param      = params[:search][:types]                : @types_param        = []
    param_exists?(:category_subcategory) ? @categories_param = params[:search][:category_subcategory] : @categories_param  = []
    param_exists?(:query)                ? @query_param      = params[:search][:query]                : @query_param        = ""
    param_exists?(:view_type)            ? @view_type_param  = params[:search][:view_type]            : @view_type_param    = "masonry"

    @advertisements = filter(Advertisement.all)


    #   @categories_param =   []
    #   # @view_type_param =    "masonry"
    #   @advertisements =     Advertisement.near(@geocode_param, @distance_param, units: :km).first(10)
    # user_signed_in? ? @location_param = current_user.location : @location_param = Rails.application.config.classifeds_default_location
    # user_signed_in? ? @geocode_param = current_user.geocode : @geocode_param = Rails.application.config.classifeds_default_geocode

    # if params[:search].present?
    #   # @query_param =        params[:search][:query]
    #   @location_param =     user_signed_in? ? current_user.location : Rails.application.config.classifeds_default_location
    #   @geocode_param =      user_signed_in? ? current_user.geocode : Rails.application.config.classifeds_default_geocode
    #   # @distance_param =     params[:search][:distance].to_i
    #   @types_param =        params[:search][:types].present? ? params[:search][:types] : []
    #   @categories_param =   params[:search][:category_subcategory]
    #    # =    params[:search][:view_type]
    #   @advertisements =     filter(Advertisement.all)
    # else
    #   # @query_param =        ""
    #   @location_param =     user_signed_in? ? current_user.location : Rails.application.config.classifeds_default_location
    #   @geocode_param =      user_signed_in? ? current_user.geocode : Rails.application.config.classifeds_default_geocode
    #   # @distance_param =     Rails.application.config.classifeds_default_search_distance
    #   @types_param =        []
    #   @categories_param =   []
    #   # @view_type_param =    "masonry"
    #   @advertisements =     Advertisement.near(@geocode_param, @distance_param, units: :km).first(10)
    # end
  end

  def search_params
    params.require(:search).permit(:query, :location, :distance, :types, :category_subcategory, :view_type)
  end


end
