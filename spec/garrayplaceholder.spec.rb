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

		@arrayname1 = :arg1
		@arrayname2 = :arg2
		@arrayname3 = :arg3
		@hash = {
			arg1: [
				{ subarg: "Eeeeyyy" },
				{ subarg: "Oyyyeee" },
				{ subarg: "Aaayyyy" }
			],
			arg2: "Butter Milk Eggs Bacon Cleaner",
			arg3: "Buttered Bacon, Milked Eggs, Cleaning Butter"
		}
		
		@delim = "\n"
		@text1 = "Subarg: @(subarg)"
		@text2 = "# @#"
		@operation = :split
		@arguments = [",\s*"]

		# ---------------------------OUTPUT---------------------------
		
		@out1 = @hash[@arrayname1]
				.collect{|e| "Subarg: #{e[:subarg]}"}
				.join(General::GArrayPlaceholder::DEFAULT_DELIMETER)
		@out2 = @hash[@arrayname1]
				.collect{|e| "Subarg: #{e[:subarg]}"}
				.join(@delim)
		@out3 = General::GOperations.send(@operation, @hash[@arrayname2])
				.collect{|e| "# #{e}"}
				.join(@delim)
		@out4 = General::GOperations.send(@operation, @hash[@arrayname3], *@arguments)
				.collect{|e| "# #{e}"}
				.join(@delim)

		# ------------------------------------------PARTIALS------------------------------------------

		@partial1 = General::GArrayPlaceholder.new name: @arrayname1, 
												   text: @text1
		@partial2 = General::GArrayPlaceholder.new name: @arrayname1, 
												   text: @text1, 
												   delimeter: @delim
		@partial3 = General::GArrayPlaceholder.new name: @arrayname2, 
												   text: @text2, 
												   delimeter: @delim, 
												   operation: @operation
		@partial4 = General::GArrayPlaceholder.new name: @arrayname3, 
												   text: @text2, 
												   delimeter: @delim, 
												   operation: @operation, 
												   arguments: @arguments.collect{|a| " \"#{a}\""}.join

		# -------------------------------------------STRING-------------------------------------------

		@string1 = "@[#{@arrayname1}] #{@text1} @[#{General::GArrayPlaceholder::DEFAULT_DELIMETER.inspect[1...-1]}]"
		@string2 = "@[#{@arrayname1}] #{@text1} @[#{@delim.inspect[1...-1]}]"
		@string3 = "@[#{@arrayname2} -> #{@operation}] #{@text2} @[#{@delim.inspect[1...-1]}]"
		@string4 = "@[#{@arrayname3} -> #{@operation} #{@arguments.collect{|s| "\"#{s}\""}.join(" ")}] #{@text2} @[#{@delim.inspect[1...-1]}]"
	end

	# Describe General::GArrayPlaceholder::new
	# 
	# Initializes the GPlaceholder with the given match
	#
	# Parameter: match - the match data from the string being parsed
	describe '::new' do
		it 'creates a new GArrayPlaceholder with the given input data' do
			expect(@partial1).to be_an_instance_of General::GArrayPlaceholder
			expect(@partial2).to be_an_instance_of General::GArrayPlaceholder
			expect(@partial3).to be_an_instance_of General::GArrayPlaceholder
			expect(@partial4).to be_an_instance_of General::GArrayPlaceholder
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
		it 'applies the given data array formatted according to the info in the GArrayPlaceholder' do
			expect(@partial1.apply @hash).to eql @out1
			expect(@partial2.apply @hash).to eql @out2
			expect(@partial3.apply @hash).to eql @out3
			expect(@partial4.apply @hash).to eql @out4
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
		it 'returns the string of the GArrayPlaceholder' do
			expect(@partial1.string).to eql @string1
			expect(@partial2.string).to eql @string2
			expect(@partial3.string).to eql @string3
			expect(@partial4.string).to eql @string4
			expect(@partial1.string true).to eql @string1
			expect(@partial2.string true).to eql @string2
			expect(@partial3.string true).to eql @string3
			expect(@partial4.string true).to eql @string4
			expect(@partial1.string false).to eql @string1
			expect(@partial2.string false).to eql @string2
			expect(@partial3.string false).to eql @string3
			expect(@partial4.string false).to eql @string4
		end
	end

	# Describe General::GArrayPlaceholder#regex
	#
	# Throws TypeError
	# 
	# Parameter: first - true if the placeholder is the first of it's kind
	describe '#regex' do
		it 'raises TypeError' do
			expect { @partial1.regex }.to raise_error TypeError
			expect { @partial2.regex }.to raise_error TypeError
			expect { @partial3.regex }.to raise_error TypeError
			expect { @partial4.regex }.to raise_error TypeError
			expect { @partial1.regex true }.to raise_error TypeError
			expect { @partial2.regex true }.to raise_error TypeError
			expect { @partial3.regex true }.to raise_error TypeError
			expect { @partial4.regex true }.to raise_error TypeError
			expect { @partial1.regex false }.to raise_error TypeError
			expect { @partial2.regex false }.to raise_error TypeError
			expect { @partial3.regex false }.to raise_error TypeError
			expect { @partial4.regex false }.to raise_error TypeError
		end
	end
end