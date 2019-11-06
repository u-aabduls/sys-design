note
	description: "Unit Tests for the CHESS SOLITAIRE game."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_UNIT_TESTS

inherit
	ES_TEST

create
	make

feature -- Add tests

	make
		local
			game: GAME
			game_access: GAME_ACCESS
		do
			game := game_access.game
			add_boolean_case(agent t1_constructor)
			add_boolean_case(agent t2_start_game)
			add_violation_case_with_tag ("game_not_started", agent t3_start_game)
			add_boolean_case(agent t4_reset_game)
			add_boolean_case(agent t5_setup_chess)
			add_violation_case_with_tag ("slot_not_occupied", agent t6_setup_chess)
			add_violation_case_with_tag("is_game_started", agent t7_move_and_capture)
			add_boolean_case (agent t8_move_and_capture)
			add_violation_case_with_tag("slot_2_occupied", agent t9_move_and_capture)
			add_boolean_case (agent t10_move_and_capture)
			add_boolean_case (agent t11_game_over)
		end

feature -- Tests

	t1_constructor: BOOLEAN
			-- Testing default state after creation of GAME.

		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t1_constructor: testing GAME state after constructor.")
			game := game_access.game
			Result :=
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  game.get_game_board[row, col].get_type ~ "."
			    end
			  end

			check Result end

			Result :=
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  game.get_moves_board[row, col] ~ "."
			    end
			  end

			 check Result end

			 Result :=    game.game_started_state = false
			 		  and game.game_over_state = false
			 		  and game.get_move_report_state = false
			 		  and game.get_piece_count = 0
			 		  and game.get_error_handler.is_set = false
			 		  and game.get_report_state ~ "Game being Setup..."

			 check Result end
		end


	t2_start_game: BOOLEAN
			-- Testing GAME state after `start_game`.

		local
			game: GAME
			game_access: GAME_ACCESS
		do

			comment("t2_start_game: Testing GAME state after `start_game`.")
			game := game_access.game
			Result :=
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  game.get_game_board[row, col].get_type ~ "."
			    end
			  end

			check Result end

			Result :=
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  game.get_moves_board[row, col] ~ "."
			    end
			  end

			 check Result end

			 Result :=    game.game_started_state = false
			 		  and game.game_over_state = false
			 		  and game.get_move_report_state = false
			 		  and game.get_piece_count = 0
			 		  and game.get_error_handler.is_set = false
			 		  and game.get_report_state ~ "Game being Setup..."

			 check Result end

			 	-- Start the game and check GAME state.
			 game.start_game

			 Result :=    game.game_started_state = true
			 		  and game.get_report_state ~ "Game In Progress..."

			 check Result end
		end


	t3_start_game
			-- Violation case: game_not_started

		local
			game: GAME
			game_access: GAME_ACCESS
		do

			comment("t3_start_game: Testing GAME state after invoking start_game twice.")
			game := game_access.game

			 	-- NOTE: Singleton access to GAME, so it is already started.
			 	-- Attempt to start the game again:
			 	-- PRECONDITION VIOLATION.
			 game.start_game
		end


	t4_reset_game: BOOLEAN
			-- Testing GAME state after `reset_game`.

		local
			game: GAME
			game_access: GAME_ACCESS
		do
			comment("t4_reset_game: Testing GAME state after `reset_game`.")
			game := game_access.game

				-- Reset GAME state.
			game.reset_game

			Result :=
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  game.get_game_board[row, col].get_type ~ "."
			    end
			  end

			check Result end

			Result :=
			  across 1 |..| 4 is row all
			    across 1 |..| 4 is col all
				  game.get_moves_board[row, col] ~ "."
			    end
			  end

			check Result end

			Result :=    game.game_started_state = false
			 		 and game.game_over_state = false
			 		 and game.get_move_report_state = false
			 		 and game.get_piece_count = 0
			 		 and game.get_error_handler.is_set = false
			 		 and game.get_report_state ~ "Game being Setup..."

			check Result end
		end


	t5_setup_chess: BOOLEAN
			-- Testing GAME state after `setup_chess`.

		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t5_setup_chess: Testing GAME state after `setup_chess`.")
			game := game_access.game

			game.setup_chess (1, 1, 1)
			Result :=    game.get_game_board[1,1].get_type ~ "K"
					 and game.get_piece_count = 1
			check Result end

			game.setup_chess (2, 4, 1)
			Result :=    game.get_game_board[4,1].get_type ~ "Q"
					 and game.get_piece_count = 2
			check Result end

			game.setup_chess (3, 2, 2)
			Result :=    game.get_game_board[2,2].get_type ~ "N"
					 and game.get_piece_count = 3
			check Result end

			game.setup_chess (4, 2, 4)
			Result :=    game.get_game_board[2,4].get_type ~ "B"
					 and game.get_piece_count = 4
			check Result end

			game.setup_chess (5, 3, 3)
			Result :=    game.get_game_board[3,3].get_type ~ "R"
					 and game.get_piece_count = 5
			check Result end

			game.setup_chess (6, 4, 4)
			Result :=    game.get_game_board[4,4].get_type ~ "P"
					 and game.get_piece_count = 6
			check Result end
		end


	t6_setup_chess
			-- Testing GAME state after `setup_chess` in occupied
			-- slot

		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t6_setup_chess: Testing GAME state after `setup_chess` in occupied slot.")
			game := game_access.game
			game.setup_chess (3, 2, 4)
		end


	t7_move_and_capture
			-- Testing GAME state after `move_and_capture`

		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t7_move_and_capture: Testing GAME state after `move_and_capture`.")
			game := game_access.game

				-- PRECONDITION VIOLATION: is_game_started
			game.move_and_capture (4, 4, 3, 3)
		end


	t8_move_and_capture: BOOLEAN
			-- Testing GAME state after `move_and_capture`

		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t8_move_and_capture: Testing GAME state after `move_and_capture`.")
			game := game_access.game

			game.start_game

			game.move_and_capture (4, 1, 4, 4)
			Result :=    game.get_game_board[4,4].get_type ~ "Q"
					 and game.get_game_board[4,1].get_type ~ "."
					 and game.get_piece_count = 5
					 and game.get_game_board[3,3].get_type ~ "R"
			check Result end

			game.move_and_capture (4, 4, 3, 3)
			Result :=    game.get_game_board[3,3].get_type ~ "Q"
					 and game.get_game_board[4,1].get_type ~ "."
					 and game.get_game_board[4,4].get_type ~ "."
					 and game.get_piece_count = 4
					 and game.get_game_board[2,4].get_type ~ "B"
			check Result end

			game.move_and_capture (3, 3, 2, 4)
			Result :=    game.get_game_board[2,4].get_type ~ "Q"
					 and game.get_game_board[3,3].get_type ~ "."
					 and game.get_game_board[4,4].get_type ~ "."
					 and game.get_game_board[4,1].get_type ~ "."
					 and game.get_piece_count = 3
					 and game.get_game_board[2,2].get_type ~ "N"
			check Result end

			game.move_and_capture (2, 4, 2, 2)
			Result :=    game.get_game_board[2,2].get_type ~ "Q"
					 and game.get_game_board[2,4].get_type ~ "."
					 and game.get_game_board[3,3].get_type ~ "."
					 and game.get_game_board[4,4].get_type ~ "."
					 and game.get_game_board[4,1].get_type ~ "."
					 and game.get_piece_count = 2
					 and game.get_game_board[1,1].get_type ~ "K"
			check Result end
		end


	t9_move_and_capture
			-- Testing GAME state after `move_and_capture`

		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t9_move_and_capture: Testing GAME state after `move_and_capture`.")
			game := game_access.game

				-- PRECONDITION VIOLATION: slot_2_occupied but also, is_possible_move
			game.move_and_capture (1, 1, 3, 3)
		end


	t10_move_and_capture: BOOLEAN
			-- Testing GAME state after `move_and_capture`

		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t10_move_and_capture: Testing GAME state after `move_and_capture`.")
			game := game_access.game

				-- Game Over: You Win!
			game.move_and_capture (2, 2, 1, 1)
			Result :=     game.get_game_board[1,1].get_type ~ "Q"
					  and game.get_game_board[2,2].get_type ~ "."
					  and game.get_piece_count = 1
			check Result end
		end


	t11_game_over: BOOLEAN
			-- Testing for valid moves existing.
		local
			game: GAME
			game_access: GAME_ACCESS

		do
			comment("t11_game_over: Testing for an existing valid move.")
			game := game_access.game

				-- reset game
			game.reset_game

				-- setup game
			game.setup_chess (6, 1, 4)
			game.setup_chess (1, 2, 1)
			game.setup_chess (3, 2, 3)
			game.setup_chess (4, 3, 3)
			game.setup_chess (1, 4, 1)

				-- Game Over: You Lose!

			Result := not game.get_helper.valid_move_exists

			check Result end
		end

end
