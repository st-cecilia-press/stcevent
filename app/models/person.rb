class Person < ActiveRecord::Base
  validates :name, presence: true
  has_many :facilitations, dependent: :destroy
  has_many :activities, through: :facilitations

  def title
    name
  end
end
