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
	SINGLE_MATH
	  redefine
	    out
	  end

create

	make

feature -- Initialization

	make
			-- Initialize a default PIECE object: "."
		do
			create type.make_from_string(".")
		end

feature -- Attributes

	type: STRING

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
			Result := Current.type
		end

feature -- Helper Methods

	diff(a: INTEGER; b: INTEGER): INTEGER
			-- Return the difference of `a` and `b`.
		do
			Result := a - b
		end

	equal_pts(x1: INTEGER; y1: INTEGER; x2: INTEGER; y2: INTEGER): BOOLEAN
			-- Are the points `(x1, y1)` and `(x2, y2)` equal?
		do
			Result := x1 = x2 and y1 = y2
		end

	power(x: INTEGER): INTEGER
			-- Return `x` raised to the second power.
		do
			Result := x * x
		end

	get_distance(x1: INTEGER; y1: INTEGER; x2: INTEGER; y2: INTEGER): REAL
			-- Retrun the distance between two points
			-- `(x1,y1)` and `(x2, y2)`.
		do
			Result := sqrt((power(x2-x1))+(power(y2-y1)))
		end

end
