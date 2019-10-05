note
	description: "container application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_CONTAINER

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Add tests.
		do
			 add_boolean_case (agent test_make)
			 add_boolean_case (agent test_insert)
			 add_boolean_case (agent test_circular_shift)
			 add_boolean_case (agent test)
			 add_boolean_case (agent test2)
			 add_boolean_case (agent test3)
			-- add_violation_case_with_tag (agent test_insert_first)

			show_browser
			run_espec
		end

feature -- Tests

	test_make: BOOLEAN

		local
			ac: ARRAYED_CONTAINER
		do
			comment("UMAR's tests: testing make")
			create ac.make
			Result := ac.count = 0
			check Result end
		end


	test_insert: BOOLEAN

		local
			ac: ARRAYED_CONTAINER

		do
			comment("UMAR's tests: testing insert")
			create ac.make
			Result := ac.count = 0
			check Result end

			ac.insert_first ("Umar")
			Result := ac.count = 1 and ac.get_at (0) ~ "Umar"
			check Result end

			ac.insert_first ("Jordan")
			Result := ac.count = 2 and ac.get_at (0) ~ "Jordan"
								   and ac.get_at (1) ~ "Umar"
			check Result end

			ac.insert_first ("Tamim")
			Result := ac.count = 3 and ac.get_at (0) ~ "Tamim"
								   and ac.get_at (1) ~ "Jordan"
								   and ac.get_at (2) ~ "Umar"
			check Result end
		end


	test_circular_shift: BOOLEAN

		local
			ac: ARRAYED_CONTAINER

		do
			comment("UMAR's tests: testing circular_shift")
			create ac.make
			Result := ac.count = 0
			check Result end

			ac.insert_first ("Umar")
			Result := ac.count = 1 and ac.get_at (0) ~ "Umar"
			check Result end

			ac.insert_first ("Jordan")
			Result := ac.count = 2 and ac.get_at (0) ~ "Jordan"
								   and ac.get_at (1) ~ "Umar"
			check Result end

			ac.insert_first ("Tamim")
			Result := ac.count = 3 and ac.get_at (0) ~ "Tamim"
								   and ac.get_at (1) ~ "Jordan"
								   and ac.get_at (2) ~ "Umar"
			check Result end

			ac.circular_shift_to_left
			Result := ac.count = 3 and ac.get_at (0) ~ "Jordan"
								   and ac.get_at (1) ~ "Umar"
								   and ac.get_at (2) ~ "Tamim"
		end


	test: BOOLEAN
		local
			ac: ARRAYED_CONTAINER
			ting : STRING
		do
			comment("JORDAN's test: insert, get_at, valid_index, circular_shift")
			create ac.make
			ac.insert_first ("Alan")
			ac.insert_first ("Mark")
			ac.insert_first ("Pizza Studio")
			Result := ac.get_at (0) ~ "Pizza Studio" and ac.get_at (1) ~ "Mark" and ac.get_at (2) ~ "Alan"
			check Result end
			ac.circular_shift_to_left
			Result := ac.get_at (0) ~ "Mark" and ac.get_at (1) ~ "Alan" and ac.get_at (2) ~ "Pizza Studio"
			check Result end
			Result := ac.valid_index (0) and ac.valid_index (1) and ac.valid_index (2)
			check Result end
		end

	test2: BOOLEAN
		local
			ac: ARRAYED_CONTAINER
			ting : STRING
		do
			comment("JORDAN's test: insert, get_at, circular_shift")
			create ac.make
			ac.circular_shift_to_left
			Result := ac.count = 0
			check Result end
			ac.insert_first ("Bruce")
			Result := ac.count = 1 and ac.get_at (0) ~ "Bruce"
			check Result end
			ac.circular_shift_to_left
			Result := ac.count = 1 and ac.get_at (0) ~ "Bruce"
			check Result end
		end


	test3: BOOLEAN
		local
			ac: ARRAYED_CONTAINER
		do
			comment("JORDAN's test: insert, get_at, valid_index, circular_shift")
			create ac.make
			-- Test base cases
			Result := ac.count = 0
			ac.insert_first ("Alan")
			Result := ac.valid_index (0) and ac.count = 1
			check Result end
			ac.circular_shift_to_left
			Result := ac.get_at (0) ~ "Alan"
			check Result end
			-- Regular cases
			ac.insert_first ("Mark")
			Result := ac.valid_index (0) and ac.valid_index (1)
				and ac.get_at (0) ~ "Mark" and ac.get_at (1) ~ "Alan"
				and ac.count = 2
			check Result end
			ac.circular_shift_to_left
			Result := ac.get_at (0) ~ "Alan" and ac.get_at (1) ~ "Mark"
			check Result end
		end

end
