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
	# Inserts the full data value passed into the template
	#
	# Author:  Anshul Kharbanda
	# Created: 1 - 19 - 2016
	class GFullPlaceholder < GPartial
		# Matches GFullPlaceholders
		REGEX = /@/

		# Initializes the GFullPlaceholder with the given match
		#
		# Parameter: match - the match data from the string being parsed
		# Parameter: defaults - the hash of default data from the GTemplate
		def initialize(match, defaults={}); super({name: :__full}, defaults); end

		# Returns a string representation of the given data
		#
		# Parameter: data - the data being applied
		#
		# Returns: a string representation of the given data 
		def apply(data); data.to_s; end

		# Returns a string representation of the GFullPlaceholder
		#
		# Parameter: first - true if this is the first in a given template 
		#
		# Returns: a string representation of the GFullPlaceholder
		def string(first=false); "@"; end

		# Raises TypeError
		#
		# Parameter: first - true if this is the first in a given template 
		#
		# Raises: TypeError
		def regex(first=false); raise TypeError.new("GFullPlaceholder cannot be matched"); end
	end
end