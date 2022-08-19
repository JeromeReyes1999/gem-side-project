class Address < ApplicationRecord
  LIMIT = 5

  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :is_default, {allow_blank:true}
  validates_presence_of :genre
  validates_presence_of :remark, {allow_blank:true}
  validates :phone_number, phone: true

  belongs_to :user
  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay

  before_create :make_first_entry_default
  before_destroy :prevent_default_destroy
  after_commit :allow_one_default_address
  
  validate :limit_address, on: :create


  enum genre: [:home, :office]

  def prevent_default_destroy
    if is_default
      errors.add(:base, "default can't be destroy")
      throw(:abort)
    end
  end

  def make_first_entry_default
    unless user.addresses.present?
      self.is_default = true
    end
  end

  def allow_one_default_address
    if is_default
      user.addresses.where.not(id: self.id).update_all(is_default: false)
    end
  end

  def limit_address
    if user.addresses.count >= LIMIT
      errors.add(:base, "You reach the limit")
    end
  end
end
