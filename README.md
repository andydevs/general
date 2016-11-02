# General

## Overview

General is a simple templating system in ruby that allows you to create templates from both pure strings and files (with the extension .general), as well as create new strings and files with these created objects.

## General Templates

### Basic Templates

A general template consists of regular text along with placeholders, which are defined as follows: `@(-name-)`. You can also specify default text as well like so: `@(-name-: -default text-)`.

Here's an exmple of a general template text: `"Hello, I am @(name: Gordon Ramsay) and I like @(food: cat food)!"`

To import all classes in the library, type `require 'general'`. You can then create a general template from a string within your ruby code using the GTemplate object:

```ruby
template = General::GTemplate.new "Hello, I am @(name: Gordon Ramsay) and I like @(food: cat food)!"
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

If you have an array of data, you can use `apply_all` to apply the template to each individual element separately.

```ruby
array = template.apply_all [{name: "Joe", food: "Joe Schmoes"}, {name: "Jane", food: "Jane's Danes"}, {name: "Denny", food: "Denny's Fennies"}]

#array now has these elements:
#   - Hello, I am Joe and I like Joe's Schmoes
#   - Hello, I am Jane and I like Jane's Danes
#   - Hello, I am Denny and I like Denny's Fennies
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
| time       | Formats an integer time (in seconds) to HH:MM:SS format |

### Array Templates

You can also make array templates within templates, which will format each value in an array of data according to a general template

A general array template is as follows: `@[-name-] -general template for each value- @[]`. You can also specify the delimeter, which will be appended to the end of each element. The delimeter should be added in the end tag, like so: `@[-name-] -general template for each value- @[-delimeter-]`. If no delimeter is given, the default is a space. The start and end tags are invariant with atleast 1 whitespace or newline. So you can also define the template like such: 

```
@[-name-]
-general template for each value-
@[-delimeter-]
```

An example of an array template:

```ruby
template = General::GTemplate.new \
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

## General IO

You can also write to files using io GIO, a general template capable of writing to files. You can create a GIO like a GTemplate:

```ruby
gio = General::GIO.new "Hello, I am @(name: Gordon Ramsay) and I like @(food: cat food)!"
```

You can also load a GIO from a file. For example, here's how you create a template file from the file "example.txt.general"

```ruby
gio = General::GFile.load "example.txt.general"
```

To write to a file, simply call the write method, pass in the file and the data to apply (like in GTemplate#apply):

```ruby
gio.write file, name: "Joe", food: "Joe's Schmoes"
```

Where `file` is the file you are writing to. You can also pass the name of the file to write to as well:

```ruby
gio.write "example.txt", name: "Joe", food: "Joe's Schmoes"
```

To get the original source filename of the GIO, just call `source`

```ruby
gio.source # == "example.txt.general"
```

-------------------------------------------------------------------------------------------------------------------------------------
Anshul Kharbanda