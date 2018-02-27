require 'rails_helper'

RSpec.describe Amount, type: :model do

  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(99) }
  it { is_expected.to validate_numericality_of(:price).only_integer }

end
