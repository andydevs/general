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

require_relative "gpartial"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Represents an timeformat placeholder partial in a GTimeFormat
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GTimeFormatPlaceholder < GPartial
		# Regular expression that matches timeformat placeholders
		REGEX = /@(?<name>[A-Z]+)/

		# Returns the value of the timeformat placeholder in the given time value
		# formatted according to the time format name
		#
		# Parameter: value - the time value being applied
		#
		# Return: the value of the timeformat placeholder in the given time value
		# 		  formatted according to the time format name
		def apply value
			map = name_map(value).to_s
			return is_justify? ? map.rjust(@name.length, '0') : map
		end

		# Returns true if the timeformat placeholder is a justifiable name
		#
		# Return: true if the timeformat placeholder is a justifiable name
		def is_justify?; "HIMS".include? @name[0]; end

		# Returns the string representation of the timeformat placeholder
		#
		# Return: the string representation of the timeformat placeholder
		def to_s; "@#{@name}"; end

		private

		# Returns the value modified according to the raw timeformat name
		#
		# Parameter: value - the time value being applied
		#
		# Return: the value modified according to the raw timeformat name
		def name_map value
			case @name[0]
				when "H" then (value / 3600)
				when "I" then (value / 3600 % 12 + 1)
				when "M" then (value % 3600 / 60)
				when "S" then (value % 3600 % 60)
				when "A" then (value / 3600 > 11 ? 'PM' : 'AM')
			end
		end
	end
end