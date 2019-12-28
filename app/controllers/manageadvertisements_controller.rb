class ManageadvertisementsController < ApplicationController

  before_action :set_advertisements, :user_confirmed?

  def show

  end

  private

  def set_advertisements
    @advertisements = Advertisement.where(user: current_user)
  end

  def user_confirmed?
    if current_user.confirmed? === false
      redirect_to root_path, notice: 'You must confirm your account.'
    end
  end

end
