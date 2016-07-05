require "spec_require"

describe General::GFile do
	before :all do
		@filepath = "exp/sample.txt"
		@new_filepath = "exp/superexp/supersample.txt"
		@data = {name: "joe", food: "Joe's Schmoes"}
		@default_text = "There once was a chef name Gordon Ramsay, and he loved eating carrots."
		@applied_text = "There once was a chef name Joe, and he loved eating Joe's Schmoes."
	end

	before :each do
		@file = General::GFile.new (@filepath + General::GFile::EXTENTION)
	end

	describe "#new" do
		it "Creates a new GFile with the given filename" do
			expect(@file).to be_an_instance_of General::GFile
		end
	end

	describe "#target" do
		it "Returns the name of the target" do
			expect(@file.target).to eql (@filepath)
		end
	end

	describe "#target=" do
		it "Changes the target to the given value" do
			@file.target = @new_filepath
			expect(@file.target).to eql @new_filepath
		end
	end

	describe "#write" do
		context "With no data" do
			it "Writes the default data to the target file" do
				@file.write
				expect(IO.read(@file.target)).to eql @default_text
			end
		end

		context "With given data" do
			it "Writes the given data to the target file" do
				@file.write @data
				expect(IO.read(@file.target)).to eql @applied_text
			end
		end
	end
end