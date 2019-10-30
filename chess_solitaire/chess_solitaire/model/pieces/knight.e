note
	description: "Summary description for {KNIGHT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	KNIGHT

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
			-- Initialize a KNIGHT object: "N"
		do
			create type.make_from_string ("N")
		end

feature -- Queries

	get_moves(row: INTEGER; col: INTEGER): ARRAY2[STRING]
			-- Return a 2D-Array of possible moves
			-- for `KNIGHT` chess piece.
		local
			possible_moves: ARRAY2[STRING]
		do
			create possible_moves.make_filled (".", 4, 4)

			across 1 |..| 4 is i loop
			 across 1 |..| 4  is j loop
			 	if (i-row).abs = 1 and (j-col).abs = 2 or
		 		   (i-row).abs = 2 and (j-col).abs = 1
		 	    then
			 	   possible_moves[i, j] := "+"
		 		end
			 end
			end
			possible_moves[row, col] := Current.type
			Result := possible_moves
		end

end
