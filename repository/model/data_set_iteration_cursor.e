note
	description: "A DATA_SET iteration cursor for the REPOSITORY ADT."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	DATA_SET_ITERATION_CURSOR[DATA1, DATA2, KEY -> HASHABLE]

inherit
	ITERATION_CURSOR [DATA_SET[DATA1, DATA2, KEY]]

create
	make

feature {NONE} -- Attributes

	keys: LINKED_LIST[KEY]
	data_items_1: ARRAY[DATA1]
	data_items_2: HASH_TABLE[DATA2, KEY]
	cursor_position: INTEGER

feature -- Constructor

	make(ka: LINKED_LIST[KEY]; d1: ARRAY[DATA1]; d2: HASH_TABLE[DATA2, KEY])
		do
			keys := ka
			data_items_1 := d1
			data_items_2 := d2
			cursor_position := ka.lower
		end

feature -- Cursor Operations

	item: DATA_SET[DATA1, DATA2, KEY]
			-- Returns the DATA_SET of `DATA1`, `DATA2`, `KEY`
			-- at the current `cursor_position`.
		local
			d2: DATA2
		do
			check attached data_items_2[keys[cursor_position]] as d2_dum then
				d2 := d2_dum
			end
			create Result.make (data_items_1[cursor_position],
								d2, keys[cursor_position])
		end

	after: BOOLEAN
			-- Returns `TRUE` when cursor position exceeds
			-- the last valid index of client iterable object.
		do
			Result := cursor_position > keys.count
		end

	forth
			-- Advances `cursor_position` to the right.
		do
			cursor_position := cursor_position + 1
		end

invariant
	consistent_data_counts:
		-- all collections have equal counts
			keys.count = data_items_1.count
		and data_items_1.count = data_items_2.count

end
