class UsersController < BaseAuthenticatedController
  skip_before_action :verify_authenticity_token

  def index
    service = load_service
    service.list
    if service.errors.any?
      render_error(422, errors: service.errors)
    else
      render_success(data: service.data, pagination: service.pagination)
    end
  end

  def filter
    service = load_service
    service.filter
    if service.errors.any?
      render_error(422, errors: service.errors)
    else
      render_success(data: service.data, pagination: service.pagination)
    end
  end

  def create
    service = load_service
    service.create
    if service.errors.any?
      render_error(400, errors: service.errors)
    else
      render_success(data: service.new_user_serialized)
    end
  end

  private def load_service
    ::UserService.new(request.params)
  end
end
