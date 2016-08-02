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
	before(:all) do
		@hash = { 
		  	arg1: "foobar",
		  	arg2: [
		  		{subarg1: "ju"}, 
		  		{subarg2: "jar"},
		  		{subarg3: "jaz"}
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
				expect(@partial.name).to eql @name
			end
		end
	end

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
			@info = {key: "at"}
			@text = "@"
			@regex = "@"
			@partial = General::GSpecial.new @info
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
				expect(@partial.instance_variable_get(:@text)).to eql @text
			end
		end
	end
end