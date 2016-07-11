require 'timeout'

module MarcStatus
  ###############
  ## CONSTANTS ##
  ###############
  BASE_URL = 'http://www.marctracker.com'.freeze
  STATUS_URL_FRAGMENT = '/PublicView/status.jsp'.freeze

  MAX_TIMEOUT = 10

  class Fetch
    attr_writer :url


    ##################
    # CLASS METHODS ##
    ##################

    # @param [String]
    def initialize(url = BASE_URL)
      self.url = url
    end

    # @return [String]
    def as_html(status_url_fragment = STATUS_URL_FRAGMENT)
      html = ''

      Timeout::timeout(MAX_TIMEOUT) do
        response = connection.get(status_url_fragment)
        return response.body.to_s
      end

      html
    end

    private

    def connection
      @conn ||= Faraday.new(:url => self.url) do |faraday|
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
