class Amount < ApplicationRecord

  validates :price,
    presence: true,
    numericality: { only_integer: true, greater_than: 99 }

    
end
