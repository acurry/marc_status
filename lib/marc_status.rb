require 'timeout'
require 'faraday'

module MarcStatus
  ###############
  ## CONSTANTS ##
  ###############
  VERSION = '0.1.0'.freeze

  BASE_URL = 'http://www.marctracker.com'.freeze
  STATUS_URL_FRAGMENT = '/PublicView/status.jsp'.freeze

  LINE_STATUS_INDICES = {
    :camden_north => 1,
    :camden_south => 2,
    :brunswick_west => 3,
    :brunswich_east => 4,
    :penn_north => 5,
    :penn_south => 6
  }.freeze

  MAX_TIMEOUT = 10

  class << self
    # @return [String]
    def as_html(status_url_fragment = STATUS_URL_FRAGMENT)
      html = ''

      Timeout::timeout(MAX_TIMEOUT) do
        response = connection.get(status_url_fragment)
        return response.body.to_s
      end

      html
    end

    def method_missing(method, *args, &block)
      super(method, *args, *block) unless line = respond_to?(method)

      send(:status_for_line, line[1])
    end

    def respond_to?(method, include_private = false)
      /get_(.*)_status/.match(method) || false
    end

    private

    def connection
      @conn ||= Faraday.new(:url => BASE_URL) do |faraday|
        faraday.adapter  Faraday.default_adapter
      end
    end

    def status_for_line(line)
      fragment = "#{STATUS_URL_FRAGMENT}?line=#{LINE_STATUS_INDICES[line.to_sym]}"

      as_html(fragment)
    end
  end
end
