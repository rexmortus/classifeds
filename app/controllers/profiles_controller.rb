class ProfilesController < ApplicationController

  skip_before_action :authenticate_user!, :verify_authenticity_token, only: [:about]
  before_action :set_user, only: [:edit, :update]

  def edit
  end

  def update

    puts user_params[:contact_methods].values.to_json

    respond_to do |format|
      if @user.update({
          location: user_params[:location],
          locale: user_params[:locale],
          contact_methods: user_params[:contact_methods].values.to_json,
        })
        format.html { redirect_to profile_edit_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def about
    qrcode = RQRCode::QRCode.new(SecureRandom.uuid)

    # NOTE: showing with default options specified explicitly
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
      size: 70
    )

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:location, :locale, :contact_methods => {})
  end

end
