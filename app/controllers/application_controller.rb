class ApplicationController < ActionController::Base
  def render_response(status, message)
    render json: {
      status: status,
      message: message
    }, status: status
  end

  def render_success(message = {})
    render json: {
      success: true
    }.merge(message), status: 200
  end

  def render_error(status, message = {})
    render json: {
      success: false
    }.merge(message), status: status
  end
end
