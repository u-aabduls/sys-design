note
	description: "[
		ROOT class for project
		See tests in INSTRUCTOR_TESTS
	]"
	author: "Jackie and You"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT

inherit

	ARGUMENTS_32

	ES_SUITE -- testing via ESpec

create
	make

feature {NONE} -- Initialization

	make
			-- Run app
		do
			add_test (create {INSTRUCTOR_TESTS}.make) --suite of tests
			add_test (create {STUDENT_TESTS}.make) -- your own tests
			show_browser
			run_espec
		end

end
