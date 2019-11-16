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
	pieces_count, history_cursor: INTEGER
	game_started, game_over, is_move_report: BOOLEAN
	report: STRING
	error_handler: GAME_ERROR_HANDLER
	history_list: LINKED_LIST[COMMAND]
	helper: GAME_HELPER


feature {NONE} -- Initialization

	make
			-- Initialize `GAME`.

		local
			piece: PIECE
		do
				-- Create a default piece `piece`
			create piece.make
				-- Initialize `game_board` with `piece`
			create game_board.make_filled(piece, 4,4)
				-- Initialize `moves_board` to blank
			create moves_board.make_filled(".", 4, 4)
				-- Initialize GAME state`
			game_started := false
			game_over := false
			is_move_report := false
			pieces_count := 0
				-- Initialize `error_handler` to `default`
			create error_handler.init
				-- Initialize `history`attributes to empty
			create history_list.make
			history_cursor := history_list.lower
				-- Initialize `helper`
			create helper.init
				-- Set initial report message
			report := "Game being Setup..."
		end


feature -- Accessors

	get_game_board: ARRAY2[PIECE]
			-- Return the current state of `game_board`.
		do
			Result := game_board
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

	get_error_handler: GAME_ERROR_HANDLER
			-- Return the current `error_handler`.
		do
			Result := error_handler
		end

	get_history_list: LINKED_LIST[COMMAND]
			-- Return the current `history_list`.
		do
			Result := history_list
		end

	get_history_cursor: INTEGER
			-- Return the current `history_cursor`.
		do
			Result := history_cursor
		end

	get_helper: GAME_HELPER
			-- Return the current `helper`.
		do
			Result := helper
		end

	get_report_state: STRING
			-- Return the current state of `report`.
		do
			Result := report.deep_twin
		end


feature -- Setters

	set_game_started(flag: BOOLEAN)
			-- Set `start_game` to `flag`.
		do
			game_started := flag
		end

	set_game_over(flag: BOOLEAN)
			-- Set `game_over` to `flag`.
		do
			game_over := flag
		end

	set_game_report(s: STRING)
			-- Set `report` to `s`.
		do
			report := s
		end

	set_piece_count(n: INTEGER)
			-- Set `pieces_count` to `n`.
		do
			pieces_count := n
		end

	set_history_cursor(i: INTEGER)
			-- Set `history_cursor` to `i`.
		do
			history_cursor := i
		end


feature -- Commands

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
				and history_list.is_empty
				and history_cursor = history_list.lower

			default_error_state:
			 	    (not error_handler.is_set)
			 	and error_handler.get_error ~ ""

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


	undo
			-- Undo the latest issued request.
		require
			undo_is_available:
				get_helper.undo_available

		local
			request: COMMAND

		do
				-- undo the effects of the command
				-- at `history_cursor` position
			request := history_list.at(history_cursor)
			request.undo
				-- then advance `history_cursor` to the
				-- previous latest command
			history_cursor := history_cursor + 1

		end


	redo
			-- Redo the latest issued request.
		require
			redo_is_available:
				get_helper.redo_available

		local
			request: COMMAND

		do
				-- decrement `history_cursor`
			history_cursor := history_cursor - 1
				-- then redo the effects of the command
				-- at that `history_cursor` position
			request := history_list.at(history_cursor)
			request.redo
		end



feature -- Requests

	start_game
			-- Start the game with the current state
			-- of `game_board`.

		require
			game_not_started:
				game_started_state = false

		local
			request: COMMAND

		do
			helper.drop_left_history
			create {COMMAND_START_GAME} request.init
			request.execute
			history_list.put_front(request)

		ensure
			game_started_set:
				game_started

			report_properly_set:
				report ~ "Game In Progress..."
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
			request: COMMAND

		do
			helper.drop_left_history
			create {COMMAND_SETUP_CHESS} request.init(chess, row, col)
			request.execute
			history_list.put_front(request)

		ensure
			report_set:
				report ~ "Game being Setup..."

			piece_count_incremented:
				pieces_count = old pieces_count + 1

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
			request: COMMAND

		do
			helper.drop_left_history
			create {COMMAND_MOVE_AND_CAPTURE} request.init(from_r, from_c, to_r, to_c)
			request.execute
			history_list.put_front(request)

		ensure
			piece_count_decremented:
				pieces_count = old pieces_count - 1

			piece_moved:
					game_board[to_r, to_c].is_same((old game_board.deep_twin)[from_r, from_c])
				and game_board[from_r, from_c].get_type ~ "."

			other_slots_unchanged:
				across 1 |..| 4 is i all
			      across 1 |..| 4 is j all
				    ((i /= from_r) and (j /= from_c)) and ((i /= to_r) and (j /= to_c)) implies
				    game_board[i, j].is_same((old game_board.deep_twin)[i, j])
			      end
			    end
		end


feature -- Queries

	out: STRING
			-- Report the current state of the GAME.
		do
			Result := "  # of chess pieces on board: "
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
				and not helper.valid_move_exists then
				report := "Game Over: You Lose!"
				game_over := true

			end

				-- Append the `report` state
			Result.append ("  " + report + "%N")

			if is_move_report then
				Result.append(helper.board_out(moves_board))
			else
				Result.append(helper.board_out(game_board))
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




