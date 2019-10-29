note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVES
inherit
	ETF_MOVES_INTERFACE
create
	make
feature -- command
	moves(row: INTEGER_32 ; col: INTEGER_32)
		local
			dormant: ARRAY2[STRING]
    	do
			-- perform some update on the model state
			dormant := model.moves(row, col, true)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
