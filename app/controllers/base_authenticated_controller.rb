class BaseAuthenticatedController < ApplicationController
  AUTH_HEADER = "Authorization".freeze

  before_action :authenticate_request

  private def authenticate_request
    return if header_matches?

    respond_to do |format|
      format.html { render "access_denied", status: :unauthorized }
      format.json { render json: { error: "Access denied"}, status: :unauthorized }
    end
  end

  private def header_matches?
    request.headers[AUTH_HEADER] == SECRET_API_KEY
  end
end
