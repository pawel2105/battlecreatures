class MxitLocation

    attr_reader :country, :country_name, :principal_subdivision, :principal_subdivision_name, :city, :network_operator_id, :client_features_bitset, :cell_id

    def initialize(location_info)
      @country, @country_name, @principal_subdivision, @principal_subdivision_name,
      @city, @city_name, @network_operator_id, @client_features_bitset, @cell_id =
        location_info.split(',')
    end

end