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
		@template1 = General::GTemplate.new "There once was a man named @(name: Gordon Ramsay). @(name) loved @(food: Cat Food)!"
		@template2 = General::GTemplate.new "@(user)\\@@(domain)"
		@template3 = General::GTemplate.new "@[greetings] Hello, @(name)! How is the @(pet)? @[\n]"
		@template4 = General::GTemplate.new "@(film: The Dark Knight)\nCrew:\n@[crew] \t@(name): @(role) @[\n]\nScore: @(score)/10"
		@template5 = General::GTemplate.new "There once was a dog named @(name: dog -> capitalize). @(name -> capitalize) earned @(amount -> dollars) last week."
	end

	# Describe General::GTemplate::new
	#
	# Creates a GTemplate with the given template string
	#
	# Parameter: string - the string being converted to a template
	describe "::new" do
		it "creates a new GTemplate with the given template string" do
			expect(@template1).to be_an_instance_of General::GTemplate
			expect(@template2).to be_an_instance_of General::GTemplate
			expect(@template3).to be_an_instance_of General::GTemplate
			expect(@template4).to be_an_instance_of General::GTemplate
			expect(@template5).to be_an_instance_of General::GTemplate
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
		context 'with a general template' do
			before :all do
				@data1 = {name: "Joe", food: "Joe's Shmoes"}
				@name  = "Dog"
				@food  = "Denny's Fennies"
			end

			context "with no data" do
				before :all do
					@default_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Cat Food!"
				end

				it "returns the template with the default data applied" do
					expect(@template1.apply).to eql @default_text
				end
			end

			context "with partial data" do
				before :all do
					@name_text = "There once was a man named Dog. Dog loved Cat Food!"
					@food_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Denny's Fennies!"
				end

				it "returns the template with the given data applied to corresponding placeholders and default data applied to the rest" do
					expect(@template1.apply name: @name).to eql @name_text
					expect(@template1.apply food: @food).to eql @food_text
				end
			end

			context "with all data" do
				before :all do
					@all_text = "There once was a man named Joe. Joe loved Joe's Shmoes!"
				end

				it "returns the template with the given data applied" do
					expect(@template1.apply @data1).to eql @all_text
				end
			end
		end

		context 'with general @ character' do
			before :all do
				@data2 = { user: "hillary", domain: "clinton.org" }
				@text2 = "hillary@clinton.org"
			end

			it 'returns the templae with the given data applied (including the @ character)' do
				expect(@template2.apply @data2).to eql @text2
			end
		end

		context "with array template" do
			before :all do
				@data3 = {
					greetings: [
						{name: "Ben", pet: "dog"}, 
						{name: "Jen", pet: "cat"},
						{name: "Ken", pet: "plant"}
					]
				}
				@text3 = "Hello, Ben! How is the dog?\nHello, Jen! How is the cat?\nHello, Ken! How is the plant?"
			end

			it "returns the template with the given array data applied and formatted according to the template" do
				expect(@template3.apply @data3).to eql @text3
			end
		end

		context "with array template and regular placeholder" do
			before :all do
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
			end

			it "returns the template with the given data applied (including array data) and formatted according to the template" do
				expect(@template4.apply @data4).to eql @text4
			end
		end

		context "with placeholder operation" do
			before :all do
				@data5 = {name: "cat", amount: 19999}
				@text5 = "There once was a dog named Cat. Cat earned $199.99 last week."
			end

			it "returns the template with the given array data applied and formatted according to the format operations" do 
				expect(@template5.apply @data5).to eql @text5
			end
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
		before(:all) do
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

		context 'if template is not part of array template' do
			it 'returns the regex created from the GTemplate' do
				expect(@template1.regex).to eql @regex1
			end
		end

		context 'if template is part of array template' do
			it 'returns the sub regex string created from the GTemplate' do
				expect(@template1.regex true).to eql @sub_regex1
			end
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
		context 'when the given string matches the template regex' do
			it 'returns the data generated from the string' do
				expect(@template1.match @all_text).to eql @data1
			end
		end

		context 'when the given string does not match the template regex' do
			it 'returns nil' do
				expect(@template1.match "").to be_nil
			end
		end

		context 'with a block given' do
			it 'passes the hash to the given block' do
				expect { 
					@template1.match @all_text do |hash|
						expect(hash).to eql @data1
					end
				}.not_to raise_error
			end
		end
	end
end