note
	description: "Tests created for TDD of ARRAYED_HEAP and SCHEDULER class."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST

create
	make

feature -- Add tests

	make
		do
			add_violation_case_with_tag ("enough_capacity", agent t0)
			add_violation_case_with_tag ("all_positive", agent t1)
			add_violation_case_with_tag ("no_duplicates", agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
			add_violation_case_with_tag ("non_empty_heap", agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t12)
			add_boolean_case (agent t13)
			add_boolean_case (agent t14)
			add_boolean_case (agent t15)
			add_boolean_case (agent t16)
			add_boolean_case (agent t17)
			add_boolean_case (agent t18)
			add_violation_case_with_tag ("non_empty_tasks", agent t19)
			add_violation_case_with_tag ("non_empty_tasks", agent t20)
		end

feature -- Tests

	t0 -- `enough_capacity` precondition check for `make`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t0: testing precondition 'enough_capacity'for 'make' feature in ARRAYED_HEAP.")
			vals := << 1, 2, 3 >>
			-- Required min capacity = 3, max_capacity given: 2
			create heap.make (vals, 2)
		end

	t1 -- `all_positive` precondition check for `make`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t1: testing precondition 'all_positive'for 'make' feature in ARRAYED_HEAP.")
			vals := << 1, 2, -3 >>
			create heap.make (vals, 3)
		end

	t2 -- `no_duplicates` precondition check for `make`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t2: testing precondition 'no_duplicates'for 'make' feature in ARRAYED_HEAP.")
			vals := << 1, 1, 1 >>
			create heap.make (vals, 3)
		end

	t3: BOOLEAN -- postcondition check for `make` and implicitly `heapify`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment ("t3: testing 'make' and 'heapfiy' (implicitly) in ARRAYED_HEAP.")
			vals := << 38, 91, 6, 100, 49, 11, 20 >>
			create heap.make (vals, 20)
			Result := heap.array ~ << 100, 91, 20, 38, 49, 11, 6,
									  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 >>
			check Result end
			Result := heap.count = 7 and heap.max_capacity = 20 and heap.array.count = 20
			check Result end
		end

	t4: BOOLEAN -- postcodition check for `is_valid_index`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP
			i1, i2, i3, i4, i5: INTEGER

		do
			comment("t4: testing 'is_valid_index' in ARRAYED_HEAP.")
			vals := << 38, 91, 6, 100, 49, 11, 20 >>
			create heap.make (vals, 20)
			Result := heap.array ~ << 100, 91, 20, 38, 49, 11, 6,
									  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 >>
			check Result end
			Result := heap.count = 7 and heap.max_capacity = 20 and heap.array.count = 20
					check Result end
			i1 := 1
			Result := heap.is_valid_index (i1)
			check Result end
			i2 := 7
			Result := heap.is_valid_index (i2)
			check Result end
			i3 := 20
			Result := not heap.is_valid_index (i3)
			check Result end
			i4 := 0
			Result := not heap.is_valid_index (i4)
			check Result end
			i5 := 21
			Result := not heap.is_valid_index (i5)
			check Result end
		end

	t5: BOOLEAN -- postcondition check for `is_permutation_of`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t5: testing 'is_permutation_of' in ARRAYED_HEAP.")
			vals := << 38, 91, 6, 100, 49, 11, 20 >>
			create heap.make (vals, 7) -- passing 7 results in no trailing 0s in heap.array
			Result := heap.is_permutation_of (heap.array, vals)
			check Result end
		end

	t6: BOOLEAN -- postcondition check for `is_empty`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t6: testing 'is_empty' in ARRAYED_HEAP")
			vals := << 1, 2, 3 >>
			create heap.make (vals, 10)
			Result := not heap.is_empty
			check Result end
		end

	t7: BOOLEAN -- postcondition check for `maximum`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment ("t7: testing 'maximum' in ARRAYED_HEAP.")
			vals := << 38, 91, 6, 100, 49, 11, 20 >>
			create heap.make (vals, 20)
			Result := heap.array ~ << 100, 91, 20, 38, 49, 11, 6,
													 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 >>
			check Result end
			Result := heap.count = 7 and heap.max_capacity = 20 and heap.array.count = 20
			check Result end

			Result := heap.maximum = 100
			check Result end
		end

	t8: BOOLEAN -- postcondition check for `remove_maximum`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment ("t8: testing 'remove_maximum' in ARRAYED_HEAP.")
			vals := << 38, 91, 6, 100, 49, 11, 20 >>
			create heap.make (vals, 20)
			Result := heap.array ~ << 100, 91, 20, 38, 49, 11, 6,
									  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 >>
			check Result end
			Result := heap.count = 7 and heap.max_capacity = 20 and heap.array.count = 20
			check Result end

			Result := heap.maximum = 100
			check Result end

			heap.remove_maximum
			Result := (heap.maximum = 91) and not (heap.maximum = 100)
			check Result end

			heap.remove_maximum
			Result := heap.maximum = 49 and not (heap.maximum = 91)
			check Result end

			heap.remove_maximum
			Result := heap.maximum = 38 and not (heap.maximum = 49)
			check Result end

			heap.remove_maximum
			Result := heap.maximum = 20 and not (heap.maximum = 38)
			check Result end

			heap.remove_maximum
			Result := heap.maximum = 11 and not (heap.maximum = 20)
			check Result end

			heap.remove_maximum
			Result := heap.maximum = 6 and not (heap.maximum = 11)
			check Result end
		end

	t9 -- precondition check for `remove_maximum`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t9: testing precondition 'not_empty_heap' in 'remove_maximum' in ARRAYED_HEAP.")
			vals := << 1 >>
			create heap.make (vals, 1)

			heap.remove_maximum

			-- heap has no elements to remove, so attempting to
			-- remove should violate 'not_empty'precondition
			heap.remove_maximum

		end

	t10 : BOOLEAN -- postcondition check for `is_empty`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t10: testing 'is_empty' in ARRAYED_HEAP.")
			vals := << 1 >>
			create heap.make (vals, 1)

			Result := not heap.is_empty
			check Result end

			heap.remove_maximum

			Result := heap.is_empty
			check Result end
		end

	t11: BOOLEAN -- postcondition check for `is_permutation_of`

		local
			a, b, vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t11: testing 'is_permutation_of' in ARRAYED_HEAP.")
			vals := << 1, 2, 3 >>
			create heap.make (vals, 3)

			Result := heap.is_permutation_of (heap.array, vals)
			check Result end

			a := << 1337, 2015, 2019, 1996, 1997 >>
			b := << 1996, 2019, 1337, 1997, 2015 >>

			-- 'a' and 'b' ARE permutations of each other
			Result := heap.is_permutation_of (a, b)
			check Result end

			-- 'a' and 'b' ARE NOT permutations of each other
			a := << 5, 1, 4, 6, 8 >>
			b := << 100, 1, 4, 78, 2 >>
			Result := not heap.is_permutation_of (a, b)
			check Result end

		end

	t12: BOOLEAN -- postcondition check for `key_exists`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t12: testing 'key_exists' in ARRAYED_HEAP.")
			vals := << 76, 21, 5 >>
			create heap.make (vals, 10)

			-- Keys that DO exist
			Result := heap.key_exists (76)
			check Result end

			Result := heap.key_exists (21)
			check Result end

			Result := heap.key_exists (5)
			check Result end

			-- Keys that DO NOT exist
			Result := not heap.key_exists (1)
			check Result end

			Result := not heap.key_exists (10)
			check Result end

			Result := not heap.key_exists (100)
			check Result end


		end


	t13: BOOLEAN -- postcondition checks for `insert`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t13: testing 'insert' in ARRAYED_HEAP.")
			vals := << 1, 2, 3 >>
			create heap.make (vals, 10)
			Result := heap.maximum = 3 and heap.count = 3 and heap.max_capacity = 10
			check Result end

			heap.insert(4)
			Result := heap.maximum = 4 and heap.count = 4 and heap.max_capacity = 10
			check Result end

			heap.insert(70)
			Result := heap.maximum = 70 and heap.count = 5 and heap.max_capacity = 10
			check Result end

			heap.insert(13)
			Result := heap.maximum = 70 and heap.count = 6 and heap.max_capacity = 10
			check Result end

			heap.insert(56)
			Result := heap.maximum = 70 and heap.count = 7 and heap.max_capacity = 10
			check Result end

			heap.insert(81)
			Result := heap.maximum = 81 and heap.count = 8 and heap.max_capacity = 10
			check Result end

			heap.insert(100)
			Result := heap.maximum = 100 and heap.count = 9 and heap.max_capacity = 10
			check Result end

			heap.insert(7)
			Result := heap.maximum = 100 and heap.count = 10 and heap.max_capacity = 10
			check Result end

			Result :=  heap.array[1] = 100
			check Result end
			Result :=  heap.array[2] = 81
			check Result end
			Result :=  heap.array[3] = 56
			check Result end
			Result :=  heap.array[4] = 70
			check Result end
			Result :=  heap.array[5] = 7
			check Result end
			Result :=  heap.array[6] = 1
			check Result end
			Result :=  heap.array[7] = 13
			check Result end
			Result :=  heap.array[8] = 2
			check Result end
			Result :=  heap.array[9] = 4
			check Result end
			Result :=  heap.array[10] = 3
			check Result end

			Result := heap.array ~ << 100, 81, 56, 70, 7, 1, 13, 2, 4, 3 >>
			check Result end

		end


	t14: BOOLEAN -- postcondition checks for `is_a_max_heap`

		local
			vals: ARRAY[INTEGER]
			heap: ARRAYED_HEAP

		do
			comment("t14: testing 'is_a_max_heap' in ARRAYED_HEAP.")
			vals := << 7, 4, 8 >>

			create heap.make (vals, 10)
			Result :=
				across 1 |..| 3 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end

			heap.insert (10)
			Result :=
				across 1 |..| 4 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end

			heap.insert (5)
			Result :=
				across 1 |..| 5 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end

			heap.insert (67)
			Result :=
				across 1 |..| 6 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end

			heap.insert (1)
			Result :=
				across 1 |..| 7 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end

			heap.insert (1000)
			Result :=
				across 1 |..| 8 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end

			heap.insert (11)
			Result :=
				across 1 |..| 9 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end

			heap.insert (333)
			Result :=
				across 1 |..| 10 is i
				 all
				 	heap.is_a_max_heap (i)
				end
			check Result end
		end


	t15: BOOLEAN -- postcondition checks for `count` and `is_empty` for SCHEDULER

		local
			schedule: SCHEDULER[STRING]
			jobs: ARRAY[TUPLE[STRING, INTEGER]]

		do
			comment("t15: postcondition checks for `count` and `is_empty` for SCHEDULER.")
			jobs := << ["Umar's Request", 100],     ["Jackie's Request", 99],
					   ["Andy's Request", 1],          ["Minas' Request", 5],
					   ["Suprakash's Request", 50], ["Michael's Request", 7],
					   ["Ali's Request", 10],    ["Stachniak's Request", 79],
					   ["Jeff's Request", 81],        ["Andriy' Request", 2] >>

			create schedule.make_from_array(jobs, 100)

			Result := schedule.count = 10 and not schedule.is_empty
			check Result end
		end


	t16: BOOLEAN -- postcondition checks for `priority_exist` for SCHEDULER

		local
			schedule: SCHEDULER[STRING]
			jobs: ARRAY[TUPLE[STRING, INTEGER]]

		do
			comment("t16: postcondition checks for `priority_exist` for SCHEDULER.")
			jobs := << ["Umar's Request", 100],     ["Jackie's Request", 99],
					   ["Andy's Request", 1],          ["Minas' Request", 5],
					   ["Suprakash's Request", 50], ["Michael's Request", 7],
					   ["Ali's Request", 10],    ["Stachniak's Request", 79],
					   ["Jeff's Request", 81],        ["Andriy' Request", 2] >>

			create schedule.make_from_array(jobs, 100)

			Result := schedule.count = 10 and not schedule.is_empty
			check Result end

			-- KEYS THAT DO EXIST
			Result := schedule.priority_exists (100)
					  	and schedule.priority_exists (99)
					  	and schedule.priority_exists (1)
					  	and schedule.priority_exists (5)
					  	and schedule.priority_exists (50)
					  	and schedule.priority_exists (7)
					  	and schedule.priority_exists (10)
					  	and schedule.priority_exists (79)
					  	and schedule.priority_exists (81)
					  	and schedule.priority_exists (2)
			check Result end

			-- KEYS THAT DO NOT EXIST
			Result := not schedule.priority_exists (3)
					  	and not schedule.priority_exists (909)
					  	and not schedule.priority_exists (-1)
					  	and not schedule.priority_exists (-6)
					  	and not schedule.priority_exists (51)
					  	and not schedule.priority_exists (82)
					  	and not schedule.priority_exists (98)
					  	and not schedule.priority_exists (75)
					  	and not schedule.priority_exists (9)
					  	and not schedule.priority_exists (43)
			check Result end

		end


	t17: BOOLEAN -- postcondition check for `add_task` in SCHEDULER

		local
			schedule: SCHEDULER[STRING]
			jobs: ARRAY[TUPLE[STRING, INTEGER]]

		do
			comment("t17: postcondition checks for `priority_exist` for SCHEDULER.")
			jobs := << ["Umar's Request", 100],     ["Jackie's Request", 99],
					   ["Andy's Request", 1],          ["Minas' Request", 5],
					   ["Suprakash's Request", 50], ["Michael's Request", 7],
					   ["Ali's Request", 10],    ["Stachniak's Request", 79],
					   ["Jeff's Request", 81],        ["Andriy' Request", 2] >>

			create schedule.make_from_array(jobs, 100)

			Result := schedule.count = 10 and not schedule.is_empty
			check Result end

			-- KEYS THAT DO EXIST
			Result := schedule.priority_exists (100)
					  	and schedule.priority_exists (99)
					  	and schedule.priority_exists (1)
					  	and schedule.priority_exists (5)
					  	and schedule.priority_exists (50)
					  	and schedule.priority_exists (7)
					  	and schedule.priority_exists (10)
					  	and schedule.priority_exists (79)
					  	and schedule.priority_exists (81)
					  	and schedule.priority_exists (2)
			check Result end

			-- KEYS THAT DO NOT EXIST
			Result := not schedule.priority_exists (3)
					  	and not schedule.priority_exists (909)
					  	and not schedule.priority_exists (-1)
					  	and not schedule.priority_exists (-6)
					  	and not schedule.priority_exists (51)
					  	and not schedule.priority_exists (82)
					  	and not schedule.priority_exists (98)
					  	and not schedule.priority_exists (75)
					  	and not schedule.priority_exists (9)
					  	and not schedule.priority_exists (43)
			check Result end

			schedule.add_task ("Valerie's Task", 1000)
			Result := schedule.priority_exists (1000)
					  and schedule.count = 11
					  and not schedule.is_empty
			check Result end

			schedule.add_task ("Noordeh's Task", 1010)
			Result := schedule.priority_exists (1010)
					  and schedule.count = 12
					  and not schedule.is_empty
			check Result end

			schedule.add_task ("Roumani's Task", 210)
			Result := schedule.priority_exists (210)
					  and schedule.count = 13
					  and not schedule.is_empty
			check Result end

		end


	t18: BOOLEAN -- postcondition checks for `next_task_to_execute` and `execute_next_task` in SCHEDULER

		local
			schedule: SCHEDULER[STRING]
			jobs: ARRAY[TUPLE[STRING, INTEGER]]

		do
			comment("t18: postcondition checks for `next_task_to_execute` and `execute_next_task` for SCHEDULER.")
			jobs := << ["Umar's Request", 100],     ["Jackie's Request", 99],
					   ["Andy's Request", 1],          ["Minas' Request", 5],
					   ["Suprakash's Request", 50], ["Michael's Request", 7],
					   ["Ali's Request", 10],    ["Stachniak's Request", 79],
					   ["Jeff's Request", 81],        ["Andriy's Request", 2] >>

			create schedule.make_from_array(jobs, 100)

			Result := schedule.count = 10 and not schedule.is_empty
			check Result end

			-- KEYS THAT DO EXIST
			Result := schedule.priority_exists (100)
					  	and schedule.priority_exists (99)
					  	and schedule.priority_exists (1)
					  	and schedule.priority_exists (5)
					  	and schedule.priority_exists (50)
					  	and schedule.priority_exists (7)
					  	and schedule.priority_exists (10)
					  	and schedule.priority_exists (79)
					  	and schedule.priority_exists (81)
					  	and schedule.priority_exists (2)
			check Result end

			-- KEYS THAT DO NOT EXIST
			Result := not schedule.priority_exists (3)
					  	and not schedule.priority_exists (909)
					  	and not schedule.priority_exists (-1)
					  	and not schedule.priority_exists (-6)
					  	and not schedule.priority_exists (51)
					  	and not schedule.priority_exists (82)
					  	and not schedule.priority_exists (98)
					  	and not schedule.priority_exists (75)
					  	and not schedule.priority_exists (9)
					  	and not schedule.priority_exists (43)
			check Result end

			Result := schedule.next_task_to_execute ~ "Umar's Request"
					  and schedule.count = 10
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Jackie's Request"
					  and schedule.count = 9
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Jeff's Request"
					  and schedule.count = 8
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Stachniak's Request"
					  and schedule.count = 7
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Suprakash's Request"
					  and schedule.count = 6
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Ali's Request"
					  and schedule.count = 5
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Michael's Request"
					  and schedule.count = 4
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Minas' Request"
					  and schedule.count = 3
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Andriy's Request"
					  and schedule.count = 2
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.next_task_to_execute ~ "Andy's Request"
					  and schedule.count = 1
					  and not schedule.is_empty
			check Result end

			schedule.execute_next_task

			Result := schedule.count = 0
					  and schedule.is_empty
			check Result end

		end


	t19 -- precondition check `not_empty_tasks` in `next_task_to_execute` for SCHEDULER

		local
			schedule: SCHEDULER[STRING]
			task: STRING

		do
			comment("t19: precondition check `not_empty_tasks` in `next_task_to_execute` for SCHEDULER.")
			create schedule.make_from_array (<< ["Test", 1] >>, 10)

			task := schedule.next_task_to_execute

			schedule.execute_next_task

			task := schedule.next_task_to_execute
		end


	t20 -- precondition check `not_empty_tasks` in `execute_next_task` for SCHEDULER

		local
			schedule: SCHEDULER[STRING]

		do
			comment("t20: precondition check `not_empty_tasks` in `execute_next_task` for SCHEDULER.")
			create schedule.make_from_array (<< ["Test", 1] >>, 10)

			schedule.execute_next_task
			schedule.execute_next_task
		end

end
