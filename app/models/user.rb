class User < ApplicationRecord

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  before_create :ensure_empty_campaign_if_missing

  ## This is not optimal, this can fire a large IN query
  ## Better thing is to make campaigns a separate table/model or any other data modelling
  def self.load_by_campaign_names(*campaign_names)
    sql = "SELECT distinct id FROM users, JSON_TABLE(campaigns_list,
            '$[*]'COLUMNS(
            campaign_id VARCHAR(10) PATH '$.campaign_id',
            campaign_name VARCHAR(10) PATH '$.campaign_name'
          )
        ) AS projection where campaign_name IN ('#{campaign_names.join("','")}')"
    ids = connection.execute(sql).to_a
    ids.flatten!
    where(id: ids)
  end

  def campaign_names
    campaigns_list.map { |campaign| campaign["campaign_name"] }
  end

  def campaign_ids
    campaigns_list.map { |campaign| campaign["campaign_id"] }
  end

  private def ensure_empty_campaign_if_missing
    self.campaigns_list ||= []
  end
end
