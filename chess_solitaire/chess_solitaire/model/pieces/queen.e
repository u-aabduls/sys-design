note
	description: "Summary description for {QUEEN}."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	QUEEN

inherit
	PIECE
	  redefine
		make,
		get_moves,
		is_blocked
	  end

create

	make

feature -- Initialization

	make
			-- Initialize a QUEEN object: "Q".
		do
			Precursor
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
			possible_moves[row, col] := Current.get_type
			Result := possible_moves
		end


	is_blocked(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER; game_board: ARRAY2[PIECE]): BOOLEAN
			-- Refer to Precursor class for feature definition

		local
			row, col: INTEGER
			possible_moves: ARRAY2[STRING]

		do
				-- Initialize `Result` to false
			Result := false
				-- Get all the possible moves for the
				-- `PIECE` at `(from_r, from_c)` on the
				-- game board in the `GAME` class.
			create possible_moves.make_filled (".", 4, 4)
			possible_moves := get_moves(from_r, from_c)

				-- When a `+` is identified on `possible_moves`,
				-- check to see if there is a piece at the same
				-- location on `game_board`.
				-- If there is, compute the distance from `(from_r, from_c)`
				-- to that location `(row, col)`, and the distance from
				-- that location `(row, col)` to `(to_r, to_c)`. If the
				-- sum of the two distances is equal to the distance between
				-- `(from_r, from_c)` and `(to_r, to_c)`, the piece at
				-- `game_board[row, col]` is blocking the move.

				-- NOTE: If the piece is identified on either `(from_r, from_c)`
				-- or `(to_r, to_c)`, ignore it.
			from
				row := 1
			until
				row > 4
			loop
				from
					col := 1
				until
					col > 4
				loop
				  if possible_moves[row, col] ~ "+" then
				    if game_board[row, col].get_type /~ "." then
				      if not helper.equal_pts(from_r, from_c, row, col)
				         and not helper.equal_pts(row, col, to_r, to_c)
				      then
				      	 Result := helper.get_distance(from_r, from_c, row, col) +
							       helper.get_distance(row, col, to_r, to_c) =
								   helper.get_distance(from_r, from_c, to_r, to_c)
						 if Result then
						 	row := 5
						 	col := 5
						 end
				      end
					end
				  end
					col := col + 1
				end
				row := row + 1
			end
		end

end
