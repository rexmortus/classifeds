class ManageadvertisementsController < ApplicationController

  before_action :set_advertisements

  def show

  end

  private

  def set_advertisements
    @advertisements = Advertisement.where(user: current_user)
  end

end
