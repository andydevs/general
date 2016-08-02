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

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
	# Represents a plain text partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	class GText < GPartial
		# Regular expression that matches text partials
		REGEX = /\A[^@]+?(?=(@|\\@|\z))/m

		# The partial name of a text
		PTNAME = :gpartialstring

		# Initializes the GText with the given match
		#
		# Parameter: match - the match object of the GText
		def initialize(match)
			super name: PTNAME
			@text = match.to_s
		end
		
		# Returns the text
		#
		# Parameter: data - the data to apply to the partial
		#
		# Returns: the text
		def apply(data); @text; end

		# Returns the text as a string
		#
		# Parameter: first - true if this partial is the first of it's kind in a GTemplate
		#
		# Returns: the text as a string
		def string(first=true); @text.inspect[1...-1]; end

		# Returns the text as a regex
		#
		# Parameter: first - true if this partial is the first of it's kind in a GTemplate
		#
		# Returns: the text as a regex
		def regex(first=true); @text.inspect[1...-1].gsub(/[\.\+\-\*]/) { |s| "\\#{s}" }; end
	end

	# Represents a special character in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 29 - 2016
	class GSpecial < GText
		# Regular expression that matches special partials
		REGEX = /\A@(?<key>\w+)\;/

		# Special character information
		SPECIALS = {
			at: "@",  pd: "#",
			lt: "<",  gt: ">",
			op: "(",  cp: ")",
			ob: "[",  cb: "]",
			oc: "{",  cc: "}",
			ms: "-",  ps: "+", 
			st: "*",  pc: "%",
			bs: "\\", fs: "/",
			dl: "$",
		}

		# Initializes the GSpecial with the given match
		#
		# Parameter: match - the match object of the GSpecial
		def initialize(match)
			super SPECIALS[match[:key].to_sym]
		end
	end
end