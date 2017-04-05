require "capybara-select2/version"
require 'capybara/selectors/tag_selector'
require 'rspec/core'
module Capybara
  module Select2
    ##
    # Usage: select2 "TEST1", :from=>'#part_categories', :search=>"TEST1"
    ##
    def select2(value, **options)
      from = options[:from]
      raise "You must specify a CSS ID selector." unless from.present? and from[0] == "#"
      execute_script %| $('#{from}').select2('open'); |
      search = options[:search]
      #first(".select2-search__field").set(search)
      if search.present?
        execute_script %|$("input.select2-search__field:visible").val("#{search}");|
        execute_script %|$("input.select2-search__field:visible").trigger("input");|
        sleep 1
      end

      # the results are in a UL with the id="select2-booking_client_id-results"
      results_container = "#select2-%s-results" % from.gsub('#','')

      # this will cause Capybara to wait for the ajax results
      wait_until{ find(results_container).visible? }
      # check for a nested/grouped value
      # select the last element, because grouped results are nested within an outer li and we want the inner one
      e = all("li", text: /#{Regexp.escape(value)}/).last
      if e.present?
        # click it
        e.trigger('mouseover')
        e.trigger('mouseup')
      else
        raise "%s :value not found" % value
      end
      execute_script %| $('#{from}').select2('close'); |
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::Select2
  config.include Capybara::Selectors::TagSelector
end
