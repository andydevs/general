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
		@gio = General::GIO.load("exp/sample" + General::GIO::EXTENSION)
		@out = "exp/out.txt"
		@phony = 3
		@default_data = {place: "virginia"}
		@applied_data = {name: "joe", food: "Joe's Schmoes", place: "kentucky"}
		@default_text = "There once was a chef name Gordon Ramsay, and he loved eating carrots. He went to Virginia."
		@applied_text = "There once was a chef name Joe, and he loved eating Joe's Schmoes. He went to Kentucky."
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
			expect(@gio).to be_an_instance_of General::GIO
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
			context 'if target is string' do
				it "writes the default data to the file with the given filename (the target string)" do
					@gio.write @out, @default_data
					expect(IO.read(@out)).to eql @default_text
				end
			end

			context 'if target is io' do
				it "writes the default data to the target io" do
					File.open(@out, "w+") { |ios| @gio.write ios, @default_data }
					expect(IO.read(@out)).to eql @default_text
				end
			end

			context 'if target is not string or io' do
				it "raises TypeError" do
					expect{ @gio.write @phony, @default_data }.to raise_error TypeError
				end
			end
		end

		# --------------------------------------------DATA---------------------------------------------

		context "with target and given data" do
			context 'if target is string' do
				it "writes the given data to the file with the given filename (the target string)" do
					@gio.write @out, @applied_data
					expect(IO.read(@out)).to eql @applied_text
				end
			end

			context 'if target is io' do
				it "writes the given data to the target io" do
					File.open(@out, "w+") { |ios| @gio.write ios, @applied_data }
					expect(IO.read(@out)).to eql @applied_text
				end
			end

			context 'if target is not string or io' do
				it "raises TypeError" do
					expect{ @gio.write @phony, @applied_data }.to raise_error TypeError
				end
			end
		end
	end
end