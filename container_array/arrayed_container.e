note
	description: "EECS3311 Lab Test 1 Exercise"
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	ARRAYED_CONTAINER

create
	make

feature {NONE} -- Implementation attribute
	-- Once you complete the current version where `imp` is an array,
	-- duplicate the starter project and change it to `imp: LINKED_LIST[STRING]`.
	-- Then complete the alternative version so you can also practice the use of a linked list.
	imp: ARRAY[STRING]

feature -- Public Attributes
	count: INTEGER -- You must keep this as an attribute.

feature -- Constructor
	make
			-- Initialize an empty container.
		do
			create imp.make_empty
			count := 0
		ensure
			empty_container:
				imp.count = 0 and count = 0
		end

feature -- Commands

	circular_shift_to_left
			-- Circularly shift all items to the left by one position.
		local
			first: STRING
			i: INTEGER
			temp: ARRAY[STRING]

		do
			if count > 0 then
				create temp.make_from_array (imp.deep_twin)
				first := imp[1]
				from
					i := count - 1
				until
					i = 0
				loop
					imp[i] := temp[i+1]
					i := i - 1
				end
				imp[count] := first
			end

		ensure
			size_unchanged: count = old count -- Your Task
			items_shifted:
				count > 0 implies
				imp[count] ~ (old imp.deep_twin)[1] and
				across 1 |..| (count-1) is i_c
				 all
					imp[i_c] ~ (old imp.deep_twin)[i_c+1]
				end

		end

	insert_first (s: STRING)
			-- Insert 's' as the first item in the container.
		require
			s_not_empty: not s.is_empty

		local
			i: INTEGER
			temp: ARRAY[STRING]

		do
			create temp.make_from_array(imp.deep_twin)

			count := count + 1

			from
				i := 1
			until
				i > count
			loop
				if i = 1 then
					imp.force (s, i)
				else
					imp.force(temp[i-1], i)
				end
				i := i + 1
			end

		ensure
			size_incremented: count = old count + 1
			first_inserted: imp[1] ~ s
			others_unchanged:
				across 2 |..| (count-1) is i_c
				 all
				 	imp[i_c] ~ (old imp.deep_twin)[i_c-1]
				end
		end


feature -- Query

	valid_index (i: INTEGER): BOOLEAN
			-- Is 'i' a valid index of the container?
		do
			Result := imp.valid_index (i+1)
		ensure
			result_correct:
				1 <= (i+1) and (i+1) <= count
			nothing_changed:
				across 1 |..| count is i_c
				 all
				 	imp[i_c] ~ (old imp.deep_twin)[i_c]
				end
		end

	get_at (i: INTEGER): STRING
		require
			valid_index: 1 <= (i+1) and (i+1) <= count
		do
			Result := imp[i+1]
		ensure
			result_correct:
				Result ~ (old imp.deep_twin)[i+1]
			nothing_changed:
				across 1 |..| count is i_c
				 all
				 	imp[i_c] ~ (old imp.deep_twin)[i_c]
				end
		end

invariant
    -- Do not remove this invariant.
	consistent_counts: imp.count = count
	no_rebase: imp.lower = 1
end
