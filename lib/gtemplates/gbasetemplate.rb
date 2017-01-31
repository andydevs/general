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

require_relative "../gdothash"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# The base class for General template objects
	# Implementing objects must define a :apply method
	# Which applies the GTemplate to an object
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 30 - 2016
	class GBaseTemplate
		# Initializes the GBaseTemplate with the given string
		#
		# Parameter: string   - the string to initialize the GBaseTemplate with
		# Parameter: partials - the partials used to parse the GBaseTemplate string
		def initialize string, partials
			# Variables
			@partials = []
			@defaults = General::GDotHash.new

			# Partial breakdown algorithm
			m = nil
			loop do
				# Match the front of the string to a partial
				partial = partials.find { |partial| m = partial::REGEX.match(string) }

				# Raise error if no matching partial can be found
				raise GError.new("Unmatched partial at #{(string.length <= 5 ? string : string[0..5] + "...").inspect}") if partial.nil?
				
				# Add the partial to the array
				@partials << partial.new(m, @defaults)

				# Trim the front of the string
				string = string[m.end(0)..-1]

				# End when string is empty
				return if string.length == 0
			end
		end

		# Applies the given data to the template and returns the generated string
		#
		# Parameter: data - the data to be applied (as a hash. merges with defaults)
		#
		# Return: string of the template with the given data applied
		def apply data={}
			# Apply generalized data if can be generalized. Else apply regular data
			if data.respond_to? :generalized
				return apply(data.generalized)
			else
				return @partials.collect { |part| part.apply(data) }.join
			end
		end

		# Applies each data structure in the array independently to the template
		# and returns an array of the generated strings
		#
		# Parameter: array - the array of data to be applied 
		# 				     (each data hash will be merged with defaults)
		#
		# Return: array of strings generated from the template with the given 
		# 		  data applied
		def apply_all array
			array.collect { |data| apply(data) }
		end

		# Returns a string representation of the template
		#
		# Return: a string representation of the template
		def to_s
			first = Hash.new(true); str = ""
			@partials.each do |part|
				str += part.string(first[part.name])
				first[part.name] &&= false
			end
			return str
		end
	end
end