class UserService
  class InvalidPage < StandardError; end
  class MissingDataError < StandardError; end
  class InvalidDataError < StandardError; end

  LEAST_PAGE_VALUE = 1
  LEAST_PER_PAGE_VALUE = 0
  MAX_PER_PAGE_VALUE = 100
  PAGE_ERROR_MSG = "Invalid page values".freeze
  INTERNAL_SERVER_ERROR = "Internal Server Error".freeze

  attr_accessor :params, :errors, :records, :pagination, :data, :new_record, :new_user_serialized

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
    rescue ActiveRecord::StatementInvalid => e ## this should not happen, but good to handle for timeouts
      self.errors << INTERNAL_SERVER_ERROR
    end
  end

  private def load!(campaign_names = "")
    limit, offset = limit_offset_from_params
    if campaign_names.present?
      self.records = User.load_by_campaign_names(campaign_names).order(updated_at: :desc).
                      offset(offset).limit(limit + 1).to_a
    else
      self.records = User.order(updated_at: :desc).offset(offset).limit(limit + 1).to_a
    end
    if records.count > pagination[:per_page]
      pagination[:more] =
      self.records.delete_at(-1)
    end
    serialize_records
  end

  def filter
    validate_pagination_params!
    load!(campaign_names)
  end


  def create
    begin
      validate_creation_params!
      user = User.new(user_creation_attributes)
      if user.save
        self.new_record = user
        serialize_records
      else
        errors << user.errors.full_messages.join(", ")
      end
    rescue MissingDataError, InvalidDataError => e
      errors << e.message
    end
  end

  private def user_creation_attributes
    {
      name: params[:name],
      email: params[:email],
      campaigns_list: params[:campaigns_list],
    }
  end

  private def campaign_names
    params[:campaign_names].split(",")
  end

  private def serialize_records
    if records.present?
      self.data = ::UserRepresenter.for_collection.new(records).as_json
    end
    if new_record.present?
      self.new_user_serialized = ::UserRepresenter.new(new_record).as_json
    end
  end

  private def validate_pagination_params!
    if params[:page] < LEAST_PAGE_VALUE || params[:per_page] < LEAST_PER_PAGE_VALUE ||
      params[:per_page] > MAX_PER_PAGE_VALUE
      raise InvalidPage.new(PAGE_ERROR_MSG)
    end
  end


  private def validate_creation_params!
    if params["name"].blank? || params["email"].blank?
      raise MissingDataError.new("Name or Email missing")
    end
    if params["campaigns_list"].present?
      unless params["campaigns_list"].is_a?(Array)
        raise InvalidDataError.new("Invalid Campaign Data")
      end
      params["campaigns_list"].each do |campaign_data|
        if campaign_data.blank? || !campaign_data.is_a?(Hash)
          raise InvalidDataError.new("Invalid Campaign Data")
        end
        if campaign_data["campaign_name"].blank? || campaign_data["campaign_id"].blank?
          raise InvalidDataError.new("Incomplete or missing Campaign Data")
        end
      end
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
