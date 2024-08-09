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

  def encode_token(payload)
    JWT.encode(payload, 'hellomars1211')
  end

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(" ")[1]
      begin
          JWT.decode(token, 'hellomars1211')
      rescue JWT::DecodeError
          nil
      end
    end
  end
end
