note
	description: "Summary description for {GAME_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_HELPER

inherit
	SINGLE_MATH

create
	init


feature {GAME} -- Initialization

	init
		local
			game_access: GAME_ACCESS
		do
			game := game_access.game
		end


feature {GAME} -- Attributes

	game: GAME


feature -- Queries

	is_valid_slot(row: INTEGER; col: INTEGER): BOOLEAN
			-- Is the coordinate `(row,col)` a valid
			-- coordinate on `game_baord`?
		do
			Result := 	 row > 0
					 and row < 5
			   	     and col > 0
			         and col < 5
		end


	is_slot_occupied(row: INTEGER; col: INTEGER): BOOLEAN
			-- Is there a chess piece located at position
			-- `(row, col)` on `game_board`?
		local
			game_access: GAME_ACCESS
		do
			game := game_access.game
			Result := game.get_game_board[row, col].get_type /~ "."
		end


	is_possible_move(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER): BOOLEAN
			-- Is the coordinate `(to_r, to_c)` a member
			-- of the set of possible moves of the chess piece
			-- positioned at `game_board[from_r, from_c]`?
		local
			game_access: GAME_ACCESS
		do
			game := game_access.game
			Result := game.moves(from_r, from_c, false)[to_r, to_c] ~ "+"
		end


	is_blocked(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER): BOOLEAN
			-- Is the chess piece at `game_board[from_r, from_c]`
			-- blocked from moving and capturing the chess
			-- piece at `game_board[to_r, to_c]` by some other
			-- chess piece along the path of the move?

		local
			piece: PIECE
			game_access: GAME_ACCESS
		do
			game := game_access.game
			piece := game.get_game_board[from_r, from_c]
			Result := piece.is_blocked(from_r, from_c,to_r, to_c, game.get_game_board.deep_twin)
		end


	valid_move_exists: BOOLEAN
			-- Does there exist any remaining possible moves?
			-- if `Result = false`, the game is over and the player has lost.
		local
			game_access: GAME_ACCESS
			possible_moves: ARRAY2[STRING]
		do
			game := game_access.game
			Result := false
				-- Iterate `game_board` and get the
				-- possible moves for each `PIECE` on
				-- the board
			across 1 |..| 4 is row loop
			 across 1 |..| 4  is col loop
			   if is_slot_occupied(row, col) then
			     possible_moves := game.get_game_board[row, col].get_moves(row, col)
			       		-- Iterate the possible moves for the
			       		-- identified `PIECE` and check if there
			       		-- exists another `PIECE` located at any
			       		-- of the valid move coordinates
				   across 1 |..| 4 is i loop
			 		across 1 |..| 4  is j loop
			 		  if    possible_moves[i,j] ~ "+"
			 		  	and is_slot_occupied(i, j)
			 		  	and not is_blocked(row, col, i, j) then
			 		  	  Result := true
			 		  end
			 		end
				   end
			   end
			 end
			end
		end


	undo_available: BOOLEAN
			-- Does there exist a state to `undo` to?
		local
			game_access: GAME_ACCESS
		do
			game := game_access.game
			Result := game.get_history_cursor <= game.get_history_list.count
		end


	redo_available: BOOLEAN
			-- Does there exist a state to `redo` to?
		local
			game_access: GAME_ACCESS
		do
			game := game_access.game
			Result := game.get_history_cursor /= game.get_history_list.lower
		end


feature -- Commands

	drop_left_history
			-- Remove the history elements from position
			-- `history_list.lower` to `history_cursor`.
		local
			game_access: GAME_ACCESS
			index: INTEGER
		do
			game := game_access.game
			from
				index := 1
				game.get_history_list.start
			until
				index = game.get_history_cursor
			loop
				game.get_history_list.remove
				index := index + 1
			end
			game.set_history_cursor(game.get_history_list.lower)
		end


feature -- Auxiliary Features

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
			-- Retrun the distance between two points.
			-- `(x1,y1)` and `(x2, y2)`.
		do
			Result := sqrt((power(x2-x1))+(power(y2-y1)))
		end


	integer_to_chess: HASH_TABLE[STRING, INTEGER]
			-- Return a `HASH_TABLE` containing a mapping
			-- of the `PIECE` types to integers.
		local
			table: HASH_TABLE[STRING, INTEGER]
		do
			create table.make(0)
			table.extend("K", 1)
			table.extend("Q", 2)
			table.extend("N", 3)
			table.extend("B", 4)
			table.extend("R", 5)
			table.extend("P", 6)
			Result := table
		end


	board_out(board: ARRAY2[ANY]): STRING
			-- Return a string representation of a 2D-ARRAY
			-- board `board`.
		do
			create Result.make_empty
			across 1 |..| 4 is i loop
				Result.append("  ")
				across 1 |..| 4 is j loop
					Result.append(board[i,j].out)
						-- Uncomment for more readable display
						-- of `game_board` and `moves_baord`.
--					Result.append(board[i,j].out + " ")
				end
				if i < 4 then
					Result.append("%N")
				end
			end
		end



end
