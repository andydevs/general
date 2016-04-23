# Generic
<p>Generic is a simple templating system in ruby. A generic template consists of regular text along with placeholders. 
A basic placeholder is defined as follows: <code>@(-name-)</code>. You can also specify default text as well like so: <code>@(-name-: -default-)</code>.</p>

<p>Here's an exmple of a generic template text: <code>"Hello, I am @(name: Gordon Ramsay), and I like @(food: cat food)!"</code>.</p>

<p>To import the library, type <code>require 'generic'</code> as you would for any other gem</p>

<p>You can then create a generic template from a string within your ruby code like this:</p>

<pre><code>template = Generic::GTemplate.new "Hello, I am @(name: Gordon Ramsay), and I like @(food: cat food)!"</code></pre>

<p>To generate a string from the template, use the "apply" method and add your data as named arguments.</p>

<pre><code>string = template.apply name: "Joe", food: "Joe's Schmoes"

# string now equals "Hello, I am Joe, and I like Joe's Schmoes"</code></pre>

<p>If you don't specify a value for a particular placeholder, it will take on it's default value.</p>

<pre><code>string = template.apply food: "Joe's Schmoes"

# string now equals "Hello, I am Gordon Ramsay, and I like Joe's Schmoes"</code></pre>
