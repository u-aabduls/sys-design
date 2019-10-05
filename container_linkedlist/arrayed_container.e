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
	imp: LINKED_LIST[STRING]

feature -- Public Attributes
	count: INTEGER -- You must keep this as an attribute.

feature -- Constructor
	make
			-- Initialize an empty container.
		do
			create imp.make
			count := 0
		ensure
			empty_container: imp.count = 0 and count = 0 -- Your Task
		end

feature -- Commands

	circular_shift_to_left
			-- Circularly shift all items to the left by one position.
		local
			first: STRING

		do
			if count > 1 then
				first := imp.first
				across 1 |..| (count-1) is i_c
				  loop
					imp.put_i_th ((imp.deep_twin)[i_c+1],i_c)
				end
				imp.put_i_th (first, count)
			end

		ensure
			size_unchanged: count = old count -- Your Task
			items_shifted:
				count > 1 implies
				imp[count] ~ (old imp.deep_twin)[1] and
				across 1 |..| (count-1) is j
					all
						imp[j] ~ (old imp.deep_twin)[j+1]
				end -- Your Task
		end

	insert_first (s: STRING)
			-- Insert 's' as the first item in the container.
		require
			s_not_empty: not s.is_empty -- Your Task
		do
			imp.put_front (s)
			count := count + 1

		ensure
			size_incremented: count = old count + 1 -- Your Task
			first_inserted: imp[1] ~ s -- Your Task
			others_unchanged:
				across 2 |..| count is i_c
				  all
					imp[i_c] ~ (old imp.deep_twin)[i_c-1]
				end-- Your Task
		end


feature -- Query

	valid_index (i: INTEGER): BOOLEAN
			-- Is 'i' a valid index of the container?
		do
			Result := imp.valid_index (i+1)
		ensure
			result_correct: 1 <= i+1 and i+1 <= count -- Your Task
			nothing_changed: across 1 |..| count is i_c
								all imp[i_c] ~ (old imp.deep_twin)[i_c]
							end -- Your Task
		end

	get_at (i: INTEGER): STRING
		require
			valid_index: 1 <= i+1 and i+1 <= count -- Your Task
		do
			-- Your Task (delete the line below if necessary)
			Result := imp[i+1]
		ensure
			result_correct: Result ~ (old imp.deep_twin)[i+1] -- Your Task
			nothing_changed: across 1 |..| count is i_c
								all imp[i_c] ~ (old imp.deep_twin)[i_c]
							end -- Your Task
		end

invariant
    -- Do not remove this invariant.
	consistent_counts: imp.count = count
	no_rebase: imp.lower = 1
end
