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

	# Represents a Partial in a template
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 29 - 2016
	class GPartial
		# Get name
		attr :name

		# Initializes the GPartial with the given object
		#
		# Parameter: obj - the object containing information for the partial
		def initialize(obj); @name = obj[:name].to_sym; end

		# Returns a detailed inspection of the General partial
		#
		# Return: a detailed inspection of the General partial
		def inspect; "@<name=#{@name}>"; end
	end

	# Represents a plain string partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GPartialString < GPartial
		# Regular expression that matches string partials
		REGEX = /\A[^@]+?(?=(@|\z))/m

		# Initializes the GPartialString with the given string
		#
		# Parameter: string - the string value of the GPartialString
		def initialize(match)
			super name: :gpartialstring
			@string = match.to_s
		end
		
		# Returns the string
		#
		# Returns: the string
		def apply(data); @string; end

		# Returns the string as a regex
		#
		# Returns: the string as a regex
		def regex(first=true); @string.inspect[1...-1].gsub(/[\.\+\-\*]/) { |s| "\\#{s}" }; end

		# Returns the string
		#
		# Returns: the string
		def string(first=true); @string.inspect[1...-1]; end
	end

	# Represents a placeholder partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GPlaceholder < GPartial
		# Regular expression that matches placeholders
		REGEX = /@\((?<name>[a-zA-Z]\w*)\s*(\:\s*(?<default>.*?))?\s*(->\s*(?<operation>[\w+\s+]+))?\)/

		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match    - the match data from the string being parsed
		# Parameter: defaults - the hash of default data from the GTemplate
		def initialize match, defaults
			super match
			@operation = match[:operation]
			@defaults  = defaults
			@defaults[@name] ||= match[:default] if match[:default]
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

		# Returns the string as a regex
		#
		# Returns: the string as a regex
		def regex(first=true); first ? "(?<#{@name.to_s}>.*)" : "\\k<#{@name.to_s}>"; end

		# Returns the string representation of the placeholder
		#
		# Return: the string representation of the placeholder
		def string first=true
			str = "@(#{@name}"
			str += ": #{@defaults[@name]}" if @defaults[@name] && first
			str += " -> #{@operation}" if @operation
			return str + ")"
		end
	end

	# Represents an array placeholder partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GArrayPlaceholder < GPartial
		# Regular expression that matches array placeholders
		REGEX = /\A@\[(?<name>[a-zA-Z]\w*)\]( +|\n+)?(?<text>.*?)( +|\n+)?@\[(?<delimeter>.+)?\]/m

		# Default delimeter
		DEFAULT_DELIMETER = " "

		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match - the match data from the string being parsed
		def initialize match
			super
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
		def apply(data); @template.apply_all(data[@name]).join(@delimeter); end

		# Returns the string as a regex
		# 
		# Returns: the string as a regex
		def regex(first=true)
			"(?<#{@name.to_s}>(" \
			+ @template.regex(true) \
			+ "(#{@delimeter.inspect[1...-1]})?)+)"
		end

		# Returns the string representation of the array placeholder
		#
		# Return: the string representation of the array placeholder
		def string(first=true); "@[#{@name}] #{@template.to_s} @[#{@delimeter.inspect[1...-1]}]"; end
	end

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