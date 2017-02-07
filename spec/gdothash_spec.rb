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

# Describing General::GDotHash
#
# Wrapper for hash objects which implements dot notation
#
# Author:  Anshul Kharbanda
# Created: 9 - 27 - 2016
describe General::GDotHash do
	before :all do
		@hash       = {name: {first: "Joe", last: "Schmoe"}}
		@key1       = :"name.first"
		@key2       = :"name.middle"
		@value1     = @hash[:name][:first]
		@newvalue1  = "Doe"
		@newvalue2  = "Bobo"
		@gdothash   = General::GDotHash.new @hash
	end

	# Describing General::GDotHash::new
	# 
	# Initializes the given GDotHash with the given hash
	#
	# Parameter: hash - the hash being manipulated
	describe "::new" do
		it 'creates a new GDotHash with the given hash' do
			expect(@gdothash).to be_an_instance_of General::GDotHash
			expect(@gdothash.instance_variable_get(:@hash)).to eql @hash
		end
	end

	# Returns the string representation of the hash
	#
	# Return: the string representation of the hash
	describe '#to_s' do
		it 'returns the string representation of the given GDotHash' do
			expect(@gdothash.to_s).to eql @hash.to_s
		end
	end

	# Gets the value at the given key
	#
	# Parameter: key - the key to return
	#
	# Return: the value at the given key
	describe '#[]' do
		it 'returns the value addressed by the given dot notation key' do
			expect(@gdothash[@key1]).to eql @value1
		end
	end

	# Sets the given key to the given value
	# 
	# Parameter: key   - the key to set
	# Parameter: value - the value to set
	describe '#[]=' do
		it 'sets the position addressed by the given dot notation key (if it exists) to the given value' do
			expect { @gdothash[@key1] = @newvalue1 }.not_to raise_error
			expect(@gdothash[@key1]).to eql @newvalue1
		end

		it 'creates position addressed by the given dot notation key (if it does not exist) and sets it to the given value' do
			expect { @gdothash[@key2] = @newvalue2 }.not_to raise_error
			expect(@gdothash[@key2]).to eql @newvalue2
		end
	end
end