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

		# Regular expression that matches placeholder defaults
		DEFAULT = /(\:\s*(?<default>[^(\-\>)]+))/

		public

		# Regular expression that matches placeholders
		REGEX = /@\(\s*#{NAME}\s*#{DEFAULT}?\s*(#{OPERATION}\s*#{ARGUMENTS}?)?\s*\)/

		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match    - the match data from the string being parsed
		# Parameter: defaults - the hash of default data from the GTemplate
		def initialize match, defaults
			super match, defaults
			@operation = match[:operation]
			if match[:arguments]
				@arguments = match[:arguments].gsub(ARGUMENT).collect { |arg|
					ARGUMENT.match(arg)[:text]
				}
			else
				@arguments = []
			end
			@defaults = defaults
			@defaults[@name] = match[:default] unless @defaults.has_key? @name
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
			if data.has_key? @name
				value = data[@name]
			else
				value = @defaults[@name]
			end

			# Return value (operation performed if one is defined)
			return (@operation ? General::GOperations.send(@operation, value, *@arguments) : value).to_s
		end

		# Returns the string as a regex
		#
		# Parameter: first - true if the placeholder is the first of its kind in the GTemplate
		#
		# Returns: the string as a regex
		def regex(first=true); first ? "(?<#{@name.to_s}>.*)" : "\\k<#{@name.to_s}>"; end

		# Returns the string representation of the placeholder
		#
		# Parameter: first - true if the placeholder is the first of its kind in the GTemplate
		#
		# Return: the string representation of the placeholder
		def string first=true
			str = "@(#{@name}"
			if first
				if @defaults[@name]
					str += ": #{@defaults[@name]}"
				end
				if @operation
					str += " -> #{@operation}"
					unless @arguments.empty?
						str += @arguments.collect {|s| " \"#{s}\""}.join
					end
				end
			end
			return str + ")"
		end
	end
end