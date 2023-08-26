# htmx for Rails

Add support for partial responses for htmx in Ruby on Rails controllers.

![fullstack-1](https://github.com/guilleiguaran/rails-htmx/assets/160941/8b9307af-111a-4af0-92de-218aac07797f)


## Installation

Install the gem and add it to the application's Gemfile by executing:

    $ bundle add rails-htmx


## Installing htmx

Providing the assets for htmx is out of the scope of this library and
the assets gems have been deprecated (along with Sprockets) by Rails.

Note: You might want to disable Turbo (and turbo-rails) if your application has it
already installed.

Instead is recommended to install htmx from the official sources:

### Via CDN

Add the script to your application.html.erb layout file:

```html
<script src="https://unpkg.com/htmx.org@1.9.5" integrity="sha384-xcuj3WpfgjlKF+FXhSQFQ0ZNr39ln+hwjN3npfM9VBnUskLolQAcN80McRIVOPuO" crossorigin="anonymous"></script>
```

Check the [htmx docs](https://htmx.org/docs/#installing) to make sure that you're using the latest
version of the package

### Using a JS Bundler (e.g jsbundling-rails or webpacker)

Add the htmx.org package using Yarn:

```bash
yarn add htmx.org
```

and then import it on your `app/javascript/application.js`:

```javascript
import "htmx.org"
```

### Using Import Maps (e.g importmap-rails)

Pin the dependency to the into the importmap:

```bash
bin/importmap pin htmx.org
```

and then import it on your `app/javascript/application.js`:

```javascript
import "htmx.org"
```

## Usage

By default, the `rails-htmx` prevents the render of the application layout in
your controllers and instead returns only the yielded view for the
requests that have the `HX-Request` header present.

Additionally, `rails-htmx` modify redirects in non-GET and non-POST requests to
return 303 (See Other) as status code instead of 302 to handle XHR redirects correctly.

For more information about how to use htmx please consult the [htmx docs](https://htmx.org/docs/).

### Preventing htmx requests

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

### Custom Layouts

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

### The `hx` helper for views.

You can use the `hx` helper to simplify the generation of the attributes
in your views, e.g:

```erb
<%= button_to "Update post", @post, method: :delete, data: { "hx-patch": url_for(@post), "hx-swap": "outerHTML", "hx-target": "body" } %>
```

can be rewritten using the `hx` helper:

```erb
<%= button_to "Update post", @post, method: :delete, data: hx(patch: url_for(@post), swap: "outerHTML", target: "body") %>
```


## Tips

Those are some tips for using htmx with Rails.

### Add the CSRF Token to the htmx requests

Add the `X-CSRF-Token` to the `hx-headers` attributes in your `<body>` tag so it's added by
default in XHR requests done by htmx:

```erb
<body hx-headers='{"X-CSRF-Token": "<%= form_authenticity_token %>"}'>
```

### Using the data prefix

You can use the `data-` prefix to make easier adding the htmx attributes with the Rails helpers:

```erb
<%= link_to "Home", root_path, data: { "hx-swap": "outerHTML" } %>
```

### Boosting Rails helpers

You can use the default Rails helpers without modifications in your markup with the htmx
[Boosting feature](https://htmx.org/docs/#boosting):

```erb
<div hx-boost="true">
  <%= link_to "New post", new_post_path %>
</div>
```

### Redirect after PUT/PATCH/DELETE (30x status)

Add the `hx-target="body"`, `hx-swap="outerHTML"`, and `hx-push-url="true"` to
update the body with the content of the document retrieved after
redirection and push the new URL into the browser location history.

```erb
<%= button_to "Destroy post", @post, method: :delete, data: { "hx-delete": url_for(@post), "hx-swap": "outerHTML", "hx-target": "body" "hx-push-url": "true" } %>
```

### XHR errors handling

by default, non-200 responses are not swapped into the DOM, this
behavior can be changed using one of the next options:

1. Using the [response-targets extension](https://htmx.org/extensions/response-targets/)
   and setting the target for the status code, e.g:

    ```html
    <button hx-post="/register"
            hx-target="#response-div"
            hx-target-5*="#serious-errors"
            hx-target-422="#response-div"
            hx-target-404="#not-found">
        Register!
    </button>
    ```

   or using Rails helpers:

   ```erb
   <%= button_to "Register", register_path, data:
        hx(post: register_path, target: "#response-div", "target-5*": "#serious-errors", "target-422": "#response-div" , "target-404": "#not-found") %>
   ```

   For default Rails forms your might want to set `hx-target-422` to the same value as `hx-target`
   in that way the form will be swapped with the new form with validation error messages.
   Check the extension for more details and examples.

2. Handle the `htmx:beforeSwap` event in order to modify the swap
   behavior:

   ```javascript
   document.body.addEventListener('htmx:beforeSwap', function(evt) {
    if(evt.detail.xhr.status === 404){
        alert("Error: Could Not Find Resource");
    } else if(evt.detail.xhr.status === 422){
        // allow 422 responses to swap as we are using this as a signal that
        // a form was submitted with bad data and want to rerender with the
        // errors
        evt.detail.shouldSwap = true;

        // set isError to false to avoid error logging in console
        evt.detail.isError = false;
    }
   });
   ```

  Check the [htmx docs](https://htmx.org/docs/#modifying_swapping_behavior_with_events) for details


### Using htmx extensions in module environments.

#### importmap-rails

In order to get the extensions working you need to pin the extensions in your `config/importmap.rb`:

```ruby
# config/importmap.rb
# ...
pin "htmx.org", to: "https://unpkg.com/htmx.org@1.9.5"
pin "htmx.org/dist/ext/", to: "https://unpkg.com/htmx.org@1.9.5/dist/ext/"
```

Then you can load extensions in your application.js:

```javascript
// app/javascript/application.js
import "htmx.org"
import "htmx.org/dist/ext/method-override"
import "htmx.org/dist/ext/ajax-header"
```

#### jsbundling-rails

Using rollup does not require any changes.

For esbuild and webpack you need to load `htmx` globally before of importing the extensions, this can be done creating a custom
file and injecting `htmx` to the window scope on it:

```javascript
// app/javascript/application.js
import "./htmx.js"
import "htmx.org/dist/ext/method-override"
import "htmx.org/dist/ext/ajax-header"
```

```javascript
// app/javascript/htmx.js
import htmx from "htmx.org"
window.htmx = htmx
```

## License
rails-htmx is released under the [MIT License](https://opensource.org/license/mit/).
