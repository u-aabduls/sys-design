note
	description: "An ancestor class for all valid CHESS PIECES. This class acts as a place holder for unoccupied slots."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	PIECE

inherit
	ANY
	  redefine
	    out
	  end

create

	make

feature -- Initialize

	make
			-- Initialize a default PIECE object: "."
		do
			create type.make_from_string(".")
		end

feature -- Attributes

	type: STRING


feature -- Commands

	get_moves(row: INTEGER; col: INTEGER): ARRAY2[STRING]
			-- Return a 2D-Array of possible moves
			-- for `Current` chess piece. NOTE:
		local
			possible_moves: ARRAY2[STRING]
		do
			create possible_moves.make_filled (".", 4, 4)
			Result := possible_moves
		end

	out: STRING
			-- Return a STRING representation of PIECE.
		do
			Result := Current.type
		end
end
