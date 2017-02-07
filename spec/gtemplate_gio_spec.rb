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

require_relative "spec_require"

# Describe General::GIO
#
# Implements the general IO writer template
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
describe General::GIO do
	before :all do
		@default_data = {place: "virginia"}
		@applied_data = {name: "joe", food: "Joe's Schmoes", place: "kentucky"}

		@gio1 = General::GIO.load("exp/templates/sample1" + General::GIO::EXTENSION)
		@gio2 = General::GIO.load("exp/templates/sample2" + General::GIO::EXTENSION)
		@gio3 = General::GIO.load("exp/templates/sample3" + General::GIO::EXTENSION)

		@out1 = "exp/out/sample1.txt"
		@out2 = "exp/out/sample2.txt"
		@out3 = "exp/out/sample3.txt"
		@outF = 3

		@default_text1 = IO.read "exp/expected/default1.txt"
		@default_text2 = IO.read "exp/expected/default2.txt"
		@default_text3 = IO.read "exp/expected/default3.txt"

		@applied_text1 = IO.read "exp/expected/applied1.txt"
		@applied_text2 = IO.read "exp/expected/applied2.txt"
		@applied_text3 = IO.read "exp/expected/applied3.txt"		
	end

	# Describe General::GIO::load
	#
	# Loads a GIO from a file with the given path
	#
	# Parameter: path - the path of the file to load
	#
	# Return: GIO loaded from the file
	describe "::load" do
		it "creates a new GIO with the given template string" do
			expect(@gio1).to be_an_instance_of General::GIO
			expect(@gio2).to be_an_instance_of General::GIO
			expect(@gio3).to be_an_instance_of General::GIO
		end

		it "cannot load GMeta file (with @@yield defined)" do
			expect { General::GIO.load("exp/templates/sample0"+General::GIO::EXTENSION) }.to raise_error General::GError
		end

		it "cannot load GMeta file with multiple @@yield statements" do
			expect { General::GIO.load("exp/templates/sampleE1"+General::GIO::EXTENSION) }.to raise_error General::GError
		end

		it "cannot load GIO in which @@extend statement is not at the beginning of the template" do
			expect { General::GIO.load("exp/templates/sampleE2"+General::GIO::EXTENSION) }.to raise_error General::GError
		end

		it "cannot load GIO with multiple @@extend statements" do
			expect { General::GIO.load("exp/templates/sampleE3"+General::GIO::EXTENSION) }.to raise_error General::GError
		end
	end

	# Describe General::GIO#write
	# 
	# Writes the template with the given data applied to the target stream
	#
	# Parameter: ios  - if String, is the name of the file to write to
	# 					if IO, is the stream to write to
	# Parameter: data - the data to be applied (merges with defaults)
	describe "#write" do
		# -------------------------------------------DEFAULT-------------------------------------------

		context "with target and default data" do
			it "writes the default data to the file with the given filename" do
				@gio1.write @out1, @default_data
				@gio2.write @out2, @default_data
				@gio3.write @out3, @default_data

				expect(IO.read @out1).to eql @default_text1
				expect(IO.read @out2).to eql @default_text2
				expect(IO.read @out3).to eql @default_text3
			end

			it "writes the default data to the given file io" do
				File.open(@out1, "w+") { |ios| @gio1.write ios, @default_data }
				File.open(@out2, "w+") { |ios| @gio2.write ios, @default_data }
				File.open(@out3, "w+") { |ios| @gio3.write ios, @default_data }

				expect(IO.read @out1).to eql @default_text1
				expect(IO.read @out2).to eql @default_text2
				expect(IO.read @out3).to eql @default_text3
			end

			it "raises TypeError if target is not string or io" do
				expect{ @gio1.write @outF, @default_data }.to raise_error TypeError
				expect{ @gio2.write @outF, @default_data }.to raise_error TypeError
				expect{ @gio3.write @outF, @default_data }.to raise_error TypeError
			end
		end

		# --------------------------------------------DATA---------------------------------------------

		context "with target and given data" do
			it "writes the given data to the file with the given filename" do
				@gio1.write @out1, @applied_data
				@gio2.write @out2, @applied_data
				@gio3.write @out3, @applied_data

				expect(IO.read @out1).to eql @applied_text1
				expect(IO.read @out2).to eql @applied_text2
				expect(IO.read @out3).to eql @applied_text3
			end

			it "writes the given data to the given file io" do
				File.open(@out1, "w+") { |ios| @gio1.write ios, @applied_data }
				File.open(@out2, "w+") { |ios| @gio2.write ios, @applied_data }
				File.open(@out3, "w+") { |ios| @gio3.write ios, @applied_data }

				expect(IO.read @out1).to eql @applied_text1
				expect(IO.read @out2).to eql @applied_text2
				expect(IO.read @out3).to eql @applied_text3
			end

			it "raises TypeError if target is not string or io" do
				expect{ @gio1.write @outF, @applied_data }.to raise_error TypeError
				expect{ @gio2.write @outF, @applied_data }.to raise_error TypeError
				expect{ @gio3.write @outF, @applied_data }.to raise_error TypeError
			end
		end
	end
end