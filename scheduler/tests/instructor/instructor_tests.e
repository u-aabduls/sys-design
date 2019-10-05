note
	description: "[
		Test the correctness of ARRAYED_HEAP and SCHEDULER.
		]"
	author: "Jackie"
	date: "$Date$"
	revision: "$Revision 19.05$"

class
	INSTRUCTOR_TESTS

inherit

	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do
			add_boolean_case (agent t0)
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
		end

feature -- tests

	t0: BOOLEAN
		local
			h: ARRAYED_HEAP
		do
			comment ("t0: create a new heap and basic queries")
			create h.make (<<4, 1, 3, 2, 16, 9, 10, 14, 8, 7>>, 15)
			Result := h.array ~ <<16, 14, 10, 8, 7, 9, 3, 2, 4, 1, 0, 0, 0, 0, 0>>
			check Result end

			Result := h.maximum = 16
			check Result end

			Result :=
				h.max_capacity = 15 and h.count = 10 and not h.is_empty
			check Result end

			Result :=
				h.key_exists (10) and not h.key_exists (21)
			check Result end

			Result :=
				across 1 |..| h.count is l_i all
					h.is_valid_index (l_i)
				end
				and -- alternative, but equivalent way (notice `is` rather than `as`)
				across 1 |..| h.count as index_cursor all
					h.is_valid_index (index_cursor.item)
				end
			check Result end

			Result :=
				not (h.is_valid_index (11) or h.is_valid_index (15) or h.is_valid_index (18))
			check Result end

			Result :=
				h.has_left_child (4) and h.left_child_of (4) = 2 -- note. index 4 deontes node storing 8
				and
				h.has_right_child (4) and h.right_child_of (4) = 4
				and
				h.has_left_child (5) and h.left_child_of (5) = 1 -- note. index 5 denotes node storing 7
				and
				not h.has_right_child (5)
				and
				not (h.has_left_child (6) or h.has_right_child (6)) -- note. index 6 denotes node storing 9
			check Result end

			Result :=
				h.has_parent (2) and h.parent_of (2) = 16 -- note. index 2 denotes node storing 14
				and
				h.has_parent (10) and h.parent_of (10) = 7 -- note. index 10 denotes node storing 1
				and
				not h.has_parent (1) -- note. index 1 denotes node storing 16
			check Result end

			Result :=
				h.is_a_max_heap (1) -- note. index 1 denotes node storing 16
				and
				h.is_a_max_heap (3) -- note. index 3 denotes node storing 10
				and
				h.is_a_max_heap (10) -- note. index 10 denotes node storing 1
			check Result end
		end

	t1: BOOLEAN
		local
			h: ARRAYED_HEAP
		do
			comment ("t1: create a new heap, insert a key, remove maximum")
			create h.make (<<4, 1, 3, 2, 16, 9, 10, 14, 8, 7>>, 15)
			Result := h.array ~ <<16, 14, 10, 8, 7, 9, 3, 2, 4, 1, 0, 0, 0, 0, 0>>
			check Result end

			h.insert (15)
			Result := h.array ~ <<16, 15, 10, 8, 14, 9, 3, 2, 4, 1, 7, 0, 0, 0, 0>>
			check Result end

			h.remove_maximum
			Result := h.array ~ <<15, 14, 10, 8, 7, 9, 3, 2, 4, 1, 0, 0, 0, 0, 0>>
			check Result end
		end

	t2: BOOLEAN
		local
			s: SCHEDULER[STRING] -- the TASK genenic type parameter in SCHEDULER is instantiated by STRING
		do
			comment ("t2: create a new scheduler, add a new task, execute the next task, basic queries")
			create s.make_from_array (
				<<	["Alan's Request"		,   4], ["Mark's Request"         ,   1],
						["Tom's Request"		,   3], ["SuYeon's Request"     ,   2],
						["Yuna's Request"		, 16], ["JaeBin's Request"       ,   9],
						["JiYoon's Request"	, 10], ["SeungYeon's Request", 14],
						["SunHye's Request"	,   8], ["JiHye's Request"         , 7 ]	>>
				, 15)

			Result := s.pq.array ~ <<16, 14, 10, 8, 7, 9, 3, 2, 4, 1, 0, 0, 0, 0, 0>>
			check Result end

			Result := s.count = 10 and not s.is_empty
			check Result end

			Result := s.next_task_to_execute ~ "Yuna's Request"
			check Result end

			Result := not s.priority_exists (15)
			check Result end

			s.add_task (["HeeYeon's Request", 15])

			Result := s.pq.array ~ <<16, 15, 10, 8, 14, 9, 3, 2, 4, 1, 7, 0, 0, 0, 0>>
			check Result end

			Result := s.priority_exists (15)
			check Result end

			Result := s.next_task_to_execute ~ "Yuna's Request"
			check Result end

			s.execute_next_task

			Result := s.pq.array ~ <<15, 14, 10, 8, 7, 9, 3, 2, 4, 1, 0, 0, 0, 0, 0>>
			check Result end

			Result := s.next_task_to_execute ~ "HeeYeon's Request"
			check Result end
		end

end
