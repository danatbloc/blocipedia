require 'rails_helper'

RSpec.describe Wiki, type: :model do

 let(:my_wiki) { create(:wiki) }

 it { is_expected.to belong_to(:user) }
 it { is_expected.to validate_presence_of(:title) }
 it { is_expected.to validate_presence_of(:body) }
 it { is_expected.to validate_presence_of(:user) }
 it { is_expected.to validate_length_of(:title).is_at_least(5) }
 it { is_expected.to validate_length_of(:body).is_at_least(15) }

 describe "attributes" do
    it "has title and body attributes" do
      expect(my_wiki).to have_attributes(title: my_wiki.title, body: my_wiki.body, user: my_wiki.user)
    end
  end

end
