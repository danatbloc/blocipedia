class Wiki < ApplicationRecord
  belongs_to :user

  scope :privates, -> { where( 'private = ?', true ) }

  validates :title, {
    length: { minimum: 5, maximum: 100 },
    presence: true,
  }

  validates :body, {
    length: { minimum: 15, maximum: 10000 },
    presence: true,
  }

  validates :user, presence: true

end
