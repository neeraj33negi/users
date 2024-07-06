class User < ApplicationRecord

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  before_create :ensure_empty_campaign_if_missing

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
