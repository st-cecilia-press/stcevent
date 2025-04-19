# XXX: We might regret this later.
class Facilitation < ActiveRecord::Base
  belongs_to :person
  belongs_to :activity
  has_one :event, through: :activity

  validates :person, presence: true
  validates :activity, presence: true
end
