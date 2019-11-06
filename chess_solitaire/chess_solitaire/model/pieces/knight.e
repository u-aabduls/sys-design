note
	description: "Summary description for {KNIGHT}."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	KNIGHT

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
			-- Initialize a KNIGHT object: "N"
		do
			Precursor
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
			possible_moves[row, col] := Current.get_type
			Result := possible_moves
		end


	is_blocked(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER; game_board: ARRAY2[PIECE]): BOOLEAN
			-- Refer to Precursor class for feature definition
		do
			Result := false
				-- Moving up 1, right 2
			if helper.diff(to_r, from_r)=1 and helper.diff(to_c, from_c)=2 then
				Result :=  game_board[from_r+1, from_c].get_type /~ "."
						or game_board[from_r+1, from_c+1].get_type /~ "."
				-- Moving down 1, right 2
			elseif helper.diff(to_r, from_r)=-1 and helper.diff(to_c, from_c)=2 then
				Result :=  game_board[from_r-1, from_c].get_type /~ "."
						or game_board[from_r-1, from_c+1].get_type /~ "."
				-- Moving up 1, left 2
			elseif helper.diff(to_r, from_r)=1 and helper.diff(to_c, from_c)=-2 then
				Result :=  game_board[from_r+1, from_c].get_type /~ "."
						or game_board[from_r+1, from_c-1].get_type /~ "."
				-- Moving down 1, left 2
			elseif helper.diff(to_r, from_r)=-1 and helper.diff(to_c, from_c)=-2 then
				Result :=  game_board[from_r-1, from_c].get_type /~ "."
						or game_board[from_r-1, from_c-1].get_type /~ "."
				-- Moving up 2
			elseif helper.diff(to_r, from_r)=2 then
				Result :=  game_board[from_r+1, from_c].get_type /~ "."
						or game_board[from_r+2, from_c].get_type /~ "."
				-- Moving down 2
			elseif helper.diff(to_r, from_r)=-2 then
				Result :=  game_board[from_r-1, from_c].get_type /~ "."
						or game_board[from_r-2, from_c].get_type /~ "."
			end
		end

end
