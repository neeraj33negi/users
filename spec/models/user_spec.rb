require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    FactoryBot.build(:user)
  end

  describe "Validation tests" do
    subject { user }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    describe "invalid email is passed" do
      before { user.email = "wrongemail" }
      it "doesn't save the user" do
        expect(user.save).to be_falsey
      end

      it "marks it as invalid" do
        user.valid?
        expect(user.errors.full_messages).to include("Email is invalid")
      end
    end

    describe "invalid campaigns_list" do
      let(:user1) do
        FactoryBot.build(:user, campaigns_list: [
          {},
          {},
        ])
      end

      it "marks users invalid if empty hashes are given" do
        user1.valid?
        expect(user1.errors.full_messages).to include("Campaigns list Invalid Campaign Data")
      end

      it "marks users invalid if campaign_name is not given" do
        user1.campaigns_list = [{campaign_name: "", campaign_id: rand(1000)}]
        user1.valid?
        expect(user1.errors.full_messages).to include("Campaigns list Incomplete or missing Campaign Data")
      end

      it "marks users invalid if campaign_id is not given" do
        user1.campaigns_list = [{campaign_name: "test", campaign_id: ""}]
        user1.valid?
        expect(user1.errors.full_messages).to include("Campaigns list Incomplete or missing Campaign Data")
      end

      it "marks users valid if campaign_list is empty" do
        user1.campaigns_list = []
        expect(user1.valid?).to be_truthy
      end
    end
  end

  describe "campaign data filters" do
    let(:user1) do
      FactoryBot.build(:user, campaigns_list: [
        {campaign_name: "cam1", campaign_id: rand(1000)},
        {campaign_name: "cam2", campaign_id: rand(1000)},
      ])
    end
    let(:user2) do
      FactoryBot.build(:user, campaigns_list: [
        {campaign_name: "cam2", campaign_id: rand(1000)},
        {campaign_name: "cam3", campaign_id: rand(1000)},
      ])
    end
    let(:user3) do
      FactoryBot.build(:user, campaigns_list: [
        {campaign_name: "cam3", campaign_id: rand(1000)},
        {campaign_name: "cam4", campaign_id: rand(1000)},
      ])
    end

    before do
      user1.save
      user2.save
      user3.save
    end

    it "returns correct users for campagin names" do
      users = User.load_by_campaign_names("cam1", "cam2").to_a
      expect(users).to include(user1)
      expect(users).to include(user2)
    end

    it "doesnt returns invalid users for campagin names" do
      users = User.load_by_campaign_names("cam1").to_a
      expect(users).to include(user1)
      expect(users).to_not include(user2)
    end

    it "returns unique users for campagin names" do
      users = User.load_by_campaign_names("cam1", "cam2", "cam3").to_a
      expect(users).to include(user1)
      expect(users).to include(user2)
      expect(users).to include(user3)
      expect(users.count).to eq(3)
    end
  end
end
