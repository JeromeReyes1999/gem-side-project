class PhLocationService
  attr_reader :url

  def initialize
    @url = 'https://psgc.gitlab.io/api'
  end

  def get_regions
    response = RestClient.get("#{url}/regions")
    regions = JSON.parse(response.body)
    regions.each do |region|
      Region.find_or_create_by(code: region['code'], name: region['name'], region_name: region['regionName'])
    end
  end

  def get_provinces
    response = RestClient.get("#{url}/provinces")
    provinces = JSON.parse(response.body)
    provinces.each do |province|
      region = Region.find_by_code(province['regionCode'])
      Province.find_or_create_by(code: province['code'], name: province['name'], region: region)
    end

    response = RestClient.get("#{url}/districts")
    districts = JSON.parse(response.body)
    districts.each do |district|
      region = Region.find_by_code(district['regionCode'])
      Province.find_or_create_by(code: district['code'], name: "Metro Manila-#{district['name']}", region: region)
    end
  end

  def get_cities
    response = RestClient.get("#{url}/cities-municipalities")
    cities = JSON.parse(response.body)
    cities.each do |city|
      if city['provinceCode']
        province = Province.find_by_code(city['provinceCode'])
      elsif city['districtCode']
        province = Province.find_by_code(city['districtCode'])
      else
        if city['name'] == "City of Isabela"
          province = Province.find_by_name('Basilan')
        elsif city['name'] == "City of Cotabato"
          province = Province.find_by_name('Maguindanao')
        end
      end
      City.find_or_create_by(code: city['code'], name: city['name'], province: province)
    end
  end


  def get_barangays
    response = RestClient.get("#{url}/barangays")
    barangays = JSON.parse(response.body)
    barangays.each do |barangay|
      if barangay['cityCode']
        city = City.find_by_code(barangay['cityCode'])
      else
        city = City.find_by_code(barangay['municipalityCode'])
      end
      Barangay.find_or_create_by(code: barangay['code'], name: barangay['name'], city: city)
    end
  end
end