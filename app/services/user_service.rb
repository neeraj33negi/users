class UserService
  class InvalidPage < StandardError; end

  LEAST_PAGE_VALUE = 1
  LEAST_PER_PAGE_VALUE = 0
  MAX_PER_PAGE_VALUE = 100
  PAGE_ERROR_MSG = "Invalid page values".freeze

  attr_accessor :params, :errors, :records, :pagination, :data

  def initialize(params)
    self.params = params
    self.errors = []
    self.data = []
    self.params[:per_page] = params[:per_page].presence ? params[:per_page].to_i : 50
    self.params[:page] = params[:page].presence ? params[:page].to_i : 1
    self.pagination = { page: page_value, per_page: per_page_value, more: more_pages? } ## we dont need this for creation
  end

  def list
    begin
      validate_pagination_params!
      load!
    rescue InvalidPage => e
      self.errors << e.message
    end
  end

  private def load!
    limit, offset = limit_offset_from_params
    self.records = User.order(updated_at: :desc).offset(offset).limit(limit + 1).to_a
    if records.count > pagination[:per_page]
      pagination[:more] =
      self.records.delete_at(-1)
    end
    serialize_records
  end

  def filter
    validate_pagination_params!
  end

  def create
  end

  private def serialize_records
    if records.present?
      self.data = ::UserRepresenter.for_collection.new(records).as_json
    end
  end

  private def validate_pagination_params!
    if params[:page] < LEAST_PAGE_VALUE || params[:per_page] < LEAST_PER_PAGE_VALUE ||
      params[:per_page] > MAX_PER_PAGE_VALUE
      raise InvalidPage.new(PAGE_ERROR_MSG)
    end
  end

  private def page_value
    params[:page] || 0
  end

  private def per_page_value
    params[:per_page] || 10
  end

  private def more_pages?
    params[:more] || false
  end

  ## We can use a pagination library but not really needed for a small project like this
  private def limit_offset_from_params
    per_page = params[:per_page]
    current_page = params[:page]
    limit = per_page
    offset = limit * (current_page - 1)
    pagination[:page] = current_page
    pagination[:per_page] = per_page
    [limit, offset]
  end
end
