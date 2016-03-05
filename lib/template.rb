# Generic is a templating system in ruby
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

# Generic is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module Generic
	# Implements the generic templating system for strings
	#
	# Author: Anshul Kharbanda
	# Created: 3 - 4 - 2016
	class GTemplate
		# Regular expression that matches placeholders
		PLACEHOLDER = /@\((?<name>[a-zA-Z]\w*) *(\: *(?<default>[^\t\n\r\f]*?))?\)/

		# Creates a GTemplate with the given template string
		#
		# Parameter: string - the string being converted to a template
		def initialize string
			@parts    = []
			@indeces  = {}
			@defaults = {}
			
			while Generic::GTemplate::PLACEHOLDER =~ string
				match = Generic::GTemplate::PLACEHOLDER.match string
				@parts << string[0...match.begin(0)] << match
				string = string[match.end(0)..-1]
				
				@indeces[match[:name].to_sym]  = @parts.length - 1
				@defaults[match[:name].to_sym] = match[:default]
			end
			@parts << string
		end

		# Returns a string representation of the string
		#
		# Return: a string representation of the string
		def to_s; @parts.join; end

		# Returns the template with the given data applied
		#
		# Parameter: data - the data to be applied (merges with defaults)
		#
		# Return: the template with the given data applied
		def apply data={}
			applied_data = @defaults.merge data
			applied_parts = @parts.clone
			applied_data.each do |key, value|
				applied_parts[@indeces[key]] = value
			end
			return applied_parts.join
		end
	end
end