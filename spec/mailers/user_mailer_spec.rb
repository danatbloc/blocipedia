require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let (:user) { create(:user) }

  describe "signup" do
    let(:mail) { UserMailer.signup(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Blocipedia Sign Up")
      expect(mail.to).to eq([user.email])
    end
    
  end

end
