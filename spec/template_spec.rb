require "spec_require"

describe Generic::Template do
	before :all do
		@template = Generic::Template.new "Hello, my name is @(name: Gordon Ramsay), and I like @(food: Cat Food)!"
		@data = {name: "Joe", food: "Joe's Shmoes"}
		@name = "Dog"
		@food = "my own fucking food"
	end

	describe "#new" do
		it "Creates a new Template with the given template string" do
			expect(@template).to be_an_instance_of Generic::Template
		end
	end

	describe "#apply" do
		context "With no data" do
			it "Returns the template with the default data applied" do
				expect(@template.apply).to eql "Hello, my name is Gordon Ramsay, and I like Cat Food!"
			end
		end

		context "With all data" do
			it "Returns the template with the given data applied" do
				expect(@template.apply(@data)).to eql "Hello, my name is Joe, and I like Joe's Shmoes!"
			end
		end

		context "With only name given" do
			it "Returns the template with the given name and default food applied" do
				expect(@template.apply(name: @name)).to eql "Hello, my name is Dog, and I like Cat Food!"
			end
		end

		context "With only food given" do
			it "Returns the template with the default name and given food applied" do
				expect(@template.apply(food: @food)).to eql "Hello, my name is Gordon Ramsay, and I like my own fucking food!"
			end
		end
	end
end