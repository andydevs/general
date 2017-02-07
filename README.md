# General

	Hello, I am @(name: gordon ramsay -> capitalize all) and I like @(food: cat food)!

General is a simple templating system in ruby that allows you to create templates from both pure strings and files (with the extension .general), as well as create new strings and files with these created objects.

## Table of Contents

- [General Templates](#general-templates)
	- [Basic Templates](#basic-templates)
	- [Array Templates](#array-templates)
	- [Placeholder Operations](#placeholder-operations)
		- [To-Array Operations](#to-array-operations)
- [General Time Format](#general-time-format)
- [General IO](#general-io)
	- [PrePartials](#prepartials)
		- [Including Other Templates](#including-other-templates)
		- [Extending Templates](#extending-templates)
- [Special Characters](#special-characters)

## General Templates

### Basic Templates

	"Hello, I am @(name: Gordon Ramsay) and I like @(food: cat food)!"

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

### Array Templates

	@[people]
		Hello, @(name)! How's the @(pet)?
	@[\n]

Array templates will format each value in an array of data according to a general template

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

### Placeholder Operations

	@(name -> capitalize all)

You can also specify operations to be performed on values passed to placeholders, akin to AngularJS's filters. For example: `@(name -> capitalize)` will capitalize whatever name is inputted before applying it to the text. Placeholder operations also have arguments, which change behaviour. `@(name -> capitalize first)` will capitalize the first word of name, whereas `@(name -> capitalize all)` will capitalize all words in the name.

- capitalize: capitalizes the string
	- Argument 1:
		- 'first': only first word is capitalized
		- 'all': all words are capitalized
		- default: 'first'
- uppercase: converts a string to uppercase
- lowercase: converts a string to lowercase
- money: converts an integer to a monetary amount in the given format
	- Argument 1:
		- 'USD': United States Dollar
		- 'EUR': European Euro
		- default: 'USD'
- time: converts an integer to a formatted time in the given time format
	- Argument 1:
		- Time format to set to
		- default: '@I:@MM:@SS @A'

#### To-Array Operations

	@[groceries -> split]
		I need to get some @#!
	@[\n].

Certain operations can convert data values to arrays to be used by an array template. These can be applied to array placeholders as follows `@[text -> split] -general- @[].` These return pure data values, and they can be accessed by a special placeholder `@#` which applies the entire data value as is.

```ruby
template = General::GTemplate.new "@[text -> split] -> @# @[\n]"
string = template.apply text: "Good Afternoon World
I am Chef Gordon Ramsay"

# string now equals
# "-> Good Afternoon World
# -> I am Chef Gordon Ramsay"
```

- split: splits a string based on a given delimeter
	- Argument 1:
		- The delimeter regex to split the string by
		- default: \r?\n
- splitwords: splits a string at a given number of words
	- Argument 1:
		- The words at which to split the string
		- default: 10

## General Time Format

General offers a separate special template called a GTimeFormat used for formatting times. The GTimeFormat syntax is also used by the time operation. 

Time format placeholders are written as an @ followed by one or more characters of the same letter: `@LL...` (except for `@A`) The letter indicates the part of time information to format and the number of letters indicates the number of zeros.

| Letter |       Description       |
|:-------|:------------------------|
| @H...  | Hour (0 to 23)          |
| @I...  | Time interval (1 to 12) |
| @M...  | Minutes (0 to 59)       |
| @S...  | Seconds (0 to 59)       |
| @A     | AM/PM                   |

## General IO

You can also write to files using GIO, a general template capable of writing to files. You can create a GIO like a GTemplate:

```ruby
gio = General::GIO.new "Hello, I am @(name: Gordon Ramsay) and I like @(food: cat food)!"
```

You can also load a GIO from a file. For example, here's how you create a template file from the file "example.general"

```ruby
gio = General::GFile.load "example.general"
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
gio.source # == "example.general"
```

### PrePartials

	@@extend basic_layout
	@@include header

	<p>I am a subtemplate! My name is @(name -> capitalize all)</p>

PrePartials are parsed before the general template is parsed, and perform file template manipulation like including or extending another template.

#### Including Other Templates

File to include

	@(title)
	@(author)
	@(subject)
	@(date)

Including file

	@@include file

	@(content)

Resulting File

	@(title)
	@(author)
	@(subject)
	@(date)

	@(content)

To include another template file in your file, you use `@@include [name of template]` (excluding the suffix). This will read the corresponding template file and append the content in place of the `@@include`.

NOTE: `@@include` requires a new line or carriage return to be parsed (it takes up one entire line). It also appends a newline at the end of the included template.

#### Extending Templates

File to Extend
	
	<!doctype html>
	<html>
	<title>@(title -> capitalize all)</title>
	<body>
	@@yield
	</body>
	</html>

Extending File

	@@extend file

	<h1>@(name)'s Profile!</h1>
	<p>Favorite Color: @(color)</p>
	<p>Favorite Sport: @(sport)</p>

Resulting File

	<!doctype html>
	<html>
	<title>@(title -> capitalize all)</title>
	<body>
	<h1>@(name)'s Profile!</h1>
	<p>Favorite Color: @(color)</p>
	<p>Favorite Sport: @(sport)</p>
	</body>
	</html>

Extending a file wraps the contents of the file around the current template. This is good when many templates will share a single common layout. Extend prepartials are as follows `@@extend [name of template]` (also excluding extension). The `@@extend` must be defined at the beginning of the template, and there can be only one `@@extend` in any template.

The extending file should define a `@@yield` where the file will be extended from. This is by default at the end of the file. Note that if `@@yield` is defined in a template, the template is considered a meta-template and cannot be parsed. Also, like extend, only one `@@yield` statement can be defined in a single file.

## Special Characters

Special characters can be entered into general using the format `@[code];`. The table of codes are below:

| Code | Character |
|:----:|:---------:|
|  at  |     @     |
|  pd  |     #     |
|  lt  |     <     |
|  gt  |     >     |
|  op  |     (     |
|  cp  |     )     |
|  ob  |     [     |
|  cb  |     ]     |
|  oc  |     {     |
|  cc  |     }     |
|  ms  |     -     |
|  ps  |     +     |
|  st  |     *     |
|  pc  |     %     |
|  bs  |     \     |
|  fs  |     /     |
|  dl  |     $     |


## Notes

Regex and matching have now been officially depricated, and will be removed in General 2.1.0.

-------------------------------------------------------------------------------------------------------------------------------------
Anshul Kharbanda