require 'geocoder/results/base'

module Geocoder::Result
  class Here < Base

    ##
    # A string in the given format.
    #
    def address(format = :full)
      address_data['Label']
    end

    ##
    # A two-element array: [lat, lon].
    #
    def coordinates
      fail unless d = @data['Location']['DisplayPosition']
      [d['Latitude'].to_f, d['Longitude'].to_f]
    end

    def state
      address_data['County']
    end

    def province
      address_data['County']
    end

    def postal_code
      address_data['PostalCode']
    end

    def city
      address_data['City']
    end

    def state_code
      address_data['State']
    end

    def province_code
      address_data['State']
    end

    def country
      fail unless d = address_data['AdditionalData']
      if v = d.find{|ad| ad['key']=='CountryName'}
        return v['value']
      end
    end

    def country_code
      address_data['Country']
    end

    def bounding_box
      map_view = data['Location']['MapView'] || fail
      southwest = [
        map_view['BottomRight']['Latitude'],
        map_view['TopLeft']['Longitude']
      ]
      northeast = [
        map_view['TopLeft']['Latitude'],
        map_view['BottomRight']['Longitude']
      ]
      [southwest, northeast]
    end

    private # ----------------------------------------------------------------

    def address_data
      @data['Location']['Address'] || fail
    end
  end
end
