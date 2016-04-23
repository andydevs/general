# Generic
Generic is a simple templating system in ruby. A generic template consists of regular text along with placeholders, which are defined as follows: `@(-name-)`. You can also specify default text as well like so: `@(-name-: -default-)`.

Here's an exmple of a generic template text: `"Hello, I am @(name: Gordon Ramsay), and I like @(food: cat food)!"`

To import the library, type `require 'generic'` as you would for any other gem.

You can then create a generic template from a string within your ruby code like this:

```ruby
template = Generic::GTemplate.new "Hello, I am @(name: Gordon Ramsay), and I like @(food: cat food)!"
```

To generate a string from the template, use the "apply" method and add your data as named arguments.

```ruby
string = template.apply name: "Joe", food: "Joe's Schmoes"

# string now equals "Hello, I am Joe, and I like Joe's Schmoes"
```

If you don't specify a value for a particular placeholder, it will take on it's default value.

```ruby
string = template.apply food: "Joe's Schmoes"

# string now equals "Hello, I am Gordon Ramsay, and I like Joe's Schmoes"
```
