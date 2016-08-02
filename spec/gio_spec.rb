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

require "spec_require"

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

	describe "#new" do
		it "creates a new GIO with the given template string" do
			expect(@gio).to be_an_instance_of General::GIO
		end
	end

	describe "#write" do
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