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

# Describe General::GOperations
#
# Implements placeholder operations
#
# Author: Anshul Kharbanda
# Created: 6 - 3 - 2016
describe General::GOperations do
	#-----------------------------------STRING OPERATIONS------------------------------------

	# Describe General::GOperations::capitalize
	# 
	# Capitalizes every word in the string
	#
	# Parameter: string - the string being capitalized
	#
	# Return: the capitalized string
	describe '::capitalize' do
		before(:all) do
			@input     = "joe schmoe"
			@out_first = "Joe schmoe"
			@out_all   = "Joe Schmoe"
		end

		context 'with no second argument given' do
			it 'capitalizes the first letter in the string' do
				expect(General::GOperations.capitalize(@input)).to eql @out_first
			end

			it 'raises GOperationError with no string argument' do
				expect { General::GOperations.capitalize }.to raise_error General::GOperationError
			end

			it 'raises GOperationError with argument of another type' do
				expect { General::GOperations.capitalize(0) }.to raise_error General::GOperationError
			end
		end

		context 'with string argument and second string argument is given' do
			it 'capitalizes the first letter in the string when the second argument is "first"' do
				expect(General::GOperations.capitalize @input, "first").to eql @out_first
			end

			it 'capitalizes all words in the string when the second argument is "all"' do
				expect(General::GOperations.capitalize @input, "all").to eql @out_all
			end

			it 'raises GOperationError when the second argument is neither "first" or "all"' do
				expect{General::GOperations.capitalize @input, "foo"}.to raise_error General::GOperationError
			end
		end
	end

	# Describe General::GOperations::uppercase
	# 
	# Converts every letter in the string to uppercase
	#
	# Parameter: string - the string being uppercased
	#
	# Return: the uppercased string
	describe '::uppercase' do
		before :all do
			@input = "Joe Schmoe"
			@output = "JOE SCHMOE"
		end

		it 'converts the string to uppercase' do
			expect(General::GOperations.uppercase @input).to eql @output
		end

		it 'raises GOperationError with no string argument' do
			expect { General::GOperations.uppercase }.to raise_error General::GOperationError
		end

		it 'raises GOperationError with argument of another type' do
			expect { General::GOperations.capitalize(0) }.to raise_error General::GOperationError
		end
	end

	# Describe General::GOperations::lowercase
	# 
	# Converts every letter in the string to lowercase
	#
	# Parameter: string - the string being lowercased
	#
	# Return: the lowercased string
	describe '::lowercase' do
		before :all do
			@input = "Joe Schmoe"
			@output = "joe schmoe"
		end

		it 'converts the string to lowercase' do
			expect(General::GOperations.lowercase @input).to eql @output
		end

		it 'raises GOperationError with no string argument' do
			expect { General::GOperations.lowercase }.to raise_error General::GOperationError
		end

		it 'raises GOperationError with argument of another type' do
			expect { General::GOperations.capitalize(0) }.to raise_error General::GOperationError
		end
	end

	#-----------------------------------INTEGER OPERATIONS------------------------------------

	# Describe General::GOperations::money
	# 
	# Returns the integer monetary value formatted to the given money type
	#
	# Parameter: integer - the monetary amount being formatted
	# Parameter: type    - the type of money (defaults to USD)
	#
	# Return: the formatted money amount
	describe '::money' do
		before :all do
			@money1 = 233
			@money2 = -344
			@output1 = "$2.33"
			@output2 = "-$3.44"
			@output3 = "€2.33"
			@output4 = "-€3.44"
		end

		context 'with no second string value given' do
			it 'formats the monetary value into USD' do
				expect(General::GOperations.money @money1).to eql @output1
				expect(General::GOperations.money @money2).to eql @output2
			end

			it 'raises GOperationError with no integer value given' do
				expect { General::GOperations.money }.to raise_error General::GOperationError
			end

			it 'raises GOperationError with argument of another type' do
				expect { General::GOperations.money "" }.to raise_error General::GOperationError
			end
		end

		context 'with an integer value given and another string value given' do
			it 'formats the monetary value according to the money type' do
				expect(General::GOperations.money @money1, "EUR").to eql @output3
				expect(General::GOperations.money @money2, "EUR").to eql @output4
			end

			it 'raises GOperationError if the money type is not supported' do
				expect { General::GOperations.money(@money1, "RUE") }.to raise_error General::GOperationError
			end
		end
	end

	# Describe General::GOperations::time
	# 
	# Returns the integer time value (in seconds) formatted with the given formatter
	#
	# Parameter: integer - the integer being formatted (representing the time in seconds)
	# Parameter: format  - the format being used (defaults to @I:@MM:@SS @A)
	#
	# Return: the time formatted with the given formatter
	describe '::time' do
		before :all do
			@formatter = '@SS <- @MM <- @HH'
			@hrs = 3
			@min = 14
			@sec = 12
			@pm = true

			@time = (((@pm ? 11 : 0) + @hrs)*3600 + @min*60 + @sec)
			
			@out1 = General::GTimeFormat.new(General::GOperations::DEFAULT_TIME).apply(@time)
			@out2 = General::GTimeFormat.new(@formatter).apply(@time)
		end

		it 'formats the given time value to the default time format' do
			expect(General::GOperations.time(@time)).to eql @out1
		end

		it 'formats the given time value to the given time format' do
			expect(General::GOperations.time(@time, @formatter)).to eql @out2
		end

		it 'raises GOperationError with argument of another type' do
			expect { General::GOperations.time "" }.to raise_error General::GOperationError
		end
	end

	#----------------------------------TO ARRAY OPERATIONS------------------------------------

	# Splits the string by the given delimeter (or by newline if no delimeter is given)
	#
	# Parameter: string    - the string to split
	# Parameter: delimeter - the delimeter to split by (defaults to newline)
	#
	# Return: the array containing the split string chunks
	describe '::split' do
		before(:all) do
			@string1 = "Hello World\nI am dog"
			@array1  = ["Hello World", "I am dog"]

			@string2 = "Butter, Milk, Eggs, Bread"
			@delim2  = ",\s*"
			@array2  = ["Butter", "Milk", "Eggs", "Bread"]

			@string4 = 3
		end

		it 'splits the string by whitespace if no delimeter is given' do
			expect(General::GOperations.split(@string1)).to eql @array1
		end

		it 'splits the string using the given delimeter' do
			expect(General::GOperations.split(@string2, @delim2)).to eql @array2
		end

		it 'raises GOperationError with no string value given' do
			expect { General::GOperations.split }.to raise_error General::GOperationError
		end

		it 'raises GOperationError with value of other type given' do
			expect { General::GOperations.split @string4 }.to raise_error General::GOperationError
		end
	end

	# Splits a sequence by a set number of words (defaults to 10)
	#
	# Parameter: string - the string to split
	# Parameter: words  - the number of words to split by (defaults to 10)
	#
	# Return: an array containing hashes representing the chunks of the string split by words
	describe '::splitwords' do
		before(:all) do
			@string1 = "The number of words in this string is greater than ten!"
			@array1  = ["The number of words in this string is greater than", "ten!"]

			@string2 = "The number of words (in this string) is greater than five, so every \"fifth\" word is on Joe's new line!"
			@words2  = 5
			@array2  = ["The number of words (in", "this string) is greater than", "five, so every \"fifth\" word", "is on Joe's new line!"]

			@string3 = 4
		end

		it 'splits the string by ten words if no word count is given' do
			expect(General::GOperations.splitwords @string1).to eql @array1
		end

		it 'splits the string by the given number of words' do
			expect(General::GOperations.splitwords @string2, @words2).to eql @array2
		end

		it 'raises GOperationError with no string value given' do
			expect { General::GOperations.splitwords }.to raise_error General::GOperationError
		end

		it 'raises GOperationError with value of other type given' do
			expect { General::GOperations.splitwords @string3 }.to raise_error General::GOperationError
		end
	end
end