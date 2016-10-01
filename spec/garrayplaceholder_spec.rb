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

# Describe General::GArrayPlaceholder
# 
# Represents an array placeholder partial in a GTemplate
#
# Author:  Anshul Kharbanda
# Created: 7 - 1 - 2016
describe General::GArrayPlaceholder do
	before :all do
		# -----------DATA-----------

		@arrayname1 = :arg
		@hash = {
			arg: [
				{ subarg: "Eeeeyyy" },
				{ subarg: "Oyyyeee" },
				{ subarg: "Aaayyyy" }
			]
		}
		
		@text  = "Subarg: @(subarg)"
		@regex = "Subarg: (?<subarg>.*)"
		@delim = "\n"

		# ---------------------------OUTPUT---------------------------
		
		@out1 = @hash[@arrayname1]
				.collect{|e| "Subarg: #{e[:subarg]}"}
				.join(General::GArrayPlaceholder::DEFAULT_DELIMETER)
		@out2 = @hash[@arrayname1]
				.collect{|e| "Subarg: #{e[:subarg]}"}
				.join(@delim)

		# ------------------------------------------PARTIALS------------------------------------------

		@partial1 = General::GArrayPlaceholder.new name: @arrayname1, text: @text
		@partial2 = General::GArrayPlaceholder.new name: @arrayname1, text: @text, delimeter: @delim

		# -------------------------------------------STRING-------------------------------------------

		@string1 = "@[#{@arrayname1}] #{@text} @[ ]"
		@string2 = "@[#{@arrayname1}] #{@text} @[\\n]"

		# -------------------------------------------REGEX--------------------------------------------

		@regex1 = "(?<#{@arrayname1}>(#{@regex}( )?)+)"
		@regex2 = "(?<#{@arrayname1}>(#{@regex}(\\n)?)+)"
	end

	# Describe General::GArrayPlaceholder::new
	# 
	# Initializes the GPlaceholder with the given match
	#
	# Parameter: match - the match data from the string being parsed
	describe '::new' do
		context 'with the given name and text' do
			it 'creates a new GArrayPlaceholder with the given name and text' do
				expect(@partial1).to be_an_instance_of General::GArrayPlaceholder
			end
		end

		context 'with the given name, text, and delimeter' do
			it 'creates a new GArrayPlaceholder with the given name and text and delimeter' do
				expect(@partial1).to be_an_instance_of General::GArrayPlaceholder
			end
		end
	end

	# Describe General::GArrayPlaceholder#apply
	# 
	# Returns the value of the array placeholder in the given data
	# formatted by the given GArrayPlaceholder and joined by the given delimeter
	#
	# Parameter: data - the data being applied
	#
	# Return: the value of the array placeholder in the given data
	# 		  formatted by the given GArrayPlaceholder and joined by the given delimeter
	describe '#apply' do
		it 'applies the given data array formatted according to the given GArrayPlaceholder and joined by the delimeter' do
			expect(@partial1.apply @hash).to eql @out1
			expect(@partial2.apply @hash).to eql @out2
		end
	end

	# Describe General::GArrayPlaceholder#string
	#
	# Returns the string representation of the GArrayPlaceholder
	#
	# Parameter: first - true if the GArrayPlaceholder is the first of it's time
	#
	# Returns: the string representation of the GArrayPlaceholder
	describe '#string' do
		context 'with no first argument is given' do
			it 'returns the string of the GArrayPlaceholder' do
				expect(@partial1.string).to eql @string1
				expect(@partial2.string).to eql @string2
			end
		end

		context 'with first argument is given' do
			context 'when first is true' do
				it 'returns the string of the GArrayPlaceholder' do
					expect(@partial1.string true).to eql @string1
					expect(@partial2.string true).to eql @string2
				end
			end

			context 'when first is false' do
				it 'returns the string of the GArrayPlaceholder' do
					expect(@partial1.string false).to eql @string1
					expect(@partial2.string false).to eql @string2					
				end
			end
		end
	end

	# Describe General::GArrayPlaceholder#regex
	#
	# Throws TypeError
	# 
	# Parameter: first - true if the placeholder is the first of it's kind
	describe '#regex' do
		context 'with no first argument is given' do
			it 'returns the regex of the GArrayPlaceholder' do
				expect { @partial1.regex }.to raise_error TypeError
				expect { @partial2.regex }.to raise_error TypeError
			end
		end

		context 'with first argument is given' do
			context 'when first is true' do
				it 'returns the regex of the GArrayPlaceholder' do
					expect { @partial1.regex true }.to raise_error TypeError
					expect { @partial2.regex true }.to raise_error TypeError
				end
			end

			context 'when first is false' do
				it 'returns the regex of the GArrayPlaceholder' do
					expect { @partial1.regex false }.to raise_error TypeError
					expect { @partial2.regex false }.to raise_error TypeError					
				end
			end
		end
	end
end