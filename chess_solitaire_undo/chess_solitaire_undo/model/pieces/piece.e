note
	description: "[
		An ancestor class for all valid CHESS PIECES. 
		This class acts as a place holder for unoccupied 
		slots. The default PIECE object is of type "."
       ]"
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


feature {GAME} -- Initialization

	make
			-- Initialize a default PIECE object: "."
		do
			create type.make_from_string(".")
			create helper.init
		end


feature {NONE} -- Attributes

	type: STRING
	helper: GAME_HELPER


feature -- Queries

	get_type: STRING
			-- Return the type of `Current`
		do
			Result := type
		end


	is_same(other: PIECE): BOOLEAN
			-- Is `other` the same type as Current?
		do
			Result := Current.get_type ~ other.get_type
		end


	get_moves(row: INTEGER; col: INTEGER): ARRAY2[STRING]
			-- Return a 2D-Array of possible moves
			-- for `Current` chess piece. NOTE:
		local
			possible_moves: ARRAY2[STRING]
		do
			create possible_moves.make_filled (".", 4, 4)
			Result := possible_moves
		end


	is_blocked(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER; game_board: ARRAY2[PIECE]): BOOLEAN
			-- Is the chess piece at `game_board[from_r, from_c]`
			-- blocked from moving and capturing the chess
			-- piece at `game_board[to_r, to_c]` by some other
			-- chess piece along the path of the move?

			-- NOTE: The default `PIECE` "." cannot be blocked.
		do
			Result := false
		end


	out: STRING
			-- Return a STRING representation of PIECE.
		do
			Result := Current.get_type
		end

invariant
	unchanged_type:
		   type ~ "."
		or type ~ "K"
		or type ~ "Q"
		or type ~ "N"
		or type ~ "B"
		or type ~ "R"
		or type ~ "P"
end
