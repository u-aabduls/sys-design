note
	description: "Summary description for {ROOK}."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOK

inherit
	PIECE
		redefine
			make,
			get_moves,
			is_blocked
		end

create

	make

feature -- Initializaton

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
			possible_moves[row, col] := Current.get_type
			Result := possible_moves
		end


	is_blocked(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER; game_board: ARRAY2[PIECE]): BOOLEAN
			-- Refer to Precursor class for feature definition
		local
			row, col: INTEGER
			possible_moves: ARRAY2[STRING]

		do
			Result := false

			create possible_moves.make_filled (".", 4, 4)
			possible_moves := get_moves(from_r, from_c)

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
				      if not equal_pts(from_r, from_c, row, col)
				         and not equal_pts(row, col, to_r, to_c)
				      then
				      	 Result := get_distance(from_r, from_c, row, col) +
							    get_distance(row, col, to_r, to_c) =
								get_distance(from_r, from_c, to_r, to_c)
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
