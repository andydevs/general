require "spec_require"

describe Generic::GTemplate do
	before :all do
		@template = Generic::GTemplate.new "There once was a man named @(name: Gordon Ramsay). @(name) loves @(food: Cat Food)!"
		@default_text      = "There once was a man named Gordon Ramsay. Gordon Ramsay loves Cat Food!"
		@all_applied_text  = "There once was a man named Joe. Joe loves Joe's Shmoes!"
		@name_applied_text = "There once was a man named Dog. Dog loves Cat Food!"
		@food_applied_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loves his own fucking food!"
		@data = {name: "Joe", food: "Joe's Shmoes"}
		@name = "Dog"
		@food = "his own fucking food"
	end

	describe "#new" do
		it "Creates a new GTemplate with the given template string" do
			expect(@template).to be_an_instance_of Generic::GTemplate
		end
	end

	describe "#apply" do
		context "With no data" do
			it "Returns the template with the default data applied" do
				expect(@template.apply).to eql @default_text
			end
		end

		context "With all data" do
			it "Returns the template with the given data applied" do
				expect(@template.apply(@data)).to eql @all_applied_text
			end
		end

		context "With only name given" do
			it "Returns the template with the given name and default food applied" do
				expect(@template.apply(name: @name)).to eql @name_applied_text
			end
		end

		context "With only food given" do
			it "Returns the template with the default name and given food applied" do
				expect(@template.apply(food: @food)).to eql @food_applied_text
			end
		end
	end
end