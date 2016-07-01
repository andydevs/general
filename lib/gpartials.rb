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

	# Represents a plain string part in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GPartialString
		# Initializes the GPartialString with the given string
		#
		# Parameter: string - the string value of the GPartialString
		def initialize(string)
			@string = string
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

	# Represents a placeholder part in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GPlaceholder
		# Regular expression that matches placeholders
		REGEX = /@\((?<name>[a-zA-Z]\w*)\s*(\:\s*(?<default>.*?))?\s*(->\s*(?<operation>[a-zA-Z]\w*))?\)/

		# Read name
		attr :name

		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match - the match data from the string being parsed
		def initialize match
			@name = match[:name].to_sym
			@operation = match[:operation]
		end

		# Returns the value of the placeholder in the given data 
		# with the given operation performed on it
		#
		# Parameter: data - the data being applied
		#
		# Return: the value of the placeholder in the given data 
		# 		  with the given operation performed on it
		def apply data
			if @operation
				return General::GOperations.send(@operation, data[@name]).to_s
			else
				return data[@name].to_s
			end
		end

		# Returns the string representation of the placeholder
		#
		# Return: the string representation of the placeholder
		def to_s
			return "@(#{@name} -> #{@operation})"
		end
	end

	# Represents an array placeholder part in a GTemplate
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
	end
end