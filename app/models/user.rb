class User < ApplicationRecord

  has_many :wikis, dependent: :destroy
  has_many :collaborators, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_initialize :set_default_role

  validates :name, {
    length: { minimum: 1, maximum: 100 },
    presence: true,
    uniqueness: { :case_sensitive => false,
      message: 'is already taken.' }
  }

  before_save { self.email = email.downcase if email.present? }
  before_save { self.name = name.downcase.capitalize }

  enum role: [:standard, :admin, :premium]

  private

  def set_default_role
    self.role ||= :standard
  end

end
