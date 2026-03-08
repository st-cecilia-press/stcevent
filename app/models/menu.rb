class Menu < ApplicationRecord
  belongs_to :event

  has_many :menu_items, dependent: :destroy
  accepts_nested_attributes_for :menu_items, reject_if: :all_blank, allow_destroy: true

  validates :order, presence: true
  validates_associated :menu_items

  def form_menu_items
    menu_items.sort_by(&:order) + [menu_items.build]
  end
end
