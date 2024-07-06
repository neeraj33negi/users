require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    FactoryBot.build(:user)
  end

  describe "Validation tests" do
    subject { user }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    context "when invalid email is passed" do
      before { user.email = "wrongemail" }
      it "doesn't save the user" do
        expect(user.save).to be_falsey
      end

      it "marks it as invalid" do
        user.valid?
        expect(user.errors.full_messages).to include("Email is invalid")
      end
    end
  end
end
