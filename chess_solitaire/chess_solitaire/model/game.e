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

	game_board: ARRAY2[PIECE]
	moves_board: ARRAY2[STRING]
	pieces_count: INTEGER
	game_started, game_over, is_move_report: BOOLEAN
	report: STRING
	error_handler: GAME_ERROR_HANDLER


feature {NONE} -- Initialization

	make
			-- Initialize `GAME`.

		local
			piece: PIECE
		do
				-- Create a default piece `piece`
			create piece.make
				-- Populate the game board with `piece`
			create game_board.make_filled(piece, 4,4)
				-- Populate the moves board
			create moves_board.make_filled (".", 4, 4)
				-- Initialize GAME state to `default`
			game_started := false
			game_over := false
			is_move_report := false
			pieces_count := 0
			create error_handler.make_empty
				-- Set initial report message
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

		local
			type: STRING
			chess_piece: PIECE
			mapped_pieces: HASH_TABLE[STRING, INTEGER]

		do
			report := "Game being Setup..."

				-- Map integers to CHESS PIECES
			mapped_pieces := integer_to_chess
				-- Get the PIECE type from `chess`
			type := mapped_pieces.at(chess)

			if type ~ "K" then
				create {KING} chess_piece.make
			elseif type ~ "Q" then
				create {QUEEN} chess_piece.make
			elseif type ~ "N" then
				create {KNIGHT} chess_piece.make
			elseif type ~ "B" then
				create {BISHOP} chess_piece.make
			elseif type ~ "R" then
				create {ROOK} chess_piece.make
			elseif type ~ "P" then
				create {PAWN} chess_piece.make
			end

			check attached chess_piece AS piece then
				game_board[row, col] := piece
			end
				-- Increment the total number of pieces
			pieces_count := pieces_count + 1
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

		do
			report := "Game In Progress..."
			if flag then
				is_move_report := true
			end
			moves_board := game_board[row, col].get_moves(row, col)
			Result := moves_board.deep_twin
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

		local
			chess_piece: PIECE

		do
				-- Create a default `PIECE`
			create chess_piece.make
			game_board[r2, c2] := game_board[r1, c1]
				-- Set `game_board[r1, c1]` to "."
				-- (i.e. the default `PIECE`
			game_board[r1, c1] := chess_piece
			pieces_count := pieces_count - 1
		end


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
			-- (row, col) on `game_board`?
		do
			Result := game_board[row, col].type /~ "."
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
			piece: PIECE
		do
			piece := game_board[from_r, from_c]
			Result := piece.is_blocked(from_r, from_c,to_r, to_c, game_board.deep_twin)
		end


	valid_move_exists: BOOLEAN
			-- Does there exist any remaining possible moves?
			-- if `Result = false`, the game is over and the player has lost.
		local
			possible_moves: ARRAY2[STRING]
		do
			Result := false
				-- Iterate `game_board` and get the
				-- possible moves for each `PIECE` on
				-- the board
			across 1 |..| 4 is row loop
			 across 1 |..| 4  is col loop
			   if game_board[row,col].type /~ "." then
			     possible_moves := game_board[row, col].get_moves(row, col)
			       		-- Iterate the possible moves for the
			       		-- identified `PIECE` and check if there
			       		-- exists another `PIECE` located at any
			       		-- of the valid move coordinates
				   across 1 |..| 4 is i loop
			 		across 1 |..| 4  is j loop
			 		  if    possible_moves[i,j] ~ "+"
			 		  	and is_slot_occupied(i, j) then
			 		  	  Result := true
			 		  end
			 		end
				   end
			   end
			 end
			end
		end


feature -- Auxiliary Features

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

				-- Game is lost if:
			elseif game_started and pieces_count = 0 then
				report := "Game Over: You Lose!"
				game_over := true

				-- Game is won if:
			elseif game_started and pieces_count = 1 then
				report := "Game Over: You Win!"
				game_over := true

				-- Game is lost if:
			elseif  game_started
				and not valid_move_exists then
				report := "Game Over: You Lose!"
				game_over := true

			end

				-- Append the `report` state
			Result.append ("  " + report + "%N")

			if is_move_report then
				Result.append(board_out(moves_board))
			else
				Result.append(board_out(game_board))
			end

				-- Reset `moves_board` state after
				-- reporting the sate of the GAME.
			moves_board.make_filled (".", 4, 4)
			is_move_report := false
		end
end




