module ApplicationHelper
  def concat_address(address)
    "#{address.street_address}, #{address.barangay.name}, #{address.city.name}, #{address.province.name}, #{address.region.name}"
  end
  def conceal_email(email)
    email[2..-3] = '*' * (email.size-4)
    email
  end
end
