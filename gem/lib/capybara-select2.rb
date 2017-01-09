require "capybara-select2/version"
require 'capybara/selectors/tag_selector'
require 'rspec/core'

module Capybara
  module Select2
    def select2(search, options = {})
      raise "Must pass a hash containing 'from' or 'xpath' or 'css'" unless options.is_a?(Hash) and [:from, :xpath, :css].any? { |k| options.has_key? k }

      if options.has_key? :xpath
        select2_container = find(:xpath, options[:xpath])
      elsif options.has_key? :css
        select2_container = find(:css, options[:css])
      else
        select_name = options[:from]
        select2_container = find("label", text: select_name).find(:xpath, '..').find(".select2-container")
      end

      value = options[:value]

      # Open select2 field
      select2_container.click

      if options.has_key? :search
        find("input.select2-search__field").set(search)
        #page.execute_script(%|$("input.select2-search__field:visible").keyup();|)
      end

      [value].flatten.each do |value|
        # select2 version 4.0
        find(:xpath, "//body").find(".select2-dropdown li.select2-results__option", text: value).click
      end
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::Select2
  config.include Capybara::Selectors::TagSelector
end
