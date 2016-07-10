require "spec_require"

describe General::GIO do
	before :all do
		@gio = General::GIO.load("exp/sample" + General::GIO::EXTENSION)
		@out = "exp/out.txt"
		@phony = 3
		@data = {name: "joe", food: "Joe's Schmoes"}
		@default_text = "There once was a chef name Gordon Ramsay, and he loved eating carrots."
		@applied_text = "There once was a chef name Joe, and he loved eating Joe's Schmoes."
	end

	describe "#new" do
		it "creates a new GIO with the given template string" do
			expect(@gio).to be_an_instance_of General::GIO
		end
	end

	describe "#write" do
		context "with target and no data" do
			context 'if target is string' do
				it "writes the default data to the file with the given filename (the target string)" do
					@gio.write @out
					expect(IO.read(@out)).to eql @default_text
				end
			end

			context 'if target is io' do
				it "writes the default data to the target io" do
					File.open(@out, "w+") { |ios| @gio.write ios }
					expect(IO.read(@out)).to eql @default_text
				end
			end

			context 'if target is not string or io' do
				it "raises TypeError" do
					expect{ @gio.write(@phony) }.to raise_error TypeError
				end
			end
		end

		context "with target and given data" do
			context 'if target is string' do
				it "writes the given data to the file with the given filename (the target string)" do
					@gio.write @out, @data
					expect(IO.read(@out)).to eql @applied_text
				end
			end

			context 'if target is io' do
				it "writes the given data to the target io" do
					File.open(@out, "w+") { |ios| @gio.write ios, @data }
					expect(IO.read(@out)).to eql @applied_text
				end
			end

			context 'if target is not string or io' do
				it "raises TypeError" do
					expect{ @gio.write(@phony, @data) }.to raise_error TypeError
				end
			end
		end
	end
end