class Address < ApplicationRecord
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
  
  validate :limit_address_to_five, on: :create


  enum genre: [:home, :office]

  def prevent_default_destroy
    if is_default
      errors.add(:base, "default can't be destroy")
      throw(:abort)
    end
  end

  def make_first_entry_default
    unless self.user.addresses.present?
      self.is_default = true
    end
  end

  def allow_one_default_address
    if is_default
      self.user.addresses.where("id != ?", self.id).update_all(is_default: false)
    end
  end

  def limit_address_to_five
    return unless self.user
    if self.user.addresses.reload.count > 4
      errors.add(:base, "You reach the limit")
    end
  end
end
