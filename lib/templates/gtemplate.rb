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

require_relative "gbasetemplate"
require_relative "../gpartials/gtext"
require_relative "../gpartials/gplaceholder"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Implements the general templating system for strings
	#
	# Author: Anshul Kharbanda
	# Created: 3 - 4 - 2016
	class GTemplate < GBaseTemplate
		# Creates a GTemplate with the given template string
		#
		# Parameter: string - the string being converted to a template
		def initialize string
			super(string)
			@defaults = General::GDotHash.new

			# The string gets split into partials by placeholder and array template
			loop do
				if match = General::GText::REGEX.match(string)
					@partials << General::GText.new(match)
				elsif match = General::GSpecial::REGEX.match(string)
					@partials << General::GSpecial.new(match)
				elsif match = General::GArrayPlaceholder::REGEX.match(string)
					@partials << General::GArrayPlaceholder.new(match)
				elsif match = General::GPlaceholder::REGEX.match(string)
					@partials << General::GPlaceholder.new(match, @defaults)
				else
					return
				end
				string = string[match.end(0)..-1]
			end
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
				hash = match.names.collect { |name|
					[name.to_sym, match[name.to_sym]]
				}.to_h
				yield hash if block_given?
				return hash
			end
		end
	end
end