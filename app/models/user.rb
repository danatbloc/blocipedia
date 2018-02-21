class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, {
    length: { minimum: 1, maximum: 100 },
    presence: true,
    uniqueness: { :case_sensitive => false,
      message: 'is already taken.' }
    }


  before_save { self.email = email.downcase if email.present? }
  before_save { self.name = name.downcase.capitalize }

end
