note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
		-- Run application
		local
			c: MY_COUNTER
		do
			-- Add your code here
			create {MY_COUNTER} c.make (10)
			print(c.value)
		end

end
