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
require_relative "../goperations"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Represents a placeholder partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GPlaceholder < GPartial
		private

		# Regular expression that matches a single placeholder
		ARGUMENT = /(?<text>\w+)|((?<qtat>'|")(?<text>.*)\k<qtat>)/

		# Regular expression that matches placeholder arguments
		ARGUMENTS = /(?<arguments>(#{ARGUMENT}\s*)*)/

		# Regular expression that matches placeholder operations
		OPERATION = /(->\s*(?<operation>\w+))/

		# Regular expression that matches placeholder defaults
		DEFAULT = /(\:\s*(?<default>[^(\-\>)]+))/

		public

		# Regular expression that matches placeholders
		REGEX = /@\(\s*#{NAME}\s*#{DEFAULT}?\s*#{OPERATION}?\s*#{ARGUMENTS}?\s*\)/

		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match    - the match data from the string being parsed
		# Parameter: defaults - the hash of default data from the GTemplate
		def initialize match, defaults
			super match
			@defaults  = defaults
			@operation = match[:operation]
			@arguments = match[:arguments].gsub(ARGUMENT).collect { |arg|
				ARGUMENT.match(arg)[:text]
			}
			@defaults[@name] ||= match[:default]
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
			return (@operation ? General::GOperations.send(@operation, value, *@arguments) : value).to_s
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
		REGEX = /\A@\[#{NAME}\]( +|\n+)?(?<text>.*?)( +|\n+)?@\[(?<delimeter>.+)?\]/m

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
end