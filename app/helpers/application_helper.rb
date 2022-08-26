module ApplicationHelper
  def concat_address(address)
    "#{address.street_address}, #{address.barangay.name}, #{address.city.name}, #{address.province.name}, #{address.region.name}"
  end
end
