note
	description: "Tests created by student"
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
			add_boolean_case(agent t1_make_repo)
			add_boolean_case(agent t2_repo_count)
			add_boolean_case(agent t3_check_in)
			add_violation_case_with_tag("non_existing_key", agent t4_check_in)
			add_boolean_case(agent t5_check_out)
			add_violation_case_with_tag("existing_key", agent t6_check_out_empty)
			add_violation_case_with_tag("existing_key", agent t7_check_out_nonempty)
			add_boolean_case(agent t8_exists)
			add_boolean_case(agent t9_matching_keys)
			add_boolean_case(agent t10_make_data_set)
			add_boolean_case(agent t11_data_set_is_equal)
			add_violation_case_with_tag("unique_keys", agent t12_unique_keys)
			add_violation_case_with_tag("implementation_contraint", agent t13_implementation_lower_bound)
			add_violation_case_with_tag("consistent_keys", agent t14_integrity_constraints_on_keys)
			add_violation_case_with_tag("consistent_keys_data_items_counts", agent t15_consistent_keys_data_items_counts)
			add_violation_case_with_tag("consistent_keys_data_items_counts", agent t16_consistent_keys_data_items_counts)
		end

feature -- Tests

	t1_make_repo: BOOLEAN

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]

		do
			comment ("t1: testing `make` in REPOSITORY.")

			create repos.make
			Result := 	 repos.count = 0
					 and repos.keys.count = 0
					 and repos.data_items_1.count = 0
					 and repos.data_items_2.count = 0
			check Result end
		end


	t2_repo_count: BOOLEAN

		local
			repos: REPOSITORY[INTEGER, STRING, STRING]

		do
			comment ("t2: testing `count` in REPOSITORY.")

			create repos.make
			Result := repos.count = 0

			across 1 |..| 10 is i
			 loop
			 	repos.check_in ("item", "item", i)
			 	Result := repos.count = i
			 	check Result end
			end
			check Result end
		end


	t3_check_in: BOOLEAN

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]
			ks, chars, strs: LINKED_LIST[ANY]
			index: INTEGER

		do
			comment ("t3: testing `check_in` in REPOSITORY.")

			create repos.make
			create ks.make
			create chars.make
			create strs.make

			Result := repos.count = 0
			check Result end
			repos.check_in ('l', "mao", 1)
			chars.extend('l'); strs.extend ("mao"); ks.extend (1)
			Result := repos.count = 1
			check Result end
			repos.check_in ('l', "mfao", 2)
			chars.extend('l'); strs.extend ("mfao"); ks.extend (2)
			Result := repos.count = 2
			check Result end
			repos.check_in ('r', "ofl", 3)
			chars.extend('r'); strs.extend ("ofl"); ks.extend (3)
			Result := repos.count = 3
			check Result end
			repos.check_in ('h', "ehexD", 4)
			chars.extend('h'); strs.extend ("ehexD"); ks.extend (4)
			Result := repos.count = 4
			check Result end

			index := 1
			across repos is cursor
			 loop
			 	if 	cursor[3] /~ ks[index] or cursor[1] /~ chars[index] or cursor[2] /~ strs[index] then
			 	 	Result := false
			 	end
			 	index := index + 1
			end
			check Result end
		end


	t4_check_in -- check_in `non_existing_key` precondition violation check

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]
		do
			comment ("t4: testing `check_in` precondition violation case in REPOSITORY.")

			create repos.make

			repos.check_in ('l', "mao", 1)

			repos.check_in ('l', "mao", 1)
		end


	t5_check_out: BOOLEAN

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]
			keys: LINKED_LIST[INTEGER]
			counter: INTEGER

		do
			comment ("t5: testing `check_out` in REPOSITORY.")

			create repos.make
			create keys.make

			Result := repos.count = 0
			check Result end

			repos.check_in ('t', "est", 1)
			keys.extend(1)
			Result := repos.count = 1
			check Result end

			repos.check_in ('l', "mfao", 2)
			keys.extend(2)
			Result := repos.count = 2
			check Result end

			repos.check_in ('r', "ofl", 3)
			keys.extend(3)
			Result := repos.count = 3
			check Result end

			repos.check_in ('h', "ehexD", 4)
			keys.extend(4)
			Result := repos.count = 4
			check Result end

			repos.check_in ('e', "murky", 5)
			keys.extend(5)
			Result := repos.count = 5
			check Result end

			counter := repos.count
			across 1 |..| counter is i
			 loop
			 	repos.check_out(keys[i])
			 	Result := repos.count = (counter - i)
			 	check Result end
			end

			check repos.count = 0 end
		end


	t6_check_out_empty -- check_out `existing_key` precondition violation check

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]

		do
			comment ("t6: testing `check_out` precondition violation in REPOSITORY.")

			create repos.make

			repos.check_out (1)
		end


	t7_check_out_nonempty -- check_out `existing_key` precondition violation check

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]

		do
			comment ("t7: testing `check_out` precondition violation in REPOSITORY.")

			create repos.make

			repos.check_in ('a', "yylmao", 1)

			repos.check_out (2)
		end


	t8_exists: BOOLEAN

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]

		do
			comment ("t8: testing `exists` in REPOSITORY.")

			create repos.make

			Result := repos.count = 0
			check Result end
			repos.check_in ('l', "mao", 1)
			Result := repos.exists (1)
			check Result end

			Result := repos.count = 1
			check Result end
			repos.check_in ('l', "mfao", 2)
			Result := 	repos.exists (1)
					and repos.exists (2)
			check Result end

			Result := repos.count = 2
			check Result end
			repos.check_in ('r', "ofl", 3)
			Result := 	repos.exists (1)
					and repos.exists (2)
					and repos.exists (3)
			check Result end

			Result := repos.count = 3
			check Result end

			repos.check_out (3)
			Result := 	repos.count = 2
					and not repos.exists (3)
					and repos.exists (2)
					and repos.exists (1)
			check Result end

			repos.check_out (2)
			Result := 	repos.count = 1
					and not repos.exists (3)
					and not repos.exists (2)
					and repos.exists (1)
			check Result end
		end


	t9_matching_keys: BOOLEAN

		local
			repos: REPOSITORY[INTEGER, CHARACTER, STRING]
			keys: LINKED_LIST[INTEGER]

		do
			comment("t9: testing `matching_keys` in REPOSITORY.")
			create repos.make
			create keys.make

			repos.check_in ('1', "matching", 1)
			repos.check_in ('1', "matching", 2)
			repos.check_in ('1', "not", 3)
			repos.check_in ('1', "not", 4)
			repos.check_in ('1', "matching", 5)
			repos.check_in ('1', "not", 6)
			repos.check_in ('1', "matching", 7)
			repos.check_in ('1', "not", 8)
			repos.check_in ('1', "matching", 9)
			repos.check_in ('1', "matching", 10)

			across repos.matching_keys ('1', "matching") is k
			 loop
			 	keys.extend (k)
			end

			Result := 	keys.count = 6
					and	keys[1] ~ 1
					and keys[2] ~ 2
					and keys[3] ~ 5
					and keys[4] ~ 7
					and keys[5] ~ 9
					and keys[6] ~ 10
			check Result end
		end


	t10_make_data_set: BOOLEAN

		local
			data_set: DATA_SET[CHARACTER, STRING, INTEGER]

		do
			comment("t10: testing `make` in DATA_SET.")
			create data_set.make ('u', "mar", 1)
			Result := 	data_set.key ~ 1
					and data_set.data_item_1 ~ 'u'
					and data_set.data_item_2 ~ "mar"
			check Result end
		end


	t11_data_set_is_equal: BOOLEAN

		local
			d1, d2: DATA_SET[CHARACTER, STRING, INTEGER]

		do
			comment("t11: testing `is_equal` in DATA_SET.")
			create d1.make ('h', "anan", 1)
			Result := 	d1.key ~ 1
					and d1.data_item_1 ~ 'h'
					and d1.data_item_2 ~ "anan"
			check Result end
			create d2.make ('h', "anan", 1)
			Result := 	d2.key ~ 1
					and d2.data_item_1 ~ 'h'
					and d2.data_item_2 ~ "anan"
			check Result end

			Result := d1.is_equal(d2)
			check Result end
		end


	t12_unique_keys

		local
			repos: REPOSITORY[INTEGER, STRING, STRING]

		do
			comment ("t12: testing `unique_keys` in REPOSITORY.")

			create repos.make
			repos.check_in ("whatsapp", "group", 1)
			repos.check_in ("umar", "abdulselam", 2)
			-- The following should violate the invariant
			-- enforcing unique keys in `repository`.
			repos.keys[2] := 1
			repos.check_in ("hanan", "faris", 3)
		end


	t13_implementation_lower_bound

		local
			repos: REPOSITORY[INTEGER, STRING, STRING]

		do
			comment ("t13: testing `implementation_constraint` on `data_items_1` in REPOSITORY.")

			create repos.make
			repos.check_in ("whatsapp", "group", 1)
			-- The following should violate the invariant
			-- enforcing `data_items_1`s lower to be 1.
			-- NOTE: We set data_items_1's lower to -1 by
			-- using a constructor for ARRAY, hence violating
			-- invariant: data_items_1.lower = 1
			repos.data_items_1.make_filled ("bad client behaviour", -1, 0)
			repos.check_in ("umar", "abdulselam", 3)
		end


	t14_integrity_constraints_on_keys

		local
			repos: REPOSITORY[INTEGER, STRING, STRING]

		do
			comment ("t13: testing `consistent_keys` in REPOSITORY.")

			create repos.make
			repos.check_in ("whatsapp", "group", 1)
			-- The following should violate the invariant
			-- enforcing consistent keys in `keys` and
			-- keys in `data_items_2`.
			repos.keys[1] := 2
			repos.check_in ("umar", "abdulselam", 3)
		end


	t15_consistent_keys_data_items_counts

		local
			repos: REPOSITORY[INTEGER, STRING, STRING]

		do
			comment ("t14: testing `consistent_keys_data_items_counts` on `data_items_1` in REPOSITORY.")

			create repos.make
			repos.check_in ("whatsapp", "group", 1)
			-- The following should violate the invariant
			-- enforcing consistent counts across `keys`
			-- and `data_items_1`.
			repos.data_items_1.force ("this is bad client behaviour.", 2)
			repos.check_in ("umar", "abdulselam", 3)
		end


	t16_consistent_keys_data_items_counts

		local
			repos: REPOSITORY[INTEGER, STRING, STRING]

		do
			comment ("t14: testing `consistent_keys_data_items_counts` on `data_items_2` in REPOSITORY.")

			create repos.make
			repos.check_in ("whatsapp", "group", 1)
			-- The following should violate the invariant
			-- enforcing consistent counts across `keys`
			-- and `data_items_2`.
			repos.data_items_2.put ("this is bad client behaviour", -1)
			repos.check_in ("umar", "abdulselam", 3)
		end
end
