class ApiController < ApplicationController

  skip_before_action :verify_authenticity_token

  def inbox
    logger.debug params.as_json.to_s
  end

end
