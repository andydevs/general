require "spec_require"

describe Generic::GTemplate do
	before :all do
		@template1 = Generic::GTemplate.new "There once was a man named @(name: Gordon Ramsay). @(name) loves @(food: Cat Food)!"
		@default_text      = "There once was a man named Gordon Ramsay. Gordon Ramsay loves Cat Food!"
		@all_applied_text  = "There once was a man named Joe. Joe loves Joe's Shmoes!"
		@name_applied_text = "There once was a man named Dog. Dog loves Cat Food!"
		@food_applied_text = "There once was a man named Gordon Ramsay. Gordon Ramsay loves Denny's Fennies!"
		@data1 = {name: "Joe", food: "Joe's Shmoes"}
		@name = "Dog"
		@food = "Denny's Fennies"

		@template2 = Generic::GTemplate.new "@[functions] @(type) @(name)(@(arguments)); @[\n]"
		@data2 = {functions: [
			{type: "int", name: "intFunction", arguments: "int arg"},
			{type: "void", name: "voidFunction", arguments: "int arg1, int arg2"}
		]}
		@applied_text2 = "int intFunction(int arg);\nvoid voidFunction(int arg1, int arg2);"
	end

	describe "#new" do
		it "Creates a new GTemplate with the given template string" do
			expect(@template1).to be_an_instance_of Generic::GTemplate
			expect(@template2).to be_an_instance_of Generic::GTemplate
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
				expect(@template2.apply(@data2)).to eql @applied_text2
			end
		end
	end
end