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

# Describe General Partials
# 
# The system with which General parses and applies Templates
#
# Author:  Anshul Kharbanda
# Created: 7 - 29 - 2016
describe 'General Partials' do
	before :all do
		@placename1 = :plac1
		@placename2 = :plac2
		@placename3 = :plac3
		@placename4 = :plac4
		@arrayname1 = :aray1

		@hash = { 
		  	@placename1 => "foobar",
		  	@placename3 => "barbaz",
		  	@placename4 => "jujar",
			@arrayname1 => [
		  		{subarg: "ju"}, 
		  		{subarg: "jar"},
		  		{subarg: "jaz"}
		  	]
		}
	end

	# Describe General::GPartial
	# 
	# A unit of the GTemplate. Returns a string based on an argument hash
	# When GTemplate is applied
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 29 - 2016
	describe General::GPartial do
		before :all do
			@name = :partial_name
			@partial = General::GPartial.new name: @name
		end

		# Describe General::GPartial::new
		#
		# Creates the GPartial with the given object
		#
		# Parameter: obj - the object containing information for the partial
		describe '::new' do
			it 'creates the GPartial wih the given object' do
				expect(@partial).to be_an_instance_of General::GPartial
				expect(@partial.instance_variable_get :@name).to eql @name
			end
		end

		# Describe General::GPartial#name
		#
		# Returns the name of the partial
		#
		# Return: the name of the partial
		describe '#name' do
			it 'returns the name of the GPartial' do
				expect(@partial.name).to eql @name
			end
		end
	end

	# Describe General Text Partials
	#
	# Regular text parts of a General Template
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 29 - 2016
	describe 'General Text Partials' do
		# Describe General::GText
		# 
		# Represents a plain text partial in a GTemplate
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 1 - 2016
		describe General::GText do
			before :all do
				@text = "foobar"
				@regex = "foobar"
				@partial = General::GText.new @text
			end

			# Describe General::GText::new
			# 
			# Creates the GText with the given match
			#
			# Parameter: match - the match object of the GText
			describe '::new' do
				it 'creates the GText with the given to_s representable object' do
					expect(@partial).to be_an_instance_of General::GText
					expect(@partial.name).to eql General::GText::PTNAME
					expect(@partial.instance_variable_get :@text).to eql @text
				end
			end

			# Describe General::GText#apply
			#
			# Returns the text
			#
			# Parameter: data - the data to apply to the partial
			#
			# Returns: the text
			describe '#apply' do
				it 'returns the GText string, given a hash of data' do
					expect(@partial.apply @hash).to eql @text
				end
			end

			# Describe General::GText#string
			#
			# Returns the text as a string
			#
			# Parameter: first - true if this partial is the first of it's kind in a GTemplate
			#
			# Returns: the text as a string
			describe '#string' do
				context 'with no first argument given' do
					it 'returns the string' do
						expect(@partial.string).to eql @text
					end
				end

				context 'with first argument given' do
					context 'if first argument is true' do
						it 'returns the string' do
							expect(@partial.string true).to eql @text
						end
					end

					context 'if first argument is false' do
						it 'returns the string' do
							expect(@partial.string false).to eql @text
						end
					end
				end
			end

			# Describe General::GText#regex
			# 
			# Returns the text as a regex
			#
			# Parameter: first - true if this partial is the first of it's kind in a GTemplate
			#
			# Returns: the text as a regex
			describe '#regex' do
				context 'with no first argument given' do
					it 'returns the regex' do
						expect(@partial.regex).to eql @regex
					end
				end

				context 'with first argument given' do
					context 'if first argument is true' do
						it 'returns the regex' do
							expect(@partial.regex true).to eql @regex
						end
					end

					context 'if first argument is false' do
						it 'returns the regex' do
							expect(@partial.regex false).to eql @regex
						end
					end
				end
			end
		end

		# Describe General::GSpecial
		# 
		# Represents a special character in a GTemplate
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 1 - 2016
		describe General::GSpecial do
			before :all do
				@text    = "@"
				@regex   = "@"
				@partial = General::GSpecial.new key: "at"
			end

			# Describe General::GSpecial::new
			# 
			# Creates the GSpecial with the given match
			#
			# Parameter: match - the match object of the GSpecial
			describe '::new' do
				it 'creates the GSpecial with the given match object' do
					expect(@partial).to be_an_instance_of General::GSpecial
					expect(@partial.name).to eql General::GSpecial::PTNAME
					expect(@partial.instance_variable_get :@text).to eql @text
				end
			end
		end
	end

	# Describe General Placeholder Partials
	#
	# Placeholder parts in a General Template
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	describe 'General Placeholder Partials' do
		# Represents a placeholder partial in a GTemplate
		#
		# Author:  Anshul Kharbanda
		# Created: 7 - 1 - 2016
		describe General::GPlaceholder do
			before :all do
				# Default hash
				@defaults = {}
				
				# ------------PLACEHOLDER------------
				@partial1 = General::GPlaceholder.new [
					[:name, @placename1]
				].to_h, @defaults
				@string1       = "@(#{@partial1.name})"
				@string_first1 = "@(#{@partial1.name})"
				@regex1        = "\\k<#{@partial1.name}>"
				@regex_first1  = "(?<#{@partial1.name}>.*)"

				# --------------DEFAULT--------------
				@default2 = "foo2"
				@partial2 = General::GPlaceholder.new [
					[:name,    @placename2],
					[:default, @default2]
				].to_h, @defaults
				@string2       = "@(#{@partial2.name})"
				@string_first2 = "@(#{@partial2.name}:" \
							   + " #{@default2})"
				@regex2        = "\\k<#{@partial2.name}>"
				@regex_first2  = "(?<#{@partial2.name}>.*)"
				
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
				@string3       = "@(#{@partial3.name})"
				@string_first3 = "@(#{@partial3.name}" \
							   + " -> #{@operation3})"
				@regex3        = "\\k<#{@partial3.name}>"
				@regex_first3  = "(?<#{@partial3.name}>.*)"
				
				# -------------ARGUMENTS-------------
				@operation4 = "capitalize"
				@arguments4 = ["all"]
				@result4  = General::GOperations.send(
					@operation4.to_sym,
					@hash[@placename4],
					*@arguments4
				)
				@partial4 = General::GPlaceholder.new [
					[:name, 	 @placename4],
					[:operation, @operation4],
					[:arguments, @arguments4.join(" ")]
				].to_h, @defaults
				@string4       = "@(#{@partial4.name})"
				@string_first4 = "@(#{@partial4.name}" \
							   + " -> #{@operation4} " \
							   + "#{@arguments4.join " "})"
				@regex4        = "\\k<#{@partial4.name}>"
				@regex_first4  = "(?<#{@partial4.name}>.*)"
			end

			# Describe General::GPlaceholder::new
			# 
			# Initializes the GPlaceholder with the given match
			# 
			# Parameter: match - the match data from the string being parsed
			describe '::new' do
				# -------------------------------------PLACEHOLDER---------------------------------------
				context 'with name given' do
					it 'creaes a GPlaceholder with the given name' do
						expect(@partial1).to be_an_instance_of General::GPlaceholder
						expect(@partial1.instance_variable_get :@name).to eql @placename1
						expect(@partial1.instance_variable_get :@operation).to be_nil
						expect(@partial1.instance_variable_get :@arguments).to be_empty
					end
				end

				# ---------------------------------------DEFAULT-----------------------------------------
				context 'with name and default in match object' do
					it 'creates a GPlaceholder with the given name and default' do
						expect(@partial2).to be_an_instance_of General::GPlaceholder
						expect(@partial2.instance_variable_get :@name).to eql @placename2
						expect(@partial2.instance_variable_get :@operation).to be_nil
						expect(@partial2.instance_variable_get :@arguments).to be_empty
						expect(@defaults[@placename2]).to eql @default2
					end
				end

				# --------------------------------------OPERATION----------------------------------------
				context 'with name, default, and operation in match object' do
					it 'creates a GPlaceholder with the given name, default, and operation' do
						expect(@partial3).to be_an_instance_of General::GPlaceholder
						expect(@partial3.instance_variable_get :@name).to eql @placename3
						expect(@partial3.instance_variable_get :@operation).to eql @operation3
						expect(@partial3.instance_variable_get :@arguments).to be_empty
						expect(@defaults[@placename3]).to eql @default3
					end
				end

				# --------------------------------------ARGUMENTS----------------------------------------
				context 'with name, default, operation, and arguments in match object' do
					it 'creates a GPlaceholder with the given name, default, operation, and arguments' do
						expect(@partial4).to be_an_instance_of General::GPlaceholder
						expect(@partial4.instance_variable_get :@name).to eql @placename4
						expect(@partial4.instance_variable_get :@operation).to eql @operation4
						expect(@partial4.instance_variable_get :@arguments).to eql @arguments4
						expect(@defaults[@placename4]).to eql @default4
					end
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
				# -------------------------------------PLACEHOLDER---------------------------------------
				context 'when name is defined in given data' do
					it 'returns the value in the data at the name' do
						expect(@partial1.apply @hash).to eql @hash[@partial1.name]
					end
				end

				# ---------------------------------------DEFAULT-----------------------------------------
				context 'when name is not defined in given data, but defined in defaults' do
					it 'returns the value in the default at the name' do
						expect(@partial2.apply @hash).to eql @defaults[@partial2.name]
					end
				end

				# --------------------------------------OPERATION----------------------------------------
				context 'when an operation is defined' do
					it 'returns the value in the data/default at the name with the operation applied' do
						expect(@partial3.apply @hash).to eql @result3
					end
				end

				# --------------------------------------ARGUMENTS----------------------------------------
				context 'when an operation and arguments are defined' do
					it 'returns the value in the data/default at the name with the operation and arguments applied' do
						expect(@partial4.apply @hash).to eql @result4
					end
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
				context 'when no first argument specified' do
					it 'returns the first string representation of the placeholder' do
						expect(@partial1.string).to eql @string_first1
						expect(@partial2.string).to eql @string_first2
						expect(@partial3.string).to eql @string_first3
						expect(@partial4.string).to eql @string_first4
					end
				end

				# --------------------------------------FIRST-----------------------------------------
				context 'when first argument is specified' do
					# --------------------------------TRUE--------------------------------
					context 'when first is true' do
						it 'returns the first string representation of the placeholder' do
							expect(@partial1.string true).to eql @string_first1
							expect(@partial2.string true).to eql @string_first2
							expect(@partial3.string true).to eql @string_first3
							expect(@partial4.string true).to eql @string_first4
						end
					end

					# --------------------------------FALSE-------------------------------
					context 'when first is false' do
						it 'returns the string representation of the placeholder' do
							expect(@partial1.string false).to eql @string1
							expect(@partial2.string false).to eql @string2
							expect(@partial3.string false).to eql @string3
							expect(@partial4.string false).to eql @string4
						end
					end
				end
			end

			# Describe General::GTemplate#regex
			#
			# Returns the string as a regex
			#
			# Parameter: first - true if the placeholder is the first of its kind in the GTemplate
			#
			# Returns: the string as a regex
			describe '#regex' do
				# -------------------------------------NO FIRST---------------------------------------
				context 'when no first argument specified' do
					it 'returns the first regex representation of the placeholder' do
						expect(@partial1.regex).to eql @regex_first1
						expect(@partial2.regex).to eql @regex_first2
						expect(@partial3.regex).to eql @regex_first3
						expect(@partial4.regex).to eql @regex_first4
					end
				end

				# --------------------------------------FIRST-----------------------------------------
				context 'when first argument is specified' do
					# --------------------------------TRUE--------------------------------
					context 'when first is true' do
						it 'returns the first regex representation of the placeholder' do
							expect(@partial1.regex true).to eql @regex_first1
							expect(@partial2.regex true).to eql @regex_first2
							expect(@partial3.regex true).to eql @regex_first3
							expect(@partial4.regex true).to eql @regex_first4
						end
					end

					# --------------------------------FALSE-------------------------------
					context 'when first is false' do
						it 'returns the regex representation of the placeholder' do
							expect(@partial1.regex false).to eql @regex1
							expect(@partial2.regex false).to eql @regex2
							expect(@partial3.regex false).to eql @regex3
							expect(@partial4.regex false).to eql @regex4
						end
					end
				end
			end
		end
	end

	# Describe General::GArrayPlaceholder
	# 
	# Represents an array placeholder partial in a GTemplate
	#
	# Author:  Anshul Kharbanda
	# Created: 7 - 1 - 2016
	describe General::GArrayPlaceholder do
		before :all do
			# -----------DATA-----------
			
			@text  = "Subarg: @(subarg)"
			@regex = "Subarg: (?<subarg>.*)"
			@delim = "\n"

			# ---------------------------OUTPUT---------------------------
			
			@out1 = @hash[@arrayname1]
					.collect{|e| "Subarg: #{e[:subarg]}"}
					.join(General::GArrayPlaceholder::DEFAULT_DELIMETER)
			@out2 = @hash[@arrayname1]
					.collect{|e| "Subarg: #{e[:subarg]}"}
					.join(@delim)

			# ------------------------------------------PARTIALS------------------------------------------

			@partial1 = General::GArrayPlaceholder.new name: @arrayname1, text: @text
			@partial2 = General::GArrayPlaceholder.new name: @arrayname1, text: @text, delimeter: @delim

			# -------------------------------------------STRING-------------------------------------------

			@string1 = "@[#{@arrayname1}] #{@text} @[ ]"
			@string2 = "@[#{@arrayname1}] #{@text} @[\\n]"

			# -------------------------------------------REGEX--------------------------------------------

			@regex1 = "(?<#{@arrayname1}>(#{@regex}( )?)+)"
			@regex2 = "(?<#{@arrayname1}>(#{@regex}(\\n)?)+)"
		end

		# Describe General::GArrayPlaceholder::new
		# 
		# Initializes the GPlaceholder with the given match
		#
		# Parameter: match - the match data from the string being parsed
		describe '::new' do
			context 'with the given name and text' do
				it 'creates a new GArrayPlaceholder with the given name and text' do
					expect(@partial1).to be_an_instance_of General::GArrayPlaceholder
				end
			end

			context 'with the given name, text, and delimeter' do
				it 'creates a new GArrayPlaceholder with the given name and text and delimeter' do
					expect(@partial1).to be_an_instance_of General::GArrayPlaceholder
				end
			end
		end

		# Describe General::GTemplate#apply
		# 
		# Returns the value of the array placeholder in the given data
		# formatted by the given GTemplate and joined by the given delimeter
		#
		# Parameter: data - the data being applied
		#
		# Return: the value of the array placeholder in the given data
		# 		  formatted by the given GTemplate and joined by the given delimeter
		describe '#apply' do
			it 'applies the given data array formatted according to the given GTemplate and joined by the delimeter' do
				expect(@partial1.apply @hash).to eql @out1
				expect(@partial2.apply @hash).to eql @out2
			end
		end

		describe '#string' do
			context 'with no first argument is given' do
				it 'returns the string of the GArrayPlaceholder' do
					expect(@partial1.string).to eql @string1
					expect(@partial2.string).to eql @string2
				end
			end

			context 'with first argument is given' do
				context 'when first is true' do
					it 'returns the string of the GArrayPlaceholder' do
						expect(@partial1.string true).to eql @string1
						expect(@partial2.string true).to eql @string2
					end
				end

				context 'when first is false' do
					it 'returns the string of the GArrayPlaceholder' do
						expect(@partial1.string false).to eql @string1
						expect(@partial2.string false).to eql @string2					
					end
				end
			end
		end

		describe '#regex' do
			context 'with no first argument is given' do
				it 'returns the regex of the GArrayPlaceholder' do
					expect(@partial1.regex).to eql @regex1
					expect(@partial2.regex).to eql @regex2
				end
			end

			context 'with first argument is given' do
				context 'when first is true' do
					it 'returns the regex of the GArrayPlaceholder' do
						expect(@partial1.regex true).to eql @regex1
						expect(@partial2.regex true).to eql @regex2
					end
				end

				context 'when first is false' do
					it 'returns the regex of the GArrayPlaceholder' do
						expect(@partial1.regex false).to eql @regex1
						expect(@partial2.regex false).to eql @regex2					
					end
				end
			end
		end
	end
end