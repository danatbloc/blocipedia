class Collaborator < ApplicationRecord
  belongs_to :user
  belongs_to :wiki

  validates_presence_of :user_id, :wiki_id
end
