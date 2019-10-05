note
	description: "A counter always has its value between 0 and 10."
	author: "Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	MY_COUNTER

create -- We need to explicitly declare which feature(s) is/are constructor(s).
	make

feature -- Attributes
	value: INTEGER

feature -- Constructor
	make (v: INTEGER)
		-- Initialize a counter with value 'v'.
		-- Absense of require clause here means there are no preconditions to this constructor.
		-- Any input v of type INTEGER will be accepted and use to assing 'value'.
		require
			v >= 0 and v <= 10
		do
			value := v
		end

feature -- Mutator Methods
	increment_by(x: INTEGER)
		-- Increment counter value by x unless it causes it to exceed the maximum value.
		require
			value_pve:
				x > 0
			not_above_max:
			 	value + x <= 10
		do
			value := value + x
		ensure
			value_incremented_properly:
				value = old value + x
		end

	decrement_by(x: INTEGER)
		-- Decrement counter value by x unless it causes it to go below the minimum value.
		require
			value_pve:
				x > 0
			not_below_min:
			 	value + x >= 0
		do
			value := value - x
		ensure
			value_decremented_properly:
				value = old value - x
		end

invariant
	counter_in_range:
		value >= 0 and value <= 10


end
