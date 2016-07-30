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
		#-----------------------------------STRING OPERATIONS------------------------------------

		# Capitalizes every word in the string
		#
		# Parameter: string - the string being capitalized
		#
		# Return: the capitalized string
		def self.capitalize string, what="first"
			case what
			when "all" then string.split(' ').collect(&:capitalize).join(' ')
			else string.capitalize
			end
		end

		# Converts every letter in the string to uppercase
		#
		# Parameter: string - the string being uppercased
		#
		# Return: the uppercased string
		def self.uppercase string
			return string.upcase
		end

		# Converts every letter in the string to lowercase
		#
		# Parameter: string - the string being lowercased
		#
		# Return: the lowercased string
		def self.lowercase string
			return string.downcase
		end

		#-----------------------------------INTEGER OPERATIONS------------------------------------

		# Returns the integer monetary value (in cents) formatted to USD
		#
		# Parameter: integer - the integer being formatted (representing the amount in cents)
		#
		# Return: the formatted USD amount
		def self.dollars integer
			if integer < 0
				return "-$" + (integer * -0.01).to_s
			else
				return '$' + (integer * 0.01).to_s
			end
		end

		# Returns the integer time value (in seconds) formatted to I:MM:SS A
		#
		# Parameter: integer - the integer being formatted (representing the time in seconds)
		#
		# Return: the formatted I:MM:SS A
		def self.time integer
			return format_time "I:MM:SS A", integer
		end

		private

		def self.format_time formatter, value
			return formatter
				.sub(/II/, (value / 3600 % 12 + 1).to_s.rjust(2, '0'))
				.sub(/HH/, (value / 3600).to_s.rjust(2, '0'))
				.sub(/MM/, (value % 3600 / 60).to_s.rjust(2, '0'))
				.sub(/SS/, (value % 3600 % 60).to_s.rjust(2, '0'))
				.sub(/I/, (value / 3600 % 12 + 1).to_s)
				.sub(/H/, (value / 3600).to_s)
				.sub(/M/, (value % 3600 / 60).to_s)
				.sub(/S/, (value % 3600 % 60).to_s)
				.sub(/A/, value / 3600 > 12 ? 'PM' : 'AM')
		end
	end
end