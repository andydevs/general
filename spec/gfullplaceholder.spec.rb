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

# Inserts the full data value passed into the template
#
# Author:  Anshul Kharbanda
# Created: 1 - 19 - 2016
describe General::GFullPlaceholder do
	before :all do
		@full = General::GFullPlaceholder.new({})
		@data1 = "Hello World!"
	end

	# Creates a new GFullPlaceholder with the given match
	#
	# Parameter: match - the match data from the string being parsed
	describe '::new' do
		it 'creates a new GFullPlaceholder' do
			expect(@full).to be_an_instance_of General::GFullPlaceholder
		end
	end

	# Returns a string representation of the given data
	# 
	# Parameter: data - the data being applied
	# 
	# Returns: a string representation of the given data
	describe '#apply' do
		it 'returns a string representation of the entire data value given' do
			expect(@full.apply @data1).to eql @data1
		end
	end

	# Returns a string representation of the GFullPlaceholder
	#
	# Parameter: first - true if this is the first in a given template 
	#
	# Returns: a string representation of the GFullPlaceholder
	describe '#string' do
		it 'returns a string reprsentation of the GFullPlaceholder' do
			expect(@full.string).to eql General::GFullPlaceholder::STRING
			expect(@full.string true).to eql General::GFullPlaceholder::STRING
			expect(@full.string false).to eql General::GFullPlaceholder::STRING
		end
	end

	# Raises TypeError
	#
	# Parameter: first - true if this is the first in a given template 
	#
	# Raises: TypeError
	describe '#regex' do
		it 'raises TypeError' do
			expect{@full.regex}.to raise_error TypeError
			expect{@full.regex true}.to raise_error TypeError
			expect{@full.regex false}.to raise_error TypeError
		end
	end
end