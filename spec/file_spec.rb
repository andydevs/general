require "spec_require"

describe Generic::GFile do
	before :all do
		@filepath = "tmp"
		@filename = "sample.txt"
		@new_filename = "supersample.txt"
		@new_filepath = "tmp/supertmp"
		@data = {name: "Joe", food: "Joe's Schmoes"}
		@default_text = "There once was a chef name Gordon Ramsay, and he loved eating carrots."
		@applied_text = "There once was a chef name Joe, and he loved eating Joe's Schmoes."
	end

	before :each do
		@file = Generic::GFile.new (@filepath + "/" + @filename + Generic::GFile::EXTENTION)
	end

	describe "#new" do
		it "Creates a new GFile with the given filename" do
			expect(@file).to be_an_instance_of Generic::GFile
			expect(@file.target).to eql (@filepath + "/" + @filename)
		end
	end

	describe "#target" do
		it "Returns the name of the target" do
			expect(@file.target).to eql (@filepath + "/" + @filename)
		end
	end

	describe "#name=" do
		it "Changes the name of the target" do
			@file.name = @new_filename
			expect(@file.target).to eql (@filepath + "/" + @new_filename)
		end
	end

	describe "#path=" do
		it "Changes the path of the target" do
			@file.path = @new_filepath
			expect(@file.target).to eql (@new_filepath + "/" + @filename)
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
				@file.write(@data)
				expect(IO.read(@file.target)).to eql @applied_text
			end
		end
	end
end