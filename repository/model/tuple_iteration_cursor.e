note
	description: "A TUPLE iteration cursor for the REPOSITORY ADT."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_ITERATION_CURSOR[KEY -> HASHABLE, DATA1, DATA2]

inherit
	ITERATION_CURSOR [TUPLE[DATA1, DATA2, KEY]]

create
	make

feature {NONE} -- Attributes

	keys: LINKED_LIST[KEY]
	data_items_1: ARRAY[DATA1]
	data_items_2: HASH_TABLE[DATA2, KEY]
	cursor_position: INTEGER

feature -- Constructor

	make (ks: LINKED_LIST[KEY]; d1: ARRAY[DATA1]; d2: HASH_TABLE[DATA2, KEY])
		do
			keys := ks
			data_items_1 := d1
			data_items_2 := d2
			cursor_position := data_items_1.lower
		end

feature -- Cursor Operations

	item: TUPLE[DATA1, DATA2, KEY]
			-- Returns the TUPLE of `DATA1`, `DATA2`, `KEY`
			-- at the current `cursor_position`.
		do
			create Result
			Result[1] := data_items_1[cursor_position]
			Result[2] := data_items_2.item (keys[cursor_position])
			Result[3] := keys[cursor_position]
		end

	after: BOOLEAN
			-- Returns `TRUE` when cursor position exceeds
			-- the last valid index of client iterable object.
		do
			Result := cursor_position > data_items_1.upper
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
