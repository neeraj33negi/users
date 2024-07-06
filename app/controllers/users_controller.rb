class UsersController < BaseAuthenticatedController

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
    render json: {}, status: 200
  end

  def create
  end

  private def load_service
    ::UserService.new(request.params)
  end
end
