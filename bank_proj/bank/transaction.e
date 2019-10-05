note
	description: "A transaction encapsulates a pair of deposit/withdraw value with its timestamp."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TRANSACTION

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature -- Constructor
	make (v: INTEGER; d: DATE)
			-- Initialize a transaction with value 'v' and date 'd'.
		do
			value := v
			date := d
		ensure
			value_set:
				value = v
			date_set:
				date = d
		end

feature -- Attributes
	value: INTEGER
	date: DATE

feature -- Equality
	is_equal(other: like Current): BOOLEAN -- anchor type
		-- Are two transactions' date and value equal?
		do
			Result :=
				value = other.value and
				date ~ other.date
		end

invariant
	value > 0


end
