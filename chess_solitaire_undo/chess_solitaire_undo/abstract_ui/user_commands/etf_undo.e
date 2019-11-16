note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
create
	make
feature -- command
	undo
    	do
			-- perform some update on the model state

			if not game.get_helper.undo_available then
				game.get_error_handler.set_error_nothing_to_undo
			else
				game.undo
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
