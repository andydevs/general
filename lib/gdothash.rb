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
	# Wrapper for hash objects which implements dot notation
	#
	# Author:  Anshul Kharbanda
	# Created: 9 - 27 - 2016
	class GDotHash
		# Initializes the given GDotHash with the given hash
		#
		# Parameter: hash - the hash being manipulated
		def initialize(hash={}); @hash = hash; end

		# Returns the string representation of the hash
		#
		# Return: the string representation of the hash
		def to_s; @hash.to_s; end

		# Returns true if the GDotHash contains the given key
		# 
		# Parameter: key - the key to check
		#
		# Return: true if the GDotHash contains the given key
		def has_key? key
			# Split keys
			subkeys = key.to_s.split(".").collect(&:to_sym)

			# Check each subkey
			sub = @hash
			subkeys.each do |subkey|
				# Return false if subhash doesn't contain key
				# Else continue
				if sub.is_a?(Hash) && sub.has_key?(subkey)
					sub = sub[subkey]
				else
					return false
				end
			end

			# Return true if passed
			return true
		end

		# Gets the value at the given key
		#
		# Parameter: key - the key to return
		#
		# Return: the value at the given key
		def [] key
			# Split keys
			subkeys = key.to_s.split(".").collect(&:to_sym)

			# Travel down to value
			get = @hash
			subkeys.each do |subkey|
				if get.is_a?(Hash) && get.has_key?(subkey)
					get = get[subkey]
				else
					raise ArgumentError, "key is not defined in hash: #{key}"
				end
			end

			# Return value
			return get
		end

		# Sets the given key to the given value
		# 
		# Parameter: key   - the key to set
		# Parameter: value - the value to set
		def []= key, value
			# Split subkeys
			subkeys = key.to_s.split(".").collect(&:to_sym)

			# Generate structure of new data
			new_data = Hash.new
			sub = new_data
			subkeys[0...-1].each do |subkey|
				sub[subkey] = Hash.new
				sub = sub[subkey]
			end
			sub[subkeys[-1]] = value

			# Merge hash with new data
			@hash.merge! new_data
		end
	end
end