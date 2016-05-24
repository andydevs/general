require "spec_require"

describe Generic::GTemplate do
	before :all do
		@template1 = Generic::GTemplate.new "There once was a man named @(name: Gordon Ramsay). @(name) loved @(food: Cat Food)!"
		@default_text      = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Cat Food!"
		@all_applied_text  = "There once was a man named Joe. Joe loved Joe's Shmoes!"
		@name_applied_text = "There once was a man named Dog. Dog loved Cat Food!"
		@food_applied_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loved Denny's Fennies!"
		@data1 = {name: "Joe", food: "Joe's Shmoes"}
		@name = "Dog"
		@food = "Denny's Fennies"

		@template2 = Generic::GTemplate.new "@[greetings] Hello, @(name)! How is the @(pet)? @[\n]"
		@data2 = {greetings: [
			{name: "Joe", pet: "cat"},
			{name: "Ben", pet: "dog"}, 
			{name: "Ken", pet: "plant"}
		]}
		@applied_text2 = "Hello, Joe! How is the cat?\nHello, Ben! How is the dog?\nHello, Ken! How is the plant?"

		@template3 = Generic::GTemplate.new "There once was a dog named @(name: dog -> capitalize). @(name -> capitalize) earned @(amount -> dollars) last week."
		@data3 = {name: "cat", amount: 19999}
		@applied_text3 = "There once was a dog named Cat. Cat earned $199.99 last week."
	end

	describe "#new" do
		it "Creates a new GTemplate with the given template string" do
			expect(@template1).to be_an_instance_of Generic::GTemplate
			expect(@template2).to be_an_instance_of Generic::GTemplate
			expect(@template3).to be_an_instance_of Generic::GTemplate
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

		context "With placeholder operation" do
			it "Returns the template with the given array data applied and formatted according to the format operations" do 
				expect(@template3.apply(@data3)).to eql @applied_text3
			end
		end
	end
end