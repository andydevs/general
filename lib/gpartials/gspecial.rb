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

require_relative "gtext"

# General is a templating system in ruby
#
# Author: Anshul Kharbanda
# Created: 3 - 4 - 2016
module General
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
			dl: "$"
		}

		# Special regex information
		REGEXES = {
			at: /@/,   pd: /#/,
			lt: /\</, gt: /\>/,
			op: /\(/, cp: /\)/,
			ob: /\[/, cb: /\]/,
			oc: /\{/, cc: /\}/,
			ms: /\-/, ps: /\+/, 
			st: /\*/, pc: /\%/,
			bs: /\\/, fs: /\//,
			dl: /\$/
		}

		# Initializes the GSpecial with the given match
		#
		# Parameter: match - the match object of the GSpecial
		# Parameter: defaults - the hash of default data from the GTemplate
		def initialize(match, defaults={})
			super SPECIALS[match[:key].to_sym], {}
			@key = match[:key].to_sym
		end
		
		# Returns the string representation of the GSpecial
		#
		# Parameter: first - true if this partial is the first of it's kind in a GTemplate
		#
		# Returns: the string representation of the GSpecial
		def string(first=true); "@#{@key.to_s};"; end

		# Returns the GSpecial as a regex
		#
		# Parameter: first - true if this partial is the first of it's kind in a GTemplate
		#
		# Returns: the GSpecial as a regex
		def regex(first=true); REGEXES[@key]; end
	end
end