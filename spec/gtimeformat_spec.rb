require_relative "spec_require"

describe General::GTimeFormat do
	before :all do
		# Time value
		@time = (11 + 3)*3600 + 42*60 + 9

		# Formats
		@format1 = General::GTimeFormat.new "@HH:@MM:@SS"
		@format2 = General::GTimeFormat.new "@I:@MM:@S @A"
		@format3 = General::GTimeFormat.new "@SS - @M - @H (@I @A)"

		# Applied values
		@applied1 = "14:42:09"
		@applied2 = "3:42:9 PM"
		@applied3 = "09 - 42 - 14 (3 PM)"
	end

	describe "#new" do
		it "creates a new GTimeFormat with the given format string" do
			expect(@format1).to be_an_instance_of General::GTimeFormat
			expect(@format2).to be_an_instance_of General::GTimeFormat
			expect(@format3).to be_an_instance_of General::GTimeFormat
		end
	end

	describe "#apply" do
		context "with integer time value given" do
			it "returns the given value formatted according to the time format" do
				expect(@format1.apply(@time)).to eql @applied1
				expect(@format2.apply(@time)).to eql @applied2
				expect(@format3.apply(@time)).to eql @applied3
			end
		end
	end
end