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

		#-----------------------------------STRING OPERATIONS------------------------------------

		# Capitalizes every word in the string
		#
		# Parameter: string - the string being capitalized
		#
		# Return: the capitalized string
		def self.capitalize string, what="first"
			assert_type string, String
			case what
			when "all" then string.split(' ').collect(&:capitalize).join(' ')
			when "first" then string.capitalize
			else raise TypeError.new "Undefined second argument for operation capitalize: #{what}"
			end
		end

		# Converts every letter in the string to uppercase
		#
		# Parameter: string - the string being uppercased
		#
		# Return: the uppercased string
		def self.uppercase(string)
			assert_type string, String
			string.upcase
		end

		# Converts every letter in the string to lowercase
		#
		# Parameter: string - the string being lowercased
		#
		# Return: the lowercased string
		def self.lowercase(string)
			assert_type string, String
			string.downcase
		end

		#-----------------------------------INTEGER OPERATIONS------------------------------------

		# Returns the integer monetary value formatted to the given money type
		#
		# Parameter: integer - the monetary amount being formatted
		# Parameter: type    - the type of money (defaults to USD)
		#
		# Return: the formatted money amount
		def self.money integer, type="USD"
			assert_type integer, Integer
			if MONEY_TYPES[type]
				(integer < 0 ? "-" : "") + MONEY_TYPES[type] + (integer * 0.01).abs.to_s
			else
				raise TypeError.new("Money type: #{type} is not supported!")
			end
		end

		# Returns the integer time value (in seconds) formatted with the given formatter
		#
		# Parameter: integer - the integer being formatted (representing the time in seconds)
		# Parameter: format  - the format being used (defaults to DEFAULT_TIME)
		#
		# Return: the time formatted with the given formatter
		def self.time integer, format=DEFAULT_TIME
			assert_type integer, Integer
			General::GTimeFormat.new(format).apply(integer)
		end

		private

		# Raises TypeError if the given value is not one of the given types
		#
		# Parameter: value - the value to check
		# Parameter: types - the types to check for
		#
		# Raises: TypeError - if the given value is not one of the given types
		def self.assert_type value, *types
			unless types.any? {|type| value.is_a? type}
				raise TypeError.new "Unexpected value type #{value.class.name}. Expected #{types.collect(&:name).join(",")}"
			end
		end
	end
end