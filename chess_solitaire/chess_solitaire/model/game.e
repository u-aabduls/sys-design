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


feature {NONE} -- Attributes

	game_board: ARRAY2[PIECE]
	moves_board: ARRAY2[STRING]
	pieces_count, move_count: INTEGER
	move_count_for_setup, piece_count_at_start: INTEGER
	game_started, game_over, is_move_report: BOOLEAN
	report: STRING
	game_history: LINKED_LIST[ARRAY2[PIECE]]
	helper: GAME_HELPER
	error_handler: GAME_ERROR_HANDLER


feature {NONE} -- Initialization

	make
			-- Initialize `GAME`.

		local
			piece: PIECE
		do
				-- Initialize `game_board` with default
				-- pieces `piece`
			create game_board.make_filled(create {PIECE}.make, 4, 4)
				-- Initialize `moves_board` to blank
			create moves_board.make_filled (".", 4, 4)
				-- Initialize GAME state`
			game_started := false
			game_over := false
			is_move_report := false
			pieces_count := 0
			move_count := 0
				-- Attributes used for backtracking
				-- and restarting a current game
			move_count_for_setup := 0
			piece_count_at_start := 0
				-- Initialize history to empty
			create game_history.make
				-- Initialize `error_handler` to `default`
			create error_handler.init
				-- Initialize `helper`
			create helper.init
				-- Set initial report message
			report := "Game being Setup..."
		end


feature -- Accessors

	get_game_board: ARRAY2[PIECE]
			-- Return the current state of `game_board`.
		do
			Result := game_board.deep_twin
		end

	get_moves_board: ARRAY2[STRING]
			-- Return the current state of `moves_board`.
		do
			Result := moves_board.deep_twin
		end

	game_started_state: BOOLEAN
			-- Return the current state of `game_started`.
		do
			Result := game_started
		end

	game_over_state: BOOLEAN
			-- Return the current state of `game_over`.
		do
			Result := game_over
		end

	get_move_report_state: BOOLEAN
			-- Return the current state of `is_move_report`.
		do
			Result := is_move_report
		end

	get_piece_count: INTEGER
			-- Return the current `pieces_count`.
		do
			Result := pieces_count
		end

	get_move_count: INTEGER
			-- Return the current `move_count`.
		do
			Result := move_count
		end

	get_move_count_for_setup: INTEGER
			-- Return the current `move_count_for_setup`.
		do
			Result := move_count_for_setup
		end

	get_piece_count_at_start: INTEGER
			-- Return the `piece_count_at_start`.
		do
			Result := piece_count_at_start
		end

	get_game_history: LINKED_LIST[ARRAY2[PIECE]]
			-- Return the current `game_history`.
		do
			Result := game_history
		end

	get_helper: GAME_HELPER
			-- Return the current `helper`.
		do
			Result := helper
		end

	get_error_handler: GAME_ERROR_HANDLER
			-- Return the current `error_handler`.
		do
			Result := error_handler
		end

	get_report_state: STRING
			-- Return the current state of `report`.
		do
			Result := report.deep_twin
		end


feature -- Commands

	start_game
			-- Start the game with the current state
			-- of `game_board`.

		require
			game_not_started:
				game_started_state = false

		do
			report := "Game In Progress..."
				-- Store the number of moves made
				-- to setup the game
			move_count_for_setup := move_count
				-- Store the piece count at the
				-- start of the game
			piece_count_at_start := pieces_count
			game_started := true

		ensure
			game_started_set:
				game_started

			piece_count_at_start_set:
				piece_count_at_start = old pieces_count

			move_count_for_setup_set:
				move_count_for_setup = old move_count

			report_properly_set:
				report ~ "Game In Progress..."
		end


	reset_game
			-- Reset the game to its default state.

		require
			is_game_started:
				game_started_state = true
		do
			make

		ensure
			game_board_reset:
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  game_board[row, col].get_type ~ "."
			    end
			  end

			moves_board_reset:
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  moves_board[row, col] ~ "."
			    end
			  end

			piece_count_reset:
			 	pieces_count = 0

			default_game_state:
			 	    game_started = false
				and	game_over = false
				and is_move_report = false
				and piece_count_at_start = 0
				and move_count_for_setup = 0

			default_error_state:
			 	    (not error_handler.is_set)
			 	and error_handler.get_error ~ ""

		end


	setup_chess(chess: INTEGER; row: INTEGER; col: INTEGER)
			-- Place a chess piece `chess` at the position
			-- `game_board[row, col]`.

		require
			game_not_started:
				game_started_state = false

			valid_slot:
				get_helper.is_valid_slot(row, col)

			slot_not_occupied:
				not get_helper.is_slot_occupied(row, col)

		local
			type: STRING
			chess_piece: PIECE
			mapped_pieces: HASH_TABLE[STRING, INTEGER]

		do
			report := "Game being Setup..."

				-- Save the current `game_board` state
			game_history.put_front(game_board.deep_twin)
			move_count := move_count + 1

				-- Map integers to chess PIECES
			mapped_pieces := get_helper.integer_to_chess
				-- Get the PIECE type from `chess`
			type := mapped_pieces.at(chess)

			if     type ~ "K" then
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

		ensure
			report_set:
				report ~ "Game being Setup..."

			counts_incremented:
					pieces_count = old pieces_count + 1
				and move_count = old move_count + 1

			chess_piece_set:
				not game_board[row, col].is_same((old game_board.deep_twin)[row, col])

			other_slots_unchanged:
				across 1 |..| 4 is i all
			      across 1 |..| 4 is j all
			      	((row /= i) and (col /= j)) implies
				      game_board[i, j].is_same((old game_board.deep_twin)[i, j])
			      end
			    end
		end


	moves(row: INTEGER; col: INTEGER; flag: BOOLEAN): ARRAY2[STRING]
			-- Display the possible moves for the chess piece
			-- located at position `game_board[row, col]`. The
			-- boolean `flag` is set to `true` to indicate the
			-- use of this feature from a client of `Current`.

		require
			is_game_started:
				game_started_state = true

			game_not_over:
				game_over_state = false

			slot_valid:
				get_helper.is_valid_slot(row, col)

			slot_occupied:
				get_helper.is_slot_occupied(row, col)

		do
			report := "Game In Progress..."
			if flag then
				is_move_report := true
			end
			moves_board := game_board[row, col].get_moves(row, col)
			Result := moves_board.deep_twin

		ensure
			report_set:
				report ~ "Game In Progress..."

			move_report_set:
				flag implies is_move_report

			correct_moves_reported:
				across 1 |..| 4 is i all
			      across 1 |..| 4 is j all
			      	moves_board[i, j] ~ "+" implies
			      	  get_helper.is_possible_move(row, col, i, j)
			      end
			    end

			    and

			    across 1 |..| 4 is i all
			      across 1 |..| 4 is j all
			      	moves_board[i, j] ~ "." implies
			      	  not get_helper.is_possible_move(row, col, i, j)
			      end
			    end

		end


	move_and_capture(from_r: INTEGER; from_c: INTEGER; to_r: INTEGER; to_c: INTEGER)
			-- Move the chess piece located at postion
			-- `game_board[from_r, from_c]` to capture the chess
			-- piece located at position `game_board[to_r, to_r]`.

		require
			is_game_started:
				game_started_state = true

			game_not_over:
				game_over_state = false

			slot_1_valid:
				get_helper.is_valid_slot(from_r, from_c)

			slot_2_valid:
				get_helper.is_valid_slot(to_r, to_c)

			slot_1_occupied:
				get_helper.is_slot_occupied(from_r, from_c)

			slot_2_occupied:
				get_helper.is_slot_occupied(to_r, to_c)

			is_possible_move:
				get_helper.is_possible_move(from_r, from_c, to_r, to_c)

			is_not_blocked:
				not get_helper.is_blocked(from_r, from_c, to_r, to_c)

		local
			chess_piece: PIECE

		do
				-- Save the current `game_board` state
			game_history.put_front(game_board.deep_twin)
			move_count := move_count + 1
				-- Create a default `PIECE`
			create chess_piece.make
			game_board[to_r, to_c] := game_board[from_r, from_c]
				-- Set `game_board[from_r, from_c]` to "."
				-- (i.e. the default `PIECE`
			game_board[from_r, from_c] := chess_piece
			pieces_count := pieces_count - 1

		ensure
			piece_count_decremented:
				pieces_count = old pieces_count - 1

			piece_moved:
					game_board[to_r, to_c].is_same((old game_board.deep_twin)[from_r, from_c])
				and game_board[from_r, from_c].get_type ~ "."

			other_slots_unchanged:
				across 1 |..| 4 is i all
			      across 1 |..| 4 is j all
				        ((i /= from_r) and (j /= from_c))
				    and ((i /= to_r) and (j /= to_c)) implies
				    game_board[i, j].is_same((old game_board.deep_twin)[i, j])
			      end
			    end
		end


	undo
			-- Undo the last move and reset `game_board`
			-- to its previous state.
		require
			game_not_over:
				game_over_state = false

			move_history_not_empty:
				not (get_move_count = 0) and not (get_game_history.count = 0)

			not_undo_past_game_start:
				get_move_count > get_move_count_for_setup

		do
			game_board := game_history.first
				-- Remove the latest entry to `game_history`.
			get_helper.remove_latest(1)
			move_count := move_count - 1
				-- Update the piece count
			if game_started then
				pieces_count := pieces_count + 1
			else
				pieces_count := pieces_count - 1
			end

		ensure
			move_count_decremented:
				move_count = old move_count - 1

			previous_game_board_set:
				across 1 |..| 4 is row all
			      across 1 |..| 4 is col all
	          	    game_board[row, col].get_type ~
	          	    (old game_history.deep_twin).first[row, col].get_type
			      end
			    end
		end


	restart
			-- Restart the GAME to its state when
			-- the game was started.
		require
			game_started:
				game_started_state = true

			game_not_over:
				game_over_state = false

			restart_available:
				get_move_count > get_move_count_for_setup

		local
			n: INTEGER

		do
				-- Get the position of initial `game_board`
			n := move_count - move_count_for_setup
				-- Reset `game_board` to the game board the
				-- game was started with
			game_board := game_history.at(n)
				-- Remove the latest `n` entries to the game
				-- history that proceeded the initial `game_board`
			get_helper.remove_latest(n)
				-- Restore the piece count and move count
				-- to the `pieces_count` and `move_count`
				-- at the start of the game
			pieces_count := piece_count_at_start
			move_count := move_count_for_setup

		ensure
			piece_count_reset:
				pieces_count = piece_count_at_start

			initial_game_board_set:
				across 1 |..| 4 is row all
			      across 1 |..| 4 is col all
	          	    game_board[row, col].get_type ~
	          	    (old game_history.deep_twin).at(old move_count -
	          	     old move_count_for_setup)[row, col].get_type
			      end
			    end

			previous_game_history_wiped:
				game_history.count = old move_count_for_setup
		end


feature -- Report

	out: STRING
			-- Report the current state of the GAME.
		do
			Result := ""

				-- Uncomment for a more a readable
				-- display to command line.
--			Result.append("%N")

			Result.append("  # of chess pieces on board: ")
			Result.append(pieces_count.out)
			Result.append("%N")

				-- Report the error if:
			if error_handler.is_set then
				report := error_handler.get_error.deep_twin
				error_handler.init

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
				and not get_helper.valid_move_exists then
				report := "Game Over: You Lose!"
				game_over := true

			end

				-- Append the `report` state
			Result.append ("  " + report + "%N")

				-- Uncomment for a more a readable
				-- display to command line.
--			Result.append("%N")

			if is_move_report then
				Result.append(get_helper.board_out(moves_board))
			else
				Result.append(get_helper.board_out(game_board))
			end

				-- Uncomment for a more a readable
				-- display to command line.
--			Result.append("%N")

				-- Reset `moves_board` state after
				-- reporting the sate of the GAME.
			moves_board.make_filled (".", 4, 4)
			is_move_report := false
		end


invariant

	valid_piece_count:
		pieces_count >= 0 and pieces_count <= 16

	valid_pieces:
		across 1 |..| 4 is row all
		  across 1 |..| 4 is col all
		  	   attached {PIECE} game_board[row, col]
		  end
		end

	valid_moves_map:
		across 1 |..| 4 is row all
		  across 1 |..| 4 is col all
		  	   moves_board[row, col] ~ "+"
		  	or moves_board[row, col] ~ "."
		  	or moves_board[row, col] ~ "K"
		  	or moves_board[row, col] ~ "Q"
		  	or moves_board[row, col] ~ "N"
		  	or moves_board[row, col] ~ "B"
		  	or moves_board[row, col] ~ "R"
		  	or moves_board[row, col] ~ "P"
		  end
		end

end




