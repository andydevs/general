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

# Describe General::GTimeFormat
# 
# A special template used for formatting time strings
#
# Author:  Anshul Kharbanda
# Created: 7 - 2 - 2016
describe General::GTimeFormat do
	before :all do
		# Time value
		@time = (11 + 3)*3600 + 42*60 + 9

		# Phony value
		@phony = {data: "Time, Yo!"}

		# Formats
		@format1 = General::GTimeFormat.new "@HH:@MM:@SS"
		@format2 = General::GTimeFormat.new "@I:@MM:@S @A"
		@format3 = General::GTimeFormat.new "@SS - @M - @H (@I @A)"

		# Applied values
		@applied1 = "14:42:09"
		@applied2 = "3:42:9 PM"
		@applied3 = "09 - 42 - 14 (3 PM)"
	end

	# Describe General::GTimeFormat::new
	# 
	# Creates the GTimeFormat with the given string
	#
	# Parameter: string - the template string
	describe "::new" do
		it "creates a new GTimeFormat with the given format string" do
			expect(@format1).to be_an_instance_of General::GTimeFormat
			expect(@format2).to be_an_instance_of General::GTimeFormat
			expect(@format3).to be_an_instance_of General::GTimeFormat
		end
	end

	# Describe General::GTimeFormat#apply
	# 
	# Applies the given integer value to the template and returns the generated string
	#
	# Parameter: value - the value to be applied (as a hash. merges with defaults)
	#
	# Return: string of the template with the given value applied
	describe "#apply" do
		it "returns the given integer time value value formatted according to the time format" do
			expect(@format1.apply(@time)).to eql @applied1
			expect(@format2.apply(@time)).to eql @applied2
			expect(@format3.apply(@time)).to eql @applied3
		end

		it "raises TypeError if value given is not integer" do
			expect{ @format1.apply(@phony) }.to raise_error TypeError
			expect{ @format2.apply(@phony) }.to raise_error TypeError
			expect{ @format3.apply(@phony) }.to raise_error TypeError
		end
	end
end