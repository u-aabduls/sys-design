note
	description: "[
		The REPOSITORY ADT consists of data sets.
		Each data set maps from a key to two data items (which may be of different types).
		There should be no duplicates of keys. 
		However, multiple keys might map to equal data items.
		]"
	author: "Jackie and Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

-- Advice on completing the contracts:
-- It is strongly recommended (although we do not enforce this in this lab)
-- that you do NOT implement auxiliary/helper queries
-- when writing the assigned pre-/post-conditions.
-- In the final written exam, you will be required to write contracts using (nested) across expressions only.
-- You may want to practice this now!

class
	-- Here the -> means constrained genericity:
	-- client of REPOSITORY may instantiate KEY to any class,
	-- as long as it is a descendant of HASHABLE (i.e., so it can be used as a key in hash table).
	REPOSITORY[KEY -> HASHABLE, DATA1, DATA2]

inherit
	ITERABLE[TUPLE[DATA1, DATA2, KEY]]

create
	make

feature {ES_TEST} -- Do not modify this export status!
	-- You are required to implement all repository features using these three attributes.

	-- For any valid index i, a data set is composed of keys[i], data_items_1[i], and data_items_2[keys[i]].
	keys: LINKED_LIST[KEY]
	data_items_1: ARRAY[DATA1]
	data_items_2: HASH_TABLE[DATA2, KEY]

feature -- feature(s) required by ITERABLE
	-- TODO:
	-- See test_iterable_repository and test_iteration_cursor in EXAMPLE_REPOSITORY_TESTS.
	-- As soon as you make the current class iterable,
	-- define the necessary feature(s) here.
	new_cursor: ITERATION_CURSOR[TUPLE[DATA1, DATA2, KEY]]
		do
			create {TUPLE_ITERATION_CURSOR[KEY, DATA1, DATA2]} Result.make(keys,data_items_1,data_items_2)
		end

feature -- alternative iteration cursor
	-- TODO:
	-- See test_another_cursor in EXAMPLE_REPOSITORY_TESTS.
	-- A feature 'another_cursor' is expected to be defined here.
	another_cursor: ITERATION_CURSOR[DATA_SET[DATA1, DATA2, KEY]]
		do
			create {DATA_SET_ITERATION_CURSOR[DATA1, DATA2, KEY]} Result.make(keys,data_items_1,data_items_2)
		end

feature -- Constructor
	make
			-- Initialize an empty repository.
		do
			-- TODO:
			-- Create empty `keys`, `data_items_1`
			-- and `data_items_2` and set them to
			-- comparable

			create keys.make
			keys.compare_objects

			create data_items_1.make_empty
			data_items_1.compare_objects

			create data_items_2.make (0)
			data_items_2.compare_objects

		ensure
			empty_repository: -- TODO:
					Current.count = 0
				and	keys.count = 0
				and data_items_1.count = 0
				and data_items_2.count = 0

			-- Do not modify the following three postconditions.
			object_equality_for_keys:
				keys.object_comparison
			object_equality_for_data_items_1:
				data_items_1.object_comparison
			object_equality_for_data_items_2:
				data_items_2.object_comparison
		end

feature -- Commands

	check_in (d1: DATA1; d2: DATA2; k: KEY)
			-- Insert a new data set into current repository.
		require
			non_existing_key: -- TODO:
				not Current.exists (k)
		do
			-- TODO:
			keys.extend (k)
			-- NOTE: d1 is forced to position
			-- `count` since count has already
			-- been incremented after extending
			-- `keys`. count = keys.count.
			data_items_1.force (d1, count)
			data_items_2.put (d2, k)

		ensure
			repository_count_incremented: -- TODO:
				Current.count = (old Current.deep_twin).count + 1

			data_set_added: -- TODO:
				-- Hint: At least a data set in the current repository
				-- has its key 'k', data item 1 'd1', and data item 2 'd2'.
				across Current is cursor
				 some
				 		cursor[1] ~ d1
				 	and cursor[2] ~ d2
				 	and cursor[3] ~ k
				end

			others_unchanged: -- TODO:
				-- Hint: Each data set in the current repository,
				-- if not the same as (`k`, `d1`, `d2`), must also exist in the old repository.
				across Current is cursor1
				  all
				  	cursor1[3] /~ k and cursor1[1] /~ d1 and cursor1[3] /~ d2 implies
				  		across (old Current.deep_twin) is cursor2
				  			some
				  					cursor1[3] ~ cursor2[3]
				  				and cursor1[1] ~ cursor2[1]
				  				and cursor1[2] ~ cursor2[2]
				  		end
				end
		end

	check_out (k: KEY)
			-- Delete a data set with key `k` from current repository.
		require
			existing_key: -- TODO:
				Current.exists(k)
		local
			i, index_of_k: INTEGER

		do
			-- TODO:
			-- Remove the key from `keys`
			from
				keys.start
			until
				keys.after
			loop
				if keys.item ~ k then
					keys.remove
					index_of_k := keys.index
				else
					keys.forth
				end
			end

			-- Remove the associated d1 from `data_items_1`
			from
				i := index_of_k
			until
				i = data_items_1.count
			loop
				data_items_1[i] := data_items_1[i+1]
				i := i + 1
			end
			data_items_1.remove_tail(1)

			-- Remove the associated d2 from `data_items_2`
			data_items_2.remove (k)

		ensure
			repository_count_decremented: -- TODO:
				Current.count = (old Current.deep_twin).count - 1

			key_removed: -- TODO:
				across Current is cursor
				 all
				 	cursor[3] /~ k
				end

			others_unchanged:
				-- Hint: Each data set in the old repository,
				-- if not with key `k`, must also exist in the curent repository.
				across (old Current.deep_twin) is cursor1
				 all
				 	cursor1[3] /~ k implies
					 	across Current is cursor2
					 	 some
					 	 		cursor1[3] ~ cursor2[3]
					 	 	and cursor1[1] ~ cursor2[1]
					 	 	and cursor1[2] ~ cursor2[2]
					 	end
				end
		end

feature -- Queries

	count: INTEGER
			-- Number of data sets in repository.
		do
			-- TODO:
			Result := keys.count
		ensure
			correct_result: -- TODO:
				Result = (old keys.deep_twin).count
		end

	exists (k: KEY): BOOLEAN
			-- Does key 'k' exist in the repository?
		do
			-- TODO:
			Result := keys.has (k)
		ensure
			correct_result: -- TODO:
				Result implies
					across keys as k_c
					 some
					 	k_c.item ~ k
					end
		end

	matching_keys (d1: DATA1; d2: DATA2): ITERABLE[KEY]
			-- Keys that are associated with data items 'd1' and 'd2'.
		local
			keyset: ARRAY[KEY]

		do
			-- TODO:
			create keyset.make_empty
			across Current is cursor
			 loop
			 	if cursor[1] ~ d1 and cursor[2] ~ d2 then
			 		if attached {KEY} cursor[3] as key then
			 			keyset.force (key, keyset.count + 1)
			 		end
			 	end
			end
			Result := keyset

		ensure
			result_contains_correct_keys_only: -- TODO:
				-- Hint: Each key in Result has its associated data items 'd1' and 'd2'.
				across Result is cursor1
				 all
				 	across Current is cursor2
				 	 some
				 	 	cursor1 ~ cursor2[3] implies
				 	 		cursor2[1] ~ d1
				 	 	and cursor2[2] ~ d2
				 	end
				end

			correct_keys_are_in_result: -- TODO:
				-- Hint: Each data set with data items 'd1' and 'd2' has its key included in Result.
				-- Notice that Result is ITERABLE and does not support the feature 'has',
				-- Use the appropriate across expression instead.
				across Current is cursor1
				 all
				 	cursor1[1] ~ d1 and cursor1[2] ~ d2 implies
					 	across Result is cursor2
					 	 some
					 	 	cursor1[3] ~ cursor2
					 	end
			    end
		end

invariant
	unique_keys: -- TODO:
		-- Hint: No two keys are equal to each other.
		across 1 |..| count is i
		 all
			across 1 |..| count is j
			 all
				i /= j implies keys[i] /~ keys[j]
			end
		end

	-- Do not modify the following class invariants.
	implementation_contraint:
		data_items_1.lower = 1

	consistent_keys_data_items_counts:
		keys.count = data_items_1.count
		and
		keys.count = data_items_2.count

	consistent_keys:
		across
			keys is k
		all
			data_items_2.has (k)
		end

	consistent_imp_adt_counts:
		keys.count = count
end
