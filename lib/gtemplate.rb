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
	# Implements the general templating system for strings
	#
	# Author: Anshul Kharbanda
	# Created: 3 - 4 - 2016
	class GTemplate
		# Regular expression that matches placeholders
		PLACEHOLDER = /@\((?<name>[a-zA-Z]\w*)\s*(\:\s*(?<default>.*?))?\s*(->\s*(?<operation>[a-zA-Z]\w*))?\)/

		# Regular expression that matches array placeholders
		ARRAY_PLACEHOLDER = /@\[(?<name>[a-zA-Z]\w*)\]\s*(?<text>.*?)\s*@\[(?<delimeter>.+)?\]/m

		# Operations that can be called on placeholder values
		OPERATIONS = {
			# String operations
			default: 	  lambda { |string| return string },
			capitalize:   lambda { |string| return string.split(" ")
													   	 .collect(&:capitalize)
													   	 .join(" ") },
			uppercase:    lambda { |string| return string.uppercase },
			lowercase:    lambda { |string| return string.lowercase },

			# Integer operations
			dollars: 	  lambda { |integer| return "$" + (integer * 0.01).to_s },
			hourminsec:   lambda { |integer| return (integer / 3600).to_s \
											+ ":" + (integer % 3600 / 60).to_s \
											+ ":" + (integer % 3600 % 60).to_s }
		}

		# Creates a GTemplate with the given template string
		#
		# Parameter: string - the string being converted to a template
		def initialize string
			@parts    	= []
			@places   	= {}
			@defaults 	= {}
			@operation  = {}
			@array    	= Hash.new(false)

			parse_string string
		end

		# Returns a string representation of the string
		#
		# Return: a string representation of the string
		def to_s; @parts.join; end

		# Applies the given data to the template and returns the generated string
		#
		# Parameter: data - the data to be applied (as a hash. merges with defaults)
		#
		# Return: string of the template with the given data applied
		def apply data={}
			applied_data = @defaults.merge data.to_hash
			applied_parts = @parts.clone
			applied_data.each do |key, value|
				if @places.has_key? key
					@places[key].each do |place|
						if @array[key]
							applied_parts[place[:index]] = place[:template].apply_all(value).join(place[:delimeter])
						else
							applied_parts[place[:index]] = place[:operation].call(value)			
						end
					end
				else
					throw "Placeholder is not defined in template: @(#{key})"
				end
			end
			return applied_parts.join
		end

		# Applies each data structure in the array independently to the template
		# and returns an array of the generated strings
		#
		# Parameter: data_array - the array of data to be applied 
		# 						  (each data hash will be merged with defaults)
		#
		# Return: array of strings generated from the template with the given data applied
		def apply_all data_array
			string_array = []
			data_array.each do |data|
				string_array << apply(data)
			end
			return string_array
		end

		private

		# Returns true if given string has a placeholder
		#
		# Parameter: string - the string to check for a placeholder
		#
		# Return: true if given string has a placeholder
		def has_placeholder string
			return PLACEHOLDER =~ string || ARRAY_PLACEHOLDER =~ string
		end

		# Parses the string into General template data
		#
		# Parameter: string - the string to parse
		def parse_string string
			# While there is still a placeholder in string
			while has_placeholder string
				if ARRAY_PLACEHOLDER =~ string
					# Split match and add parts
					match = ARRAY_PLACEHOLDER.match string
					@parts << string[0...match.begin(0)] << match
					string = string[match.end(0)..-1]

					# Get name
					name = match[:name].to_sym

					# Get delimeter (if any) and parse array template
					delimeter = match[:delimeter].nil? ? " " : match[:delimeter]
					template = GTemplate.new(match[:text])

					# Push place and array information
					push_place name, {index: @parts.length - 1, template: template, delimeter: delimeter}
					@array[name] = true
				elsif PLACEHOLDER =~ string
					# Split match and add parts
					match = PLACEHOLDER.match string
					@parts << string[0...match.begin(0)] << match
					string = string[match.end(0)..-1]

					# Get name
					name = match[:name].to_sym

					# Get operation and arguments (if any)
					operation = match[:operation].nil? ? OPERATIONS[:default] : OPERATIONS[match[:operation].to_sym]
					
					# Push place and default information
					push_place name, {index: @parts.length - 1, operation: operation}
					@defaults[name] = match[:default] unless @defaults.has_key? name
				end
			end
			
			# Add end of string
			@parts << string
		end

		# Adds the given place for the placeholder of the given name
		#
		# Parameter: name  - the name of the placeholder add a place to
		# Parameter: place - the place information to add
		def push_place name, place
			if @places.has_key? name
				@places[name] << place
			else
				@places[name] = [place]
			end
		end
	end
end

tem = General::GTemplate.new "There once was a dog named @(name: dog -> capitalize). @(name -> capitalize) earned @(amount -> dollars) last week."
puts tem