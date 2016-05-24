# Generic

## Overview

Generic is a simple templating system in ruby. A generic template consists of regular text along with placeholders, which are defined as follows: `@(-name-)`. You can also specify default text as well like so: `@(-name-: -default text-)`. Generic allows you to create templates from both pure strings and files (with the extension .generic), as well as create new strings and files with these created objects.

## Generic Templates

### Basic Templates

Here's an exmple of a generic template text: `"Hello, I am @(name: Gordon Ramsay) and I like @(food: cat food)!"`

To import the library, type `require 'generic'` as you would for any other gem.

You can then create a generic template from a string within your ruby code using the GTemplate object:

```ruby
template = Generic::GTemplate.new "Hello, I am @(name: Gordon Ramsay) and I like @(food: cat food)!"
```

To generate a string from the template, use the "apply" method and add your data as named arguments.

```ruby
string = template.apply name: "Joe", food: "Joe's Schmoes"

# string now equals "Hello, I am Joe and I like Joe's Schmoes"
```

If you don't specify a value for a particular placeholder, it will take on it's default value.

```ruby
string = template.apply food: "Joe's Schmoes"

# string now equals "Hello, I am Gordon Ramsay and I like Joe's Schmoes"
```

### Placeholder Operations

You can also specify operations to be performed on values passed to placeholders, akin to AngularJS's filters. For example: `@(name -> capitalize)` will capitalize whatever name is inputted before applying it to the text.

The current placeholder operations are:

| Operation  |                       Description                       |
|:-----------|:--------------------------------------------------------|
| capitalize | Capitalizes the first letter of each word in a string   |
| uppercase  | Makes every letter in a string uppercase                |
| lowercase  | Makes every letter in a string lowercase                |
| dollars    | Formats an integer money amount (in cents) to dollars   |
| hourminsec | Formats an integer time (in seconds) to HH:MM:SS format |

### Array Templates

You can also make array templates within templates, which will format each value in an array of data according to a generic template

A generic array template is as follows: `@[-name-] -generic template for each value- @[]`. You can also specify the delimeter by adding it in the end tag, like so: `@[-name-] -generic template for each value- @[-delimeter-]`. If no delimeter is given, the default is a space. The start and end tags are invariant with whitespace. So you can also define the template like such: 

```
@[-name-]
-generic template for each value-
@[-delimeter-]
```

An example of an array template:

```ruby
template = Generic::GTemplate.new \
"List of Film Crew:
@[crew] 
	@(name): @(role)
@[\n]"
```

You can now specify an array of values for "crew" in template, and it will format the data accordingly:

```ruby
string = template.apply crew: [
	{name: "Chris Nolan", role: "Director"}, 
	{name: "Wally Pfister", role: "Director of Photography"}, 
	{name: "Christian Bale", role: "Bruce Wayne/Batman"}, 
	{name: "Michael Caine", role: "Alfred Pennyworth"}
]

# string now equals:
# "List of Film Crew:
#  		Chris Nolan: Director
#		Wally Pfister: Director of Photography
#		Christian Bale: Bruce Wayne/Batman
#		Michael Caine: Alfred Pennyworth"
```

## Generic Files

You can also create generic file template from a generic file (these are files with the extension .generic) by using the GFile class. For example, here's how you create a template file from the file "example.txt.generic"

```ruby
file = Generic::GFile.new "example.txt.generic"
```

This file will create a template that can be written to the file "example.txt". To write to the file, simply call:

```ruby
file.write name: "Joe", food: "Joe's Schmoes"
```

You can then call the "write" method with the same data you would pass to the "apply" method in a GTemplate instance, and the file will write the data to the file "example.txt".

You can change the filename and filepath of the generic file by setting the appropriate attributes

```ruby
file.name = "super_example.txt"
file.path = "./tmp"

# generic file will now be written to ./tmp/super_example.txt
```



Anshul Kharbanda
