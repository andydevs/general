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
	private

	# Represents a plain string partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GPartialString
		# Initializes the GPartialString with the given string
		#
		# Parameter: string - the string value of the GPartialString
		def initialize(string, match=nil)
			@string = match ? string[0...match.begin(0)] : string
		end
		
		# Returns the string
		#
		# Returns: the string
		def apply data
			@string
		end

		# Returns the string
		#
		# Returns: the string
		def to_s
			@string
		end
	end

	# Represents a placeholder partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GPlaceholder
		# Regular expression that matches placeholders
		REGEX = /@\((?<name>[a-zA-Z]\w*)\s*(\:\s*(?<default>.*?))?\s*(->\s*(?<operation>[\w+\s+]+))?\)/

		# Read name
		attr :name

		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match    - the match data from the string being parsed
		# Parameter: defaults - the hash of default data from the GTemplate
		def initialize match, defaults
			@name = match[:name].to_sym
			@operation = match[:operation]
			@defaults = defaults
		end

		# Returns the value of the placeholder in the given data 
		# with the given operation performed on it
		#
		# Parameter: data - the data being applied
		#
		# Return: the value of the placeholder in the given data 
		# 		  with the given operation performed on it
		def apply data
			# Get value from either data or defaults
			value = data[@name] || @defaults[@name]

			# Return value (operation performed if one is defined)
			return (@operation ? General::GOperations.send(@operation, value) : value).to_s
		end

		# Returns the string representation of the placeholder
		#
		# Return: the string representation of the placeholder
		def to_s
			return "@(#{@name} -> #{@operation})"
		end
	end

	# Represents an array placeholder partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GArrayPlaceholder
		# Regular expression that matches array placeholders
		REGEX = /@\[(?<name>[a-zA-Z]\w*)\]( +|\n+)?(?<text>.*?)( +|\n+)?@\[(?<delimeter>.+)?\]/m

		# Default delimeter
		DEFAULT_DELIMETER = " "

		# Read name
		attr :name

		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match - the match data from the string being parsed
		def initialize match
			@name = match[:name].to_sym
			@delimeter = match[:delimeter] || DEFAULT_DELIMETER
			@template = General::GTemplate.new match[:text]
		end

		# Returns the value of the array placeholder in the given data
		# formatted by the given GTemplate and joined by the given delimeter
		#
		# Parameter: data - the data being applied
		#
		# Return: the value of the array placeholder in the given data
		# 		  formatted by the given GTemplate and joined by the given delimeter
		def apply data
			return @template.apply_all(data[@name]).join(@delimeter)
		end

		# Returns the string representation of the array placeholder
		#
		# Return: the string representation of the array placeholder
		def to_s
			return "@[#{@name}] #{@template.to_s} @[#{@delimeter.inspect}]"
		end
	end

	# Represents an timeformat placeholder partial in a GTimeFormat
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GTimeFormatPlaceholder
		# Regular expression that matches timeformat placeholders
		REGEX = /@(?<type>[A-Z]+)/

		# Read type
		attr :type

		# Initializes the GTimeFormatPlaceholder with the given match
		#
		# Parameter: match - the match data from the string being parsed
		def initialize match
			@type = match[:type]
		end

		# Returns the value of the timeformat placeholder in the given time value
		# formatted according to the time format type
		#
		# Parameter: value - the time value being applied
		#
		# Return: the value of the timeformat placeholder in the given time value
		# 		  formatted according to the time format type
		def apply value
			if value.is_a? Integer
				map = type_map(value).to_s
				return is_justify? ? map.rjust(@type.length, '0') : map
			else
				raise TypeError.new "Expected Integer, got: #{value.class}"
			end
		end

		# Returns true if the timeformat placeholder is a justifiable type
		#
		# Return: true if the timeformat placeholder is a justifiable type
		def is_justify?; "HIMS".include? @type[0]; end

		# Returns the string representation of the timeformat placeholder
		#
		# Return: the string representation of the timeformat placeholder
		def to_s; return "@#{@type}"; end

		private

		# Returns the value modified according to the raw timeformat type
		#
		# Parameter: value - the time value being applied
		#
		# Return: the value modified according to the raw timeformat type
		def type_map value
			case @type[0]
				when "H" then return (value / 3600)
				when "I" then return (value / 3600 % 12 + 1)
				when "M" then return (value % 3600 / 60)
				when "S" then return (value % 3600 % 60)
				when "A" then return (value / 3600 > 11 ? 'PM' : 'AM')
			end
		end
	end
end