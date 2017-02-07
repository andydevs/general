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
	# Represents an array placeholder partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GArrayPlaceholder < GPartial
		# Regular expression that matches array placeholders
		REGEX = /\A@\[#{NAME}\s*(#{OPERATION}\s*#{ARGUMENTS}?)?\]( +|(\r?\n)+)?(?<text>.*?)( +|(\r?\n)+)?@\[(?<delimeter>.+)?\]/m

		# Default delimeter
		DEFAULT_DELIMETER = "\n"

		# Initializes the GArrayPlaceholder with the given match
		#
		# Parameter: match - the match data from the string being parsed
		# Parameter: defaults - the hash of default data from the GTemplate
		def initialize match, defaults={}
			super
			@template = General::GTemplate.new match[:text]
			@delimeter = match[:delimeter] || DEFAULT_DELIMETER
			@operation = match[:operation]
			if match[:arguments]
				@arguments = match[:arguments].gsub(ARGUMENT).collect { |arg|
					ARGUMENT.match(arg)[:text]
				}
			else
				@arguments = []
			end
		end

		# Returns the value of the array placeholder in the given data
		# formatted by the given GTemplate and joined by the given delimeter
		#
		# Parameter: data - the data being applied
		#
		# Return: the value of the array placeholder in the given data
		# 		  formatted by the given GTemplate and joined by the given delimeter
		def apply(data)
			array = (@operation ? General::GOperations.send(@operation, data[@name], *@arguments) : data[@name])
			return @template.apply_all(array).join(@delimeter)
		end

		# Throws TypeError
		# 
		# Parameter: first - true if the placeholder is the first of it's kind
		def regex(first=true); raise TypeError.new("Array Templates cannot be matched."); end

		# Returns the string representation of the array placeholder
		#
		# Parameter: first - true if the placeholder is the first of it's kind
		#
		# Return: the string representation of the array placeholder
		def string(first=true)
			str = "@[#{@name}"
			if @operation
				str += " -> #{@operation}"
				unless @arguments.empty?
					str += @arguments.collect{|s| " \"#{s}\""}.join
				end
			end
			return str + "] #{@template.to_s} @[#{@delimeter.inspect[1...-1]}]"
		end
	end
end