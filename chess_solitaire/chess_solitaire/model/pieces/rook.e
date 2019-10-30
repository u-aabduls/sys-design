note
	description: "Summary description for {ROOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROOK

inherit
	PIECE
		redefine
			make,
			get_moves
		end

create

	make

feature

	make
			-- Initialize a ROOK object: "R"
		do
			create type.make_from_string ("R")
		end

feature -- Queries

	get_moves(row: INTEGER; col: INTEGER): ARRAY2[STRING]
			-- Return a 2D-Array of possible moves
			-- for `Current` chess piece.
		local
			possible_moves: ARRAY2[STRING]
		do
			create possible_moves.make_filled (".", 4, 4)

			across 1 |..| 4 is i loop
			 across 1 |..| 4  is j loop
			 	if i = row or j = col then
				   possible_moves[i, j] := "+"
				end
			 end
			end
			possible_moves[row, col] := Current.type
			Result := possible_moves
		end

end
