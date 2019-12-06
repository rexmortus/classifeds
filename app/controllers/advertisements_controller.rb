class AdvertisementsController < ApplicationController

  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show, :index]

  # GET /advertisements
  # GET /advertisements.json
  def index
    redirect_to root_path
  end

  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
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
      for: params[:for]
    )

    respond_to do |format|
      if @advertisement.save
        @advertisement.images.attach(params[:images])
        # NewAdvertisementJob.perform_now(@advertisement)
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
    respond_to do |format|
      if @advertisement.update({
          title: params['title'],
          body: params['body'],
          emoji: params['emoji'],
          category_name: JSON.parse(advertisement_params['category_name'])[0],
          subcategory_name: JSON.parse(advertisement_params['category_name'])[1],
          location: params['location'],
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def advertisement_params
      params.require(:advertisement).permit(:uuid, :title, :body, :published, :location, :category_name, :for, :emoji, :images => [])
    end
end
