==title==
Add a Bootstrap datetime picker to your forms.

==author==
Alan Vardy

==footer==


==description==
Get up and running with a datetime picker

==tags==
bootstrap,ruby,rails,sass

==body==
Install [Bootstrap](https://github.com/twbs/bootstrap-rubygem), [Simple-form](https://github.com/plataformatec/simple_form), [Font-awesome](https://github.com/FortAwesome/font-awesome-sass), and [Effective\_form\_inputs](https://github.com/code-and-effect/effective_form_inputs)

Add your gems

```ruby
# Gemfile

gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'
gem 'simple_form'
gem 'font-awesome-sass', '~> 5.8.1'
gem 'effective_form_inputs'
```

Add the following to your application.scss

```css
@import "bootstrap";
@import "font-awesome-sprockets";
@import "font-awesome";
@import "effective_form_inputs";
```

Add the following to your application.js

```js
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require effective_form_inputs
```

Install Simple-form

```bash
rails generate simple_form:install --bootstrap
```

For this example I will use the Event model which already has a time attribute.

Store the js_input options in Event.rb. Here I have set the datetime format and overwritten the default paid FontAwesome icons with a free set. [Check out the format syntax here](https://momentjs.com/docs/#/displaying/)

```ruby
# event.rb

  DATEPICKER_JS = {
    format: 'YYYY-MM-DD HH:mm',
    showTodayButton: true,
    icons: {
      time: 'fa fa-clock-o',
      date: 'fa fa-calendar',
      up: 'fa fa-arrow-up',
      down: 'fa fa-arrow-down',
      previous: 'fa fa-chevron-left',
      next: 'fa fa-chevron-right',
      today: 'fa fa-calendar-check-o',
      clear: 'fa fa-delete',
      close: 'fa fa-times'
    }
  }
```

Finally, use the following code for your form field

```ruby
<%= f.input :time, as: :effective_date_time_picker, input_js: Event::DATEPICKER_JS %>
```
