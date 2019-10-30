note
	description: "Summary description for {QUEEN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	QUEEN

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
			-- Initialize a QUEEN object: "Q".
		do
			create type.make_from_string ("Q")
		end

feature -- Queries

	get_moves(row: INTEGER; col: INTEGER): ARRAY2[STRING]
			-- Return a 2D-Array of possible moves
			-- for `QUEEN` chess piece.
		local
			possible_moves: ARRAY2[STRING]
		do
			create possible_moves.make_filled (".", 4, 4)

			across 1 |..| 4 is i loop
			 across 1 |..| 4  is j loop
			 	if (row-i).abs = (col-j).abs
	 			   or -1*(row-i) = (col-j)
	 		   	   or (row-i) = -1*(col-j)
	 			   or i = row
	 			   or j = col
		 		then
		 			 possible_moves[i, j] := "+"
		 		end
			 end
			end
			possible_moves[row, col] := Current.type
			Result := possible_moves
		end

end
