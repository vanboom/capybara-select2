# Capybara::Select2

This gem allows you to set the value of select form elements when using the select2 control.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'capybara-select2', group: :test
```

Or, add it into your test group

``` ruby
group :test do
  gem 'capybara-select2'
  ...
end
```

And then execute:

``` bash
$ bundle
```

Or install it yourself as:

``` bash
$ gem install capybara-select2
```

The gem automatically hook itself into rspec helper using Rspec.configure.

If you're using capybara outside of Rspec, you may have to include the following (eg: in `features/support/env.rb` for Cucumber users):

``` ruby
include Capybara::Select2
```

## Usage (Vanboom Rewrite)

Just use this method inside your capybara test:

``` ruby
select2( "Value to Select", from: "#id_of_select", :search=>"Value to use in search (AJAX only)")
```

> The :search term is not needed if the select is pre-populated with options.  Use :search to trigger searches when using an AJAX data source.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
