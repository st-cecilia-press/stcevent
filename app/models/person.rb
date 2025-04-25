class Person < ActiveRecord::Base
  validates :name, presence: true
  has_many :facilitations, dependent: :destroy
  has_many :activities, through: :facilitations

  scope :for_event, ->(event_id) do
    joins(:facilitations, :activities).where("activities.event_id" => event_id).distinct
  end

  def title
    name
  end
end
