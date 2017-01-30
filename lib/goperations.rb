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

require_relative "templates/gtimeformat"
require_relative "gerror"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Implements placeholder operations
	#
	# Author: Anshul Kharbanda
	# Created: 6 - 3 - 2016
	module GOperations
		# The money types used by the money operation
		MONEY_TYPES = {
			"USD" => "$",
			"EUR" => "€"
		}

		# The default time format
		DEFAULT_TIME = "@I:@MM:@SS @A"

		private

		# Asserts that the given argument for the given operation exists and is of the given types
		#
		# Parameter: operation - the name of the operation
		# Parameter: argument  - the argument being checked
		# Parameter: types     - the allowed types for the argument
		#
		# Raises: GOperationError if assertion fails
		def self.assert operation, argument, *types
			raise GOperationError.new "Requied argument not given for operation #{operation}" if argument.nil?
			unless types.any? { |type| argument.is_a? type }
				raise GOperationError.new "Argument #{argument} for operation #{operation} " \
				"must be of type(s): #{types.collect(&:to_s).join(", ")}. Got #{argument.class.name}"
			end
		end

		public

		#-----------------------------------STRING OPERATIONS------------------------------------

		# Capitalizes every word in the string
		#
		# Parameter: string - the string being capitalized
		#
		# Return: the capitalized string
		def self.capitalize string=nil, what='first'
			assert 'capitalize', string, String

			case what
			when 'all' then string.split(' ').collect(&:capitalize).join(' ')
			when 'first' then string.capitalize
			else raise GOperationError.new "Undefined second argument for operation capitalize: #{what}"
			end
		end

		# Converts every letter in the string to uppercase
		#
		# Parameter: string - the string being uppercased
		#
		# Return: the uppercased string
		def self.uppercase string=nil
			assert 'uppercase', string, String
			return string.upcase
		end

		# Converts every letter in the string to lowercase
		#
		# Parameter: string - the string being lowercased
		#
		# Return: the lowercased string
		def self.lowercase string=nil
			assert 'lowercase', string, String
			return string.downcase
		end

		#-----------------------------------INTEGER OPERATIONS------------------------------------

		# Returns the integer monetary value formatted to the given money type
		#
		# Parameter: integer - the monetary amount being formatted
		# Parameter: type    - the type of money (defaults to USD)
		#
		# Return: the formatted money amount
		def self.money integer=nil, type="USD"
			assert 'money', integer, Integer

			if MONEY_TYPES[type]
				return (integer < 0 ? "-" : "") + MONEY_TYPES[type] + (integer * 0.01).abs.to_s
			else
				raise GOperationError.new "Money type: #{type} is not supported!"
			end
		end

		# Returns the integer time value (in seconds) formatted with the given formatter
		#
		# Parameter: integer - the integer being formatted (representing the time in seconds)
		# Parameter: format  - the format being used (defaults to DEFAULT_TIME)
		#
		# Return: the time formatted with the given formatter
		def self.time integer=nil, format=DEFAULT_TIME
			assert 'time', integer, Integer
			return General::GTimeFormat.new(format).apply(integer)
		end

		#---------------------------------TO ARRAY OPERATIONS-----------------------------------

		# Splits the string by the given delimeter (or by newline if no delimeter is given)
		#
		# Parameter: string    - the string to split
		# Parameter: delimeter - the delimeter to split by (defaults to newline)
		#
		# Return: the array containing hashes representing the split string chunks
		def self.split string=nil, delimeter="\r?\n"
			assert 'split', string, String
			return string.split(Regexp.new(delimeter))
		end

		# Splits a sequence by a set number of words (defaults to 10)
		#
		# Parameter: string - the string to split
		# Parameter: words  - the number of words to split by (defaults to 10)
		#
		# Return: an array containing hashes representing the chunks of the string split by words
		def self.splitwords string=nil, words=10
			assert 'splitwords', string, String

			# Convert words to integer
			words = words.to_i

			# Regex to match words
			matcher = /\G[\w\',\.\?!\(\)\-\:\;\"\"]+\s*/

			# Buffers
			to_return = []
			buffer    = ""

			# Initialize loop
			matched = matcher.match string
			index   = 0

			# While matched data exists
			while matched
				# Push line to array and reset if number of words is passed
				if index % words == 0
					to_return << buffer.sub(/\s+$/, "")
					buffer = ""
				end

				# Append word to buffer
				buffer += matched.to_s

				# Trim word from string
				string = string[matched.end(0)..-1]

				# Iterate
				matched = matcher.match string
				index += 1
			end

			# Push final line to array and return
			to_return << buffer
			return to_return[1..-1] # Getting rid of the first blank line
		end
	end
end