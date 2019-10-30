note
	description: "A CHESS SOLITAIRE game."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	ANY
		redefine
			out
		end

create {GAME_ACCESS}

	make


feature -- Attributes

	game_board, moves_board: ARRAY2[STRING]
	chess_pieces: ARRAY[STRING]
	pieces_count: INTEGER
	game_started, game_over, is_move_report: BOOLEAN
	report: STRING
	error_handler: GAME_ERROR_HANDLER


feature {NONE} -- Initialization

	make
			-- Initialize `Current`.
		do
			create game_board.make_filled (".", 4, 4)
			create moves_board.make_filled (".", 4, 4)
			game_started := false
			game_over := false
			is_move_report := false
			pieces_count := 0
			create chess_pieces.make_from_array (<< "K", "Q", "N", "B", "R", "P" >>)
			create error_handler.make_empty
			report := "Game being Setup..."
		end


feature -- Commands

	start_game
			-- Start the game with the current state
			-- of `game_board`.

		require
			game_not_started:
				not game_started
		do
			report := "Game In Progress..."
			game_started := true
		end


	reset_game
			-- Reset the game to its default state.

		require
			is_game_started:
				game_started
		do
			make
		end


	setup_chess(chess: INTEGER; row: INTEGER; col: INTEGER)
			-- Place a chess piece `chess` at the position
			-- `game_board[row, col]`.

		require
			game_not_started:
				not game_started

			valid_slot:
				is_valid_slot(row, col)

			slot_not_occupied:
				not is_slot_occupied(row, col)
		do
			report := "Game being Setup..."
			pieces_count := pieces_count + 1
			game_board[row, col] := chess_pieces[chess]
		end


	moves(row: INTEGER; col: INTEGER; flag: BOOLEAN): ARRAY2[STRING]
			-- Display the possible moves for the chess piece
			-- located at position `game_board[row, col]`. The
			-- boolean `flag` is set to `false` to indicate the
			-- use of this feature in the `require` clause
			-- of some feature.

		require
			is_game_started:
				game_started

			game_not_over:
				not game_over

			slot_valid:
				is_valid_slot(row, col)

			slot_occupied:
				is_slot_occupied(row, col)

		local
			chess: STRING
		do
			report := "Game In Progress..."
			if flag then
				is_move_report := true
			end
			chess := game_board[row, col]

			across 1 |..| 4 is i loop
		 	 across 1 |..| 4  is j loop

		 	 		-- CHESS PIECE is a KING
		 		if chess ~ "K" then
		 		  if (i-row).abs <= 1 and
		 		  	 (j-col).abs <= 1
		 		  then
		 			 moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "Q" then
		 			-- CHESS PIECE is a QUEEN
				  if (row-i).abs = (col-j).abs
		 			 or -1*(row-i) = (col-j)
		 		   	 or (row-i) = -1*(col-j)
		 			 or i = row
		 			 or j = col
		 		  then
		 			 moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "N" then
		 			-- CHESS PIECE is a KNIGHT
		 		  if (i-row).abs = 1 and (j-col).abs = 2 or
		 			 (i-row).abs = 2 and (j-col).abs = 1
		 	      then
			 	    moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "B" then
		 			-- CHESS PIECE is a BISHOP
		 	   	  if (row-i).abs = (col-j).abs
		 			or -(row-i) = (col-j)
		 			or (row-i) = -(col-j)
		 		  then
		 			moves_board[i, j] := "+"
		 		  end

		 		elseif chess ~ "R" then
		 			-- CHESS PIECE is a ROOK
				  if i = row or j = col then
					moves_board[i, j] := "+"
				  end

		 		elseif chess ~ "P" then
		 			-- CHESS PIECE is a PAWN
	 			  if (i-row = -1)  and
	 			  	 ((j-col = -1) or (j-col = 1))
	 			  then
	 			  	moves_board[i, j] := "+"
	 			  end
		 		end
			  end
			end
			moves_board[row, col] := chess
			Result := moves_board
		end


	move_and_capture(r1: INTEGER; c1: INTEGER; r2: INTEGER; c2: INTEGER)
			-- Move the chess piece located at postion
			-- `game_board[r1, c1]` to capture the chess
			-- piece located at position `game_board[r2, c2]`.

		require
			is_game_started:
				game_started

			game_not_over:
				not game_over

			slot_1_valid:
				is_valid_slot(r1, c1)

			slot_2_valid:
				is_valid_slot(r2, c2)

			slot_1_occupied:
				is_slot_occupied(r1, c1)

			slot_2_occupied:
				is_slot_occupied(r2, c2)

			is_possible_move:
				is_possible_move(r1, c1, r2, c2)

			is_not_blocked:
				not is_blocked(r1, c1, r2, c2)

		do
			game_board[r2, c2] := game_board[r1, c1]
			game_board[r1, c1] := "."
			pieces_count := pieces_count - 1
		end


feature -- Auxiliary Queries

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
			-- (row, col) on `game_board`?
		do
			Result := game_board[row, col] /~ "."
		end


	is_possible_move(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER): BOOLEAN
			-- Is the the coordinate `(to_r, to_c)` a member
			-- of the set of possible moves of the chess piece
			-- positioned at `game_board[from_r, from_c]`.
		do
			Result := moves(from_r, from_c, false)[to_r, to_c] ~ "+"
		end


	is_blocked(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER): BOOLEAN
			-- Is the chess piece at `game_board[from_r, from_c]`
			-- blocked from moving and capturing the chess
			-- piece at `game_board[to_r, to_c]` by some other
			-- chess piece along the path of the move?
		local
			chess: STRING
		do
			chess := game_board[from_r, from_c]

			if chess ~ "K" or chess ~ "P" then
					-- King and Pawn cannot be blocked.
				Result := false
			else
				across 1 |..| 4 is i loop
				 across 1 |..| 4 is j loop
				  if chess ~ "Q" then
					Result := false
				  elseif chess ~ "N" then
					Result := false
				  elseif chess ~ "B" then
					Result := false
				  elseif chess ~ "R" then
					Result := false
				  end
				end
			  end
			end
		end


	board_to_string(board: ARRAY2[STRING]): STRING
			-- Return a string representation of a 2D-ARRAY
			-- board `board`.
		do
			create Result.make_empty
			across 1 |..| 4 is i loop
				Result.append ("  ")
				across 1 |..| 4 is j loop
					Result.append (board[i,j])
				end
				if i < 4 then
					Result.append("%N")
				end
			end
		end


	out: STRING
			-- Report the current state of the GAME.
		do
			Result := "  # of chess pieces on board: "
			Result.append(pieces_count.out)
			Result.append("%N")

				-- Report the error if:
			if error_handler.is_set then
				report := error_handler.get_error.deep_twin
				error_handler.make_empty

				-- Game is Won if:
			elseif game_started and pieces_count <= 1 then
				report := "Game Over: You Win!"
				game_over := true

			end

			Result := Result + "  " + report + "%N"

			if is_move_report then
				Result.append(board_to_string(moves_board))
			else
				Result.append(board_to_string(game_board))
			end

				-- Reset `moves_board` after reporting the
				-- sate of the GAME.
			moves_board.make_filled (".", 4, 4)
			is_move_report := false
		end
end




