# HTMX for Rails

Add support for partial responses for HTMX in Ruby on Rails controllers.


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rails-htmx


## Installing HTMX

### Via CDN

Add the script to your application.html.erb layout file:

```html
<script src="https://unpkg.com/htmx.org@1.9.2" integrity="sha384-L6OqL9pRWyyFU3+/bjdSri+iIphTN/bvYyM37tICVyOJkWZLpP2vGn6VUEXgzg6h" crossorigin="anonymous"></script>
```

### Using a JS Bundler (e.g jsbundling-rails or webpacker)

Add the htmx.org package using Yarn:

```bash
yarn add htmx.org
```

### Using Import Maps (e.g importmap-rails)

Pin the dependency to the into the importmap:

```bash
bin/importmap pin htmx.org
```


Note: You might want to disable Turbo (and turbo-rails) if your application has it
already installed.


## Usage

By default, the `rails-htmx` prvents the rendering of your application layout in
your controllers and will instead only return the yielded view when the
`HX-Request` header is present in the requests.


## Preventing HTMX requests

In certain cases might want to return a full view (e.g in a login page) instead
of a partial yielded view, you can do this calling the prevent_htmx!
method in your controller actions or in an callback:

```ruby
  before_action :prevent_htmx!, if: -> { some_condition? }

  def login
    prevent_htmx!
    # ...
  end
```

## Layouts

If you have additional content you want to always be returned with your htmx requests,
you can override `htmx_layout` in your controller and specify a layout to render
(by default, it's `false`)

```ruby
class ApplicationController < ActionController::Base
  def htmx_layout
    'htmx'
  end
end
```


## License
htmx_rails is released under the [MIT License](https://opensource.org/license/mit/).
