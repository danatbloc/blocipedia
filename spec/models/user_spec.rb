require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, name: "bLOCHEAD") }

  it { is_expected.to have_many(:wikis) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1) }

  it { is_expected.to validate_presence_of(:email) }

  describe 'email uniqueness' do
    let(:new_user) { build :user, email: user.email }
    it "should validate uniqueness of email" do
      expect(new_user).to_not be_valid
    end
  end

  it { is_expected.to allow_value("user@bloccit.com").for(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe "attributes" do
    it "should have name and email attributes" do
      expect(user).to have_attributes(name: user.name, email: user.email )
    end

    it "should capitalize name" do
      expect(user).to have_attributes(name: "Blochead")
    end
  end

  describe "invalid user" do
    let(:user_with_invalid_name) { build(:user, name: "") }
    let(:user_with_invalid_email) { build(:user, email: "") }

    it "should be an invalid user due to blank name" do
      expect(user_with_invalid_name).to_not be_valid
    end

    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_email).to_not be_valid
    end
  end

end
