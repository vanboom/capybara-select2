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
      search_input = from + "-search__field"
      raise "You must specify a CSS ID selector." unless from.present? and from[0] == "#"
      execute_script %| $('#{from}').select2('open'); |
sleep(0.1)
      search = options[:search]
      #first(".select2-search__field").set(search)
      if search.present?
        # type the search term into the search input field
#        fill_in search_input, :with=>search
        execute_script %|$('#{search_input}').val('#{j search}');|
        execute_script %|$('#{search_input}').trigger('input');|
      end
sleep 0.1

      # the results are in a UL with the id="select2-booking_client_id-results"
      results_container = "#select2-%s-results" % from.gsub('#','')

      # this will cause Capybara to wait for the ajax results
      # wait_until{ find(results_container).first('li:not(.loading-results)').present? }
      expect(page).to have_css 'li.select2-results__option:not(.loading-results)'

      # check for a nested/grouped value
      # select the last element, because grouped results are nested within an outer li and we want the inner one
      e = all("li", text: /#{Regexp.escape(value)}/).last
      if e.present?
        # click it
        e.hover
        e.click
      else
        raise "%s :value not found" % value
      end
      #execute_script %| $('#{from}').select2('close'); |
sleep 0.1
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::Select2
  config.include Capybara::Selectors::TagSelector
end
