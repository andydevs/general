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

# Require
require_relative "goperations"
require_relative "gpartials"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Implements the general templating system for strings
	#
	# Author: Anshul Kharbanda
	# Created: 3 - 4 - 2016
	class GTemplate
		# Creates a GTemplate with the given template string
		#
		# Parameter: string - the string being converted to a template
		def initialize string
			# The string gets split into partials by placeholder and array template
			@partials = []
			@defaults = {}

			# Parse the string
			parse_string string
		end

		# Returns a string representation of the string
		#
		# Return: a string representation of the string
		def to_s
			first = Hash.new(true); str = ""
			@partials.each do |part|
				str += part.string(first[part.name])
				first[part.name] &&= false
			end
			return str
		end

		# Applies the given data to the template and returns the generated string
		#
		# Parameter: data - the data to be applied (as a hash. merges with defaults)
		#
		# Return: string of the template with the given data applied
		def apply(data={}); @partials.collect { |partial| partial.apply(data) }.join; end

		# Applies each data structure in the array independently to the template
		# and returns an array of the generated strings
		#
		# Parameter: array - the array of data to be applied 
		# 				     (each data hash will be merged with defaults)
		#
		# Return: array of strings generated from the template with the given 
		# 		  data applied
		def apply_all(array); array.collect { |data| apply(data) }; end

		# Returns the string as a regex
		#
		# Returns: the string as a regex
		def regex sub=false
			first = Hash.new(true); str = ""
			@partials.each do |part|
				str += part.regex(first[part.name]);
				first[part.name] &&= false
			end
			return sub ? str : Regexp.new("\\A" + str + "\\z")
		end

		# Matches the given string against the template and returns the 
		# collected information. Returns nil if the given string does 
		# not match.
		#
		# If a block is given, it will be run with the generated hash
		# if the string matches. Alias for:
		# 
		# if m = template.match(string)
		# 	 # Run block
		# end
		# 
		# Parameter: string the string to match
		# 
		# Return: Information matched from the string or nil
		def match string
			regex.match(string) do |match|
				hash = match.names.collect { |name| [name.to_sym, match[name.to_sym]] }.to_h
				yield hash if block_given?
				return hash
			end
		end

		private

		# Returns true if given string has a placeholder
		#
		# Parameter: string - the string to check for a placeholder
		#
		# Return: true if given string has a placeholder
		def has_next string
			next_p = General::GPlaceholder::REGEX      =~ string
			next_a = General::GArrayPlaceholder::REGEX =~ string
			return !((next_p.nil? || next_p < 0) && (next_a.nil? || next_a < 0))
		end

		# Returns true if the next placeholder is an aray placeholder
		#
		# Parameter: string - the string to check for an array placeholder
		#
		# Return: true if the next placeholder is an aray placeholder
		def next_array_placeholder string
			next_p = General::GPlaceholder::REGEX      =~ string
			next_a = General::GArrayPlaceholder::REGEX =~ string
			return !(next_a.nil? || next_p.nil?) && next_a < next_p
		end

		# Parses the string into General template data
		#
		# Parameter: string - the string to parse
		def parse_string string
			# While there is still a placeholder or array placeholder in string
			while has_next string
				# If next is array placeholder, process array placeholder
				if next_array_placeholder string
					# Split match and add partials
					match = General::GArrayPlaceholder::REGEX.match string
					@partials << General::GPartialString.new(string, match) \
							  << General::GArrayPlaceholder.new(match)

				# Else process placeholder
				else
					# Split match and add partials
					match = General::GPlaceholder::REGEX.match string
					@partials << General::GPartialString.new(string, match) \
							  << General::GPlaceholder.new(match, @defaults)
					
					# Push default information
					@defaults[match[:name].to_sym] ||= match[:default]
				end

				# Trim string
				string = string[match.end(0)..-1]
			end
			
			# Add end of string
			@partials << General::GPartialString.new(string)
		end
	end
end