# General is a templating system in ruby
# Copyright (C) 2016  Anshul Kharbanda
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "spec_require"

# Describe General::GTemplate
#
# Implements the general templating system for strings
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
describe General::GTemplate do
	# Before all
	before :all do
		class Person
			def initialize nam, food
				@name = nam
				@food = food
			end
			def generalized
				{name: @name, 
				food: @food}
			end
		end

		@template1  = General::GTemplate.new "There once was a man named @(name: Gordon Ramsay). @(name) loved @(food: Cat Food)!"
		@template2  = General::GTemplate.new "@(user)@at;@(domain)"
		@template3  = General::GTemplate.new "@[greetings] Hello, @(name)! How is the @(pet)? @[\n]"
		@template4  = General::GTemplate.new "@(film: The Dark Knight)\nCrew:\n@[crew] \t@(name): @(role) @[\n]\nScore: @(score)/10"
		@template5  = General::GTemplate.new "There once was a dog named @(name: dog -> capitalize). @(name -> capitalize) earned @(amount -> money) last week."
		@template6  = General::GTemplate.new "There once was a cat named @(name -> capitalize all)."
		@template7  = General::GTemplate.new "The time is @(time -> time). It may also be formatted as @(time -> time '@SS <- @MM <- @HH')"
		@template8  = General::GTemplate.new "The name's @(name.last)... @(name.first) @(name.last)."
		@template9  = General::GTemplate.new "My favorite color is @#!"
		@template10 = General::GTemplate.new "@[list -> split] Need @#! @[\n]"
	end

	# Describe General::GTemplate::new
	#
	# Creates a GTemplate with the given template string
	#
	# Parameter: string - the string being converted to a template
	describe "::new" do
		it "creates a new GTemplate with the given template string" do
			[@template1, @template2, @template3, @template4, @template5, 
			 @template6, @template7, @template8, @template9, @template10]
			.each do |template|
				expect(template).to be_an_instance_of General::GTemplate
			end
		end
	end

	# Describe General::GTemplate#apply
	#
	# Applies the given data to the template and returns the generated string
	#
	# Parameter: data - the data to be applied (as a hash. merges with defaults)
	#
	# Return: string of the template with the given data applied
	describe "#apply" do
		# ---------------------------------------------DATA----------------------------------------------
		before :all do
			# -------------------------------------BASIC PLACEHOLDER-------------------------------------
			@data1 = {name: "Joe", food: "Joe's Shmoes"}
			@name  = "Dog"
			@food  = "Denny's Fennies"

			@default_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Cat Food!"
			@name_text = "There once was a man named Dog. Dog loved Cat Food!"
			@food_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Denny's Fennies!"
			@all_text = "There once was a man named Joe. Joe loved Joe's Shmoes!"

			# ------------------------------------SPECIAL CHARACTERS------------------------------------
			@data2 = { user: "hillary", domain: "clinton.org" }
			@text2 = "hillary@clinton.org"

			# --------------------------------------ARRAY TEMPLATE--------------------------------------
			@data3 = {
				greetings: [
					{name: "Ben", pet: "dog"}, 
					{name: "Jen", pet: "cat"},
					{name: "Ken", pet: "plant"}
				]
			}
			@text3 = "Hello, Ben! How is the dog?\nHello, Jen! How is the cat?\nHello, Ken! How is the plant?"

			@data4 = {
				film: 'Batman Begins',
				crew: [
					{name: 'David S. Goyer', role: 'Writer'},
					{name: 'Chris Nolan',    role: 'Director'},
					{name: 'Wally Pfister',  role: 'Director of Photography'},
					{name: 'Michael Caine',  role: 'Alfred Pennyworth'},
					{name: 'Christian Bale', role: 'Bruce Wayne/Batman'}
				],
				score: 10
			}
			@text4 = "Batman Begins\nCrew:\n\tDavid S. Goyer: Writer\n\tChris Nolan: Director\n\tWally Pfister: Director of Photography" \
							 "\n\tMichael Caine: Alfred Pennyworth\n\tChristian Bale: Bruce Wayne/Batman\nScore: 10/10"

			# ---------------------------------------OPERATIONS-----------------------------------------
			@data5 = {name: "cat", amount: 19999}
			@text5 = "There once was a dog named Cat. Cat earned $199.99 last week."

			@data6 = {name: "joe schmoe"}
			@text6 = "There once was a cat named Joe Schmoe."

			hrs = 3
			min = 14
			sec = 12
			pm = true

			@data7 = {
				time: ( ((pm ? 11 : 0) + hrs)*3600 + min*60 + sec )
			}

			@text7 = "The time is #{hrs}:#{min.to_s.rjust(2,'0')}:#{sec.to_s.rjust(2,'0')} #{pm ? 'PM' : 'AM'}. " \
					"It may also be formatted as #{sec.to_s.rjust(2,'0')} <- #{min.to_s.rjust(2,'0')} <- #{((pm ? 11 : 0) + hrs).to_s.rjust(2,'0')}"

			# --------------------------------------DOT NOTATION----------------------------------------
			@data9 = General::GDotHash.new name: {first: "Gordon", last: "Ramsay"}
			@text9 = "The name's Ramsay... Gordon Ramsay."

			# ------------------------------------FULL PLACEHOLDER--------------------------------------
			@data10 = "Gilbert"
			@text10 = "My favorite color is Gilbert!"

			# -----------------------------------TO-ARRAY OPERATION-------------------------------------
			@data11 = {list: "Butter\nMilk\nEggs"}
			@text11 = "Need Butter!\nNeed Milk!\nNeed Eggs!"

			# ----------------------------------GENERALIZED INTERFACE-----------------------------------
			@data12 = Person.new "Joe", "Joe's Schmoes"
			@text12 = "There once was a man named Joe. Joe loved Joe's Schmoes!"
		end

		# ---------------------------------------------TEST----------------------------------------------

		it "returns the template with data/defaults applied to corresponding placeholders" do
			expect(@template1.apply).to eql @default_text
			expect(@template1.apply name: @name).to eql @name_text
			expect(@template1.apply food: @food).to eql @food_text
			expect(@template1.apply @data1).to eql @all_text
		end

		it 'formats special @; characters appropriately' do
			expect(@template2.apply @data2).to eql @text2
		end

		it "formatts array data according to array templates" do
			expect(@template3.apply @data3).to eql @text3
			expect(@template4.apply @data4).to eql @text4
		end

		it 'formats data according to given placeholder operations and arguments (if given)' do
			expect(@template5.apply @data5).to eql @text5
			expect(@template6.apply @data6).to eql @text6
			expect(@template7.apply @data7).to eql @text7
		end

		it "applies data appropriately to dot notation placeholders" do 
			expect(@template8.apply @data9).to eql @text9
		end

		it "applies full data to full placeholders" do 
			expect(@template9.apply @data10).to eql @text10
		end

		it "formats array data generated by to-array operations according to array template" do 
			expect(@template10.apply @data11).to eql @text11
		end

		it "returns the template with the generalized data from object applied appropriately" do 
			expect(@template1.apply @data12).to eql @text12
		end
	end

	# Describe General::GTemplate#apply_all
	#
	# Applies each data structure in the array independently to the template
	# and returns an array of the generated strings
	#
	# Parameter: array - the array of data to be applied 
	# 				     (each data hash will be merged with defaults)
	#
	# Return: array of strings generated from the template with the given 
	# 		  data applied
	describe '#apply_all' do
		before :all do
			@data5 = [
				{name: "Joe",   food: "Joe's Schmoes"},
				{name: "Jane",  food: "Jane's Danes"},
				{name: "Denny", food: "Denny's Fennies"}
			]

			@text5 = [
				"There once was a man named Joe. Joe loved Joe's Schmoes!",
				"There once was a man named Jane. Jane loved Jane's Danes!",
				"There once was a man named Denny. Denny loved Denny's Fennies!"	
			]
		end

		it 'applies all the values in the data array individually' do
			expect(@template1.apply_all @data5).to eql @text5
		end
	end

	# Describe General::GTemplate#regex
	# 
	# Returns the string as a regex
	#
	# Parameter: sub - true if the template is part of array template
	#
	# Returns: the string as a regex
	describe '#regex' do
		before :all do
			@regex1 = /\AThere once was a man named (?<name>.*)\. \k<name> loved (?<food>.*)!\z/
			@sub_regex1 = "There once was a man named (?<name>.*)\\. \\k<name> loved (?<food>.*)!"
		end

		it 'returns the regex created from the GTemplate if template is not part of array template' do
			expect(@template1.regex).to eql @regex1
		end

		it 'returns the sub regex string created from the GTemplate if template is part of array template' do
			expect(@template1.regex true).to eql @sub_regex1
		end
	end

	# Describe General::GTemplate#match
	#
	# Matches the given string against the template and returns the 
	# collected information. Returns nil if the given string does 
	# not match.
	#
	# If a block is given, it will be run with the generated hash
	# if the string matches. Alias for:
	# 
	# if m = template.match(string)
	# 	 # Run block
	# end
	# 
	# Parameter: string the string to match
	# 
	# Return: Information matched from the string or nil
	describe '#match' do
		it 'returns the data generated from the string when the given string matches the template regex' do
			expect(@template1.match @all_text).to eql @data1
		end

		it 'returns nil when the given string does not match the template regex' do
			expect(@template1.match "").to be_nil
		end

		it 'passes the hash to a block if given' do
			expect { 
				@template1.match @all_text do |hash|
					expect(hash).to eql @data1
				end
			}.not_to raise_error
		end
	end
end
