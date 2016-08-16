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
require_relative "../gpartials/gtimeformatplaceholder"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# A special template used for formatting time strings
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 2 - 2016
	class GTimeFormat < GBaseTemplate
		# Initialize the GTimeFormat with the given string
		#
		# Parameter: string - the template string
		def initialize string
			super string

			loop do
				if match = General::GText::REGEX.match(string)
					@partials << General::GText.new(match)
				elsif match = General::GTimeFormatPlaceholder::REGEX.match(string)
					@partials << General::GTimeFormatPlaceholder.new(match)
				else
					return
				end
				string = string[match.end(0)..-1]
			end
		end

		# Applies the given integer value to the template and returns the generated string
		#
		# Parameter: value - the value to be applied (as a hash. merges with defaults)
		#
		# Return: string of the template with the given value applied
		def apply value
			if value.is_a? Integer
				super value
			else
				raise TypeError.new "Expected Integer, got: #{value.class}"
			end
		end
	end
end