require 'timeout'
require 'faraday'
require 'nokogiri'

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

  LINE_CLASS_SELECTOR = 'textStatusLine'.freeze
  LINE_TRAIN_STATUS_CLASS_SELECTOR = 'textStatusAll'.freeze

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


    #
    # Given raw HTML and a line, i.e. :camden_north,
    # find xpath <tr> rows with raw train info for each active train
    # on that line.
    # @param html [String] raw HTML from a MARC status page
    # @param line [String/Symbol] the MARC train line to find, i.e.,
    # :camden_north or 'camden_north'
    #
    # @return [Nokogiri::XML::NodeSet]
    def find_line_train_statuses(line, html = as_html)
      display_line = format_line(line)

      n = Nokogiri::HTML(html)

      status_rows_xpath =
        "//td[contains(@class, '#{LINE_CLASS_SELECTOR}') and contains(., '#{display_line}')]" /
        "/parent::tr/following-sibling::tr[contains(@class, '#{LINE_TRAIN_STATUS_CLASS_SELECTOR}')]"

      n.xpath(status_rows_xpath)
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

    #
    # Convert a line as as ymbol to the format found in the actual MARC status page.
    # @param line [Symbol] the line as a symbol, i.e., :camden_north
    #
    # @return [String] the line in display format, i.e., 'CAMDEN NORTH'
    def format_line(line)
      line.to_s.upcase.gsub('_', ' ')
    end
  end
end
