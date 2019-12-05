class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @ads = Advertisement.last(10)
  end
end
