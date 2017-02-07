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

require_relative "spec_require"

# Represents a placeholder partial in a GTemplate
#
# Author:  Anshul Kharbanda
# Created: 7 - 1 - 2016
describe General::GPlaceholder do
	before :all do
		# Placename
		@placename1 = :plac1
		@placename2 = :plac2
		@placename3 = :plac3
		@placename4 = :plac4
		@placename5 = :"plac5.subarg"

		# Hash
		@hash = General::GDotHash.new
		@hash[@placename1] = "foobar"
		@hash[@placename3] = "barbaz"
		@hash[@placename4] = "jujar"
		@hash[@placename5] = "dudar"

		# Default hash
		@defaults = General::GDotHash.new
		
		# ------------PLACEHOLDER------------
		@result1 = @hash[@placename1]
		@partial1 = General::GPlaceholder.new [
			[:name, @placename1]
		].to_h, @defaults
		@string1       = "@(#{@placename1})"
		@string_first1 = "@(#{@placename1})"
		@regex1        = "\\k<#{@placename1}>"
		@regex_first1  = "(?<#{@placename1}>.*)"

		# --------------DEFAULT--------------
		@default2 = "foo2"
		@result2  = "foo2"
		@partial2 = General::GPlaceholder.new [
			[:name,    @placename2],
			[:default, @default2]
		].to_h, @defaults
		@string2       = "@(#{@placename2})"
		@string_first2 = "@(#{@placename2}:" \
					   + " #{@default2})"
		@regex2        = "\\k<#{@placename2}>"
		@regex_first2  = "(?<#{@placename2}>.*)"
		
		# -------------OPERATION-------------
		@operation3 = "capitalize"
		@result3  = General::GOperations.send(
			@operation3.to_sym, 
			@hash[@placename3]
		)
		@partial3 = General::GPlaceholder.new [
			[:name, 	 @placename3],
			[:operation, @operation3]
		].to_h, @defaults
		@string3       = "@(#{@placename3})"
		@string_first3 = "@(#{@placename3}" \
					   + " -> #{@operation3})"
		@regex3        = "\\k<#{@placename3}>"
		@regex_first3  = "(?<#{@placename3}>.*)"
		
		# -------------ARGUMENTS-------------
		@operation4 = "capitalize"
		@arguments4 = ["all"]
		@result4 = General::GOperations.send(
			@operation4.to_sym,
			@hash[@placename4],
			*@arguments4
		)
		@partial4 = General::GPlaceholder.new [
			[:name, 	 @placename4],
			[:operation, @operation4],
			[:arguments, @arguments4.join(" ")]
		].to_h, @defaults
		@string4       = "@(#{@placename4})"
		@string_first4 = "@(#{@placename4}" \
					   + " -> #{@operation4} " \
					   + "#{@arguments4.collect {|s| "\"#{s}\""}.join " "})"
		@regex4        = "\\k<#{@placename4}>"
		@regex_first4  = "(?<#{@placename4}>.*)"

		# -----------DOT NOTATION------------
		keys      = @placename5.to_s.split(".").collect(&:to_sym)
		@result5  = @hash[keys[0]][keys[1]]
		@partial5 = General::GPlaceholder.new [
			[:name,  @placename5]
		].to_h, @defaults
		@string5       = "@(#{@placename5})"
		@string_first5 = "@(#{@placename5})"
		@regex5        = "\\k<#{@placename5}>"
		@regex_first5  = "(?<#{@placename5}>.*)"
	end

	# Describe General::GPlaceholder::new
	# 
	# Initializes the GPlaceholder with the given match
	# 
	# Parameter: match - the match data from the string being parsed
	describe '::new' do
		it 'creaes a GPlaceholder with the given data' do
			# -------------------------------------PLACEHOLDER---------------------------------------
			expect(@partial1).to be_an_instance_of General::GPlaceholder
			expect(@partial1.instance_variable_get :@name).to eql @placename1
			expect(@partial1.instance_variable_get :@operation).to be_nil
			expect(@partial1.instance_variable_get :@arguments).to be_empty

			# ---------------------------------------DEFAULT-----------------------------------------
			expect(@partial2).to be_an_instance_of General::GPlaceholder
			expect(@partial2.instance_variable_get :@name).to eql @placename2
			expect(@partial2.instance_variable_get :@operation).to be_nil
			expect(@partial2.instance_variable_get :@arguments).to be_empty
			expect(@defaults[@placename2]).to eql @default2

			# --------------------------------------OPERATION----------------------------------------
			expect(@partial3).to be_an_instance_of General::GPlaceholder
			expect(@partial3.instance_variable_get :@name).to eql @placename3
			expect(@partial3.instance_variable_get :@operation).to eql @operation3
			expect(@partial3.instance_variable_get :@arguments).to be_empty

			# --------------------------------------ARGUMENTS----------------------------------------
			expect(@partial4).to be_an_instance_of General::GPlaceholder
			expect(@partial4.instance_variable_get :@name).to eql @placename4
			expect(@partial4.instance_variable_get :@operation).to eql @operation4
			expect(@partial4.instance_variable_get :@arguments).to eql @arguments4

			# -------------------------------------DOT NOTATION--------------------------------------
			expect(@partial5).to be_an_instance_of General::GPlaceholder
			expect(@partial5.instance_variable_get :@name).to eql @placename5
			expect(@partial5.instance_variable_get :@operation).to be_nil
			expect(@partial5.instance_variable_get :@arguments).to be_empty
		end
	end

	# Describe General::GPlaceholder#apply
	# 
	# Returns the value of the placeholder in the given data 
	# with the given operation performed on it
	#
	# Parameter: data - the data being applied
	#
	# Return: the value of the placeholder in the given data 
	# 		  with the given operation performed on it
	describe '#apply' do
		it 'returns the value in the data/default at the name (with operation and arguments applied if given)' do
			expect(@partial1.apply @hash).to eql @result1
			expect(@partial2.apply @hash).to eql @result2
			expect(@partial3.apply @hash).to eql @result3
			expect(@partial4.apply @hash).to eql @result4
			expect(@partial5.apply @hash).to eql @result5
		end
	end

	# Describe General::GTemplate#string
	#
	# Returns the string representation of the placeholder
	#
	# Parameter: first - true if the placeholder is the first of its kind in the GTemplate
	#
	# Return: the string representation of the placeholder
	describe '#string' do
		# -------------------------------------NO FIRST---------------------------------------
		it 'returns the first string representation of the placeholder by default' do
			expect(@partial1.string).to eql @string_first1
			expect(@partial2.string).to eql @string_first2
			expect(@partial3.string).to eql @string_first3
			expect(@partial4.string).to eql @string_first4
		end

		# ------------------------------------TRUE FIRST--------------------------------------
		it 'returns the first string representation of the placeholder when first is true' do
			expect(@partial1.string true).to eql @string_first1
			expect(@partial2.string true).to eql @string_first2
			expect(@partial3.string true).to eql @string_first3
			expect(@partial4.string true).to eql @string_first4
		end

		# -----------------------------------FALSE FIRST--------------------------------------
		it 'returns the string representation of the placeholder when first is false' do
			expect(@partial1.string false).to eql @string1
			expect(@partial2.string false).to eql @string2
			expect(@partial3.string false).to eql @string3
			expect(@partial4.string false).to eql @string4
		end
	end

	# Describe General::GTemplate#regex (depricated)
	#
	# Returns the string as a regex
	#
	# Parameter: first - true if the placeholder is the first of its kind in the GTemplate
	#
	# Returns: the string as a regex
	describe '#regex (depricated)' do
		# -------------------------------------NO FIRST---------------------------------------
		it 'returns the first regex representation of the placeholder by default' do
			expect(@partial1.regex).to eql @regex_first1
			expect(@partial2.regex).to eql @regex_first2
			expect(@partial3.regex).to eql @regex_first3
			expect(@partial4.regex).to eql @regex_first4
		end

		# ------------------------------------TRUE FIRST--------------------------------------
		it 'returns the first regex representation of the placeholder when first is true' do
			expect(@partial1.regex true).to eql @regex_first1
			expect(@partial2.regex true).to eql @regex_first2
			expect(@partial3.regex true).to eql @regex_first3
			expect(@partial4.regex true).to eql @regex_first4
		end

		# -----------------------------------FALSE FIRST--------------------------------------
		it 'returns the regex representation of the placeholder when first is false' do
			expect(@partial1.regex false).to eql @regex1
			expect(@partial2.regex false).to eql @regex2
			expect(@partial3.regex false).to eql @regex3
			expect(@partial4.regex false).to eql @regex4
		end
	end
end