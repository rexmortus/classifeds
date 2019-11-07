class ApiController < ApplicationController

  def inbox
    logger.debug params.as_json.to_s
  end

end
