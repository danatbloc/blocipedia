class Wiki < ApplicationRecord
  belongs_to :user
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators

  scope :privates, -> { where( 'private = ?', true ) }
  scope :publics, -> { where( 'private = ?', false ) }
  scope :owner, -> (cur_user) { where( "user_id = ?", cur_user.id ) }
  scope :collabs, -> (cur_user) do
    Wiki.joins(:users).where('collaborators.user_id = ?', cur_user.id)
  end

  scope :visible_to, -> (user) do
    unless user
      publics
    else
      if user.admin?
        all
      elsif user.standard?
        publics + collabs(user)
      else
        publics + owner(user) + collabs(user)
      end
    end
  end


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
