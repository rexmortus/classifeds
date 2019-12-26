# TODO refactor various pages to share one form

class AdvertisementsController < ApplicationController

  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  before_action :set_new_advertisement_contact_methods, only: [:new, :create]
  before_action :set_contact_methods, only: [:edit, :update]
  skip_before_action :authenticate_user!, only: [:show, :index]

  # GET /advertisements
  # GET /advertisements.json
  def index
    redirect_to root_path
  end

  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
    @original_url = request.original_url

    qrcode = RQRCode::QRCode.new(@original_url)
    @png = qrcode.as_png(
      bit_depth: 12,
      border_modules: 0,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 1,
      resize_exactly_to: 32,
      resize_gte_to: 32,
      size: 300
    )
    @publicContactMethods = @advertisement.user.contact_methods_as_array.select { |method| !method['public'].nil? && @advertisement.contact_methods_as_array.include?(method["name"]) }
    @privateContactMethods = @advertisement.user.contact_methods_as_array.select { |method| method['public'].nil? && @advertisement.contact_methods_as_array.include?(method["name"]) }
    @advertisement.punch(request)
  end

  # GET /advertisements/new
  def new
    @advertisement = Advertisement.new
  end

  # GET /advertisements/1/edit
  def edit
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    params = advertisement_params

    @advertisement = Advertisement.new(
      user: current_user,
      title: params[:title],
      body: params[:body],
      emoji: params[:emoji],
      published: params[:published],
      category_name: JSON.parse(advertisement_params[:category_name])[0],
      subcategory_name: JSON.parse(advertisement_params[:category_name])[1],
      location: params[:location],
      contact_methods: params[:contact_methods].keys.to_json,
      for: params[:for]
    )

    @advertisement.images.attach(params[:images])
    # NewAdvertisementJob.perform_now(@advertisement)

    respond_to do |format|
      if @advertisement.save
        format.html { redirect_to advertisement_path(@advertisement), notice: 'Advertisement was successfully created.' }
        format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update

    params = advertisement_params

    # TODO fix this
    if !params[:images].nil?
      @advertisement.images.attach(params[:images])
    end

    respond_to do |format|
      if @advertisement.update({
          title: params['title'],
          body: params['body'],
          emoji: params['emoji'],
          category_name: JSON.parse(advertisement_params['category_name'])[0],
          subcategory_name: JSON.parse(advertisement_params['category_name'])[1],
          location: params['location'],
          contact_methods: params[:contact_methods].keys.to_json,
          for: params['for']
        })
        format.html { redirect_to advertisement_path(@advertisement), notice: 'Advertisement was successfully updated.' }
        format.json { render :show, status: :ok, location: @advertisement }
      else
        format.html { render :edit }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisements/1
  # DELETE /advertisements/1.json
  def destroy
    @advertisement.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'Advertisement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def subcategory
    @advertisements = Advertisement.where(category_id: params[:category_id], subcategory_id: params[:subcategory_id])
    @pagetitle = Advertisement.title_header_for_category_page(params[:category_id], params[:subcategory_id])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_advertisement
    @advertisement = Advertisement.references([:emoji_react, :user]).find(params[:uuid])
  end

  def set_new_advertisement_contact_methods
    @publicContactMethods = current_user.contact_methods_as_array.select { |method| !method['public'].nil? }
    @privateContactMethods = current_user.contact_methods_as_array.select { |method| method['public'].nil? }
  end

  def set_contact_methods
    @publicContactMethods = @advertisement.user.contact_methods_as_array.select { |method| !method['public'].nil? }
    @privateContactMethods = @advertisement.user.contact_methods_as_array.select { |method| method['public'].nil? }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def advertisement_params
    params.require(:advertisement).permit(:uuid, :title, :body, :published, :location, :category_name, :for, :emoji, :images => [], :contact_methods => {})
  end
end
