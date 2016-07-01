require "spec_require"

describe General::GTemplate do
	before :all do
		# General template test
		@template1 = General::GTemplate.new "There once was a man named @(name: Gordon Ramsay). @(name) loved @(food: Cat Food)!"
		@default_text      = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Cat Food!"
		@all_applied_text  = "There once was a man named Joe. Joe loved Joe's Shmoes!"
		@name_applied_text = "There once was a man named Dog. Dog loved Cat Food!"
		@food_applied_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Denny's Fennies!"
		@data1 = {name: "Joe", food: "Joe's Shmoes"}
		@name = "Dog"
		@food = "Denny's Fennies"

		# General array template test
		@template2 = General::GTemplate.new "@[greetings] Hello, @(name)! How is the @(pet)? @[\n]"
		@data2 = {greetings: [
			{name: "Ben", pet: "dog"}, 
			{name: "Jen", pet: "cat"},
			{name: "Ken", pet: "plant"}
		]}
		@applied_text2 = "Hello, Ben! How is the dog?\nHello, Jen! How is the cat?\nHello, Ken! How is the plant?"

		@template3 = General::GTemplate.new "@(film: The Dark Knight)\nCrew:\n@[crew] \t@(name): @(role) @[\n]\nScore: @(score)/10"
		@data3 = {
			film: 'Batman Begins',
			crew: [
				{name: 'David S Goyer', role: 'Writer'},
				{name: 'Chris Nolan', role: 'Director'},
				{name: 'Wally Pfister', role: 'Director of Photography'},
				{name: 'Michael Caine', role: 'Alfred Pennyworth'},
				{name: 'Christian Bale', role: 'Bruce Wayne/Batman'}
			],
			score: 10
		}
		@applied_text3 = "Batman Begins\nCrew:\n\tDavid S Goyer: Writer\n\tChris Nolan: Director\n\tWally Pfister: Director of Photography" \
						 "\n\tMichael Caine: Alfred Pennyworth\n\tChristian Bale: Bruce Wayne/Batman\nScore: 10/10"

		# General operations test
		@template4 = General::GTemplate.new "There once was a dog named @(name: dog -> capitalize). @(name -> capitalize) earned @(amount -> dollars) last week."
		@data4 = {name: "cat", amount: 19999}
		@applied_text4 = "There once was a dog named Cat. Cat earned $199.99 last week."
	end

	describe "#new" do
		it "Creates a new GTemplate with the given template string" do
			expect(@template1).to be_an_instance_of General::GTemplate
			expect(@template2).to be_an_instance_of General::GTemplate
			expect(@template3).to be_an_instance_of General::GTemplate
			expect(@template4).to be_an_instance_of General::GTemplate
		end
	end

	describe "#apply" do
		context "With no data" do
			it "Returns the template with the default data applied" do
				expect(@template1.apply).to eql @default_text
			end
		end

		context "With only name given" do
			it "Returns the template with the given name and default food applied" do
				expect(@template1.apply(name: @name)).to eql @name_applied_text
			end
		end

		context "With only food given" do
			it "Returns the template with the default name and given food applied" do
				expect(@template1.apply(food: @food)).to eql @food_applied_text
			end
		end

		context "With all data" do
			it "Returns the template with the given data applied" do
				expect(@template1.apply(@data1)).to eql @all_applied_text
			end
		end

		context "With array template" do
			it "Returns the template with the given array data applied and formatted according to the template" do
				expect(@template2.apply(@data2)).to eql @applied_text2
			end
		end

		context "With array template and regular placeholder" do
			it "Returns the template with the given data applied (including array data) and formatted according to the template" do
				expect(@template3.apply(@data3)).to eql @applied_text3
			end
		end

		context "With placeholder operation" do
			it "Returns the template with the given array data applied and formatted according to the format operations" do 
				expect(@template4.apply(@data4)).to eql @applied_text4
			end
		end
	end
end