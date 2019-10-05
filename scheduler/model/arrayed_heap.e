note
	description: "A maximum heap implemented using an array."
	author: "Jackie and Umar Abdulselam"
	date: "$Date$"
	revision: "$Revision$"

class
	ARRAYED_HEAP

create
	-- Select command `make` to be the only constructor of the current class.
	make

feature -- Representation of an array-based heap

-- Do not modify any of these attributes.
-- Your implementation of heap features must make use of these attributes when appropriate.

	count: INTEGER
		-- number of keys stored in the heap
	max_capacity: INTEGER
		-- maximum number of keys that can be stored in the heap
	array: ARRAY[INTEGER]
		-- array representation of the heap, array.count = size of the array

feature -- Constructor

	make (a: ARRAY[INTEGER]; n: INTEGER)
			-- Create a heap from an unsorted array `a`, with maximum capacity `n`.
			-- See all invariants which must be established by this constructor.
		require
			enough_capacity:
				-- TODO: What's the relation between size of `a` and `n`?
				-- Number of values in 'a' must be less than or equal
				-- to the max_capacity, n
				a.count <= n

			all_positive:
				-- TODO: All keys to be added to the heap should be strictly positive.
				across
					a.lower |..| a.upper is cursor
				all
					a[cursor] > 0
				end

			no_duplicates:
				-- TODO: No duplicates of keys are to be added to the heap.
--				across
--					a.lower |..| a.upper is cursor
--				all
--					a.occurrences(a[cursor]) = 1
--				end
				across
					a.lower |..| a.upper is l_cur
				all
					across
						a.lower |..| a.upper is k_cur
					all
						l_cur /= k_cur implies a[l_cur] /= a[k_cur]
					end
				end

		local
			i: INTEGER

		do
			-- TODO: Initialize `array` such that it represents a binary tree
			-- satisfying the maximum heap property.
			-- Be sure to initialize `max_capacity` and `count` properly.
			-- Hint: Make use of the `heapify` command.
			-- Watch out for infinite loops!

			-- create an array of size n from index 1
			-- with default value 0 in every index
			create array.make_filled (0, 1, n)

			-- populate `array` with values from `a` until
			-- indexes of `a` are exhausted, populate remaining indexes
			-- in `array` with default value `0`
			from
				i := 1
			until
				i > a.count
			loop
				array[i] := a[i]
				i := i + 1
			end

			-- set the heap's `count` and `max_capacity`
			count := a.count
			max_capacity := n

			-- Build the heap up into a max-heap
			restore_heap(false)

		ensure
			max_capacity_set:
				-- Completed for you. Do not modify.
				array.count = max_capacity and max_capacity = n
			heap_size_set:
				-- Completed for you. Do not modify.
				count = a.count
		end

feature -- Commands

	heapify (i: INTEGER)
			-- Starting from the node stored at index `i`,
			-- fix the heap property downwards, until an external node if necessary.
		require
			valid_index:
				-- Completed for you. Do not modify.
				is_valid_index (i)

		local
			largest, left, right: INTEGER

		do
			-- TODO: Complete the implementation.
			-- Watch out for infinite loops!
			largest := i -- set largest
			left := (2*i)
			right := (2*i + 1)

			-- if left index is within bounds and its
			-- value is larger than parent the node
			if is_valid_index(left) and left_child_of(i) > array[largest] then
				largest := left
			end

			-- if right index is within bounds and
			-- its value is larger than the current largest node
			if is_valid_index(right) and right_child_of(i) > array[largest] then
				largest := right
			end

			if largest /= i then
				-- Swap the value at index `i` with the
				-- value at index `largest`
				swap(i, largest)
				-- correct the heap below index `largest`
				-- if it has been broken
				heapify(largest)
			end

		ensure
			-- Heap property is maintained, see invariant `heap_property`.

			same_set_of_keys:
				-- TODO: old and new versions of `array` store the same set of integer keys.
				-- Hint: You may want to make use of the `is_permutation_of` query.
				is_permutation_of (array, old array.twin)
		end

	insert (new_key: INTEGER)
			-- Add `new_key` into the heap, if it does not exist.
		require
			non_existing_key:
				-- Completed for you. Do not modify.
				not key_exists (new_key)

		do
			-- TODO: Complete the implementation.
			-- Watch out for infinite loops!
			array[count + 1] := new_key
			count := count + 1
			up_heap

		ensure
			-- Heap property is maintained, see invariant `heap_property`.

			size_incremented:
				-- TODO: Constraint on `count`
				count = old count + 1

			same_set_of_keys_except_the_new_key:
				-- TODO: Except `new_key` being just added,
				-- all other keys in the new `array` already exist in the old `array`.
				-- has_same_items_except (old array, array, new_key, True)
				across 1 |..| count is i
				  all
				  	array[i] /= new_key implies (old array.twin).has (array[i]) or
				  	array[i] = new_key implies True
				end
		end

	remove_maximum
			-- Remove the maximum key from heap, if it is not empty.
		require
			non_empty_heap:
				-- Completed for you. Do not modify.
				not is_empty

		do
			-- TODO: Complete the implementation.
			-- Hint: Make use of the `heapify` command.
			-- Watch out for infinite loops!
			array[1] := array[count]
			array[count] := 0
			count := count - 1
			if not is_empty then
				restore_heap(true)
			end

		ensure
			-- Heap property is maintained, see invariant `heap_property`.

			size_decremented:
				-- TODO: Constraint on `count`
				count = old count - 1

			same_set_of_keys_except_the_removed_key:
				-- TODO: Except the key being just removed,
				-- all other keys in the old `array` still exist in the new `array`.
				-- has_same_items_except (old array, array, old array[1], False)
				across 1 |..| count is i
				  all
					array.has(old (array[1])) implies False and
					array.has ((old array.twin)[i])
				end
		end

feature -- Auxiliary queries for writing contracts

	is_permutation_of (a1, a2: like array): BOOLEAN
			-- Do arrays `a1` and `a2` store the same set of items,
			-- though they may be arranged in different orders?
			-- e.g., <<1, 2, 3, 4>> is a permutation of <<2, 1, 4, 3>>
			-- You can assume that both `a1` and `a2` are heap representation,
			-- and they thus contain no duplicates from indices 1 to `count`, whereas
			-- there are all zeros from indices `count` + 1 to `max_capacity`.

			-- No precondition or postcondition is needed.
		local
			i,j, cntr: INTEGER
		do
			-- TODO: Complete the implementation.
			cntr := 0
			Result := True
			-- different sizes means they cannnot be
			-- permutations of each other

			if a1.count = a2.count then
				from
					i := a1.lower
				until
					i > a1.upper
				loop
					-- if a1 and a2 have the same
					-- number of elements and a1 has
					-- every element in a2, then
					-- they must be permutations of
					-- each other
					Result := Result and a1.has(a2[i])
					i := i + 1
				end
			else
				Result := False
			end
		end

feature -- Queries related to heaps

	is_empty: BOOLEAN
			-- Does the current heap store no integer keys?

			-- No precondition or postcondition is needed.
		do
			-- TODO: Complete the implementation.
			Result := count = 0
		end

	key_exists (a_key: INTEGER): BOOLEAN
			-- Does `a_key` exist in the current heap?

			-- No precondition is needed.
		do
			-- TODO: Complete the implementation.
			Result := array.has(a_key)

		ensure
			correct_result:
				-- TODO: Constraint on the return value `Result`
				-- if Result = True then some value in `array`
				-- is equal to `a_key`
				Result implies
					across
						1 |..| count is i
					some
						array[i] = a_key
					end

				and

				-- if Result = False then all values in `array`
				-- are not equal to `a_key`
				not Result implies
					across
						1 |..| count is i
					all
						array[i] /= a_key
					end
		end

feature -- Queries related to binary trees

	is_valid_index (i: INTEGER): BOOLEAN
			-- Does index `i` denote an existing node in the current heap?

			-- No precondition or postcondition is needed.
		do
			-- TODO: Complete the implementation.
			Result := i > 0 and i <= count
		end

	has_left_child (i: INTEGER): BOOLEAN
			-- Does index `i` store a node that has a left child node?

			-- No precondition or postcondition is needed.
		do
			-- TODO: Complete the implementation.
			Result := is_valid_index(2*i)

		end

	has_right_child (i: INTEGER): BOOLEAN
			-- Does index `i` store a node that has a right child node?

			-- No precondition or postcondition is needed.
		do
			-- TODO: Complete the implementation.
			Result := is_valid_index((2*i)+1)
		end

	has_parent (i: INTEGER): BOOLEAN
			-- Does index `i` store a node that has a parent node?

			-- No precondition or postcondition is needed.
		do
			-- TODO: Complete the implementation.
			Result := is_valid_index((i//2))
		end

	left_child_of (i: INTEGER): INTEGER
			-- Left child node of what is stored at index `i`
			-- No postcondition is needed.
		require
			-- Precondition completed for you. Do not modify.
			valid_index:
				is_valid_index (i)
			left_child_exists:
				has_left_child (i)
		do
			-- TODO: Complete the implementation.
			Result := array[2*i]
		end

	right_child_of (i: INTEGER): INTEGER
			-- Right child node of what is stored at index `i`
			-- No postcondition is needed.
		require
			-- Precondition completed for you. Do not modify.
			valid_index:
				is_valid_index (i)
			right_child_exists:
				has_right_child (i)
		do
			-- TODO: Complete the implementation.
			Result := array[(2*i)+1]
		end

	parent_of (i: INTEGER): INTEGER
			-- Parent node of what is stored at index `i`
			-- No postcondition is needed.
		require
			-- Precondition completed for you. Do not modify.
			valid_index:
				is_valid_index (i)
			not_root:
				i /= 1
		do
			-- TODO: Complete the implementation.
			Result := array[i//2]
		end

	maximum: INTEGER
			-- Maximum of the current heap.
		require
			-- Precondition completed for you. Do not modify.
			non_empty:
				not is_empty
		do
			-- TODO: Complete the implementation.
			Result := array[1]
		ensure
			correct_result:
				-- TODO: The return value `Result` is the maximum integer key.
				across
					2 |..| count is i
				all
					array[1] > array[i]
				end
		end

	is_a_max_heap (i: INTEGER): BOOLEAN
			-- Does the subtree rooted at node stored at index `i` satisfy the maximum heap property?
		require
			-- Precondition completed for you. Do not modify.
			valid_index:
				is_valid_index(i)

		local
			left, right: INTEGER

		do
			-- TODO: Complete the implementation.

			-- indexes of potential child nodes
			left := 2*i
			right := 2*i + 1
			-- node at i is an external node
			if left > count then
				Result := True
			-- node at i is an internal node with
			-- one child (left child)
			elseif has_left_child(i) and right > count then
				Result := array[i] > left_child_of(i)
			-- node at i is an internal node
			-- with two child nodes
			else
				-- check that parent node is larger than
				-- both its children and then recursively
				-- check the max_heap property for the
				-- child subtrees in a pre-order traversal
				Result := array[i] > left_child_of(i)
						  and array[i] > right_child_of(i)
						  and is_a_max_heap(2*i)
						  and is_a_max_heap((2*i)+1)
			end

		ensure
			case_of_no_children:
				-- TODO: When index `i` denotes an external node, what happens to `Result`?
				not has_left_child (i) and not has_right_child (i) implies True
			case_of_two_children:
				-- TODO: When index `i` denotes an internal node with both children, what happens to `Result`?
				has_left_child (i) and has_right_child (i)
					implies array[i] > left_child_of(i) and array[i] > right_child_of(i)
			case_of_one_child:
				-- TODO: When index `i` denotes an internal node with only one child, what happens to `Result`?
				has_left_child (i) and not has_right_child (i)
					implies array[i] > left_child_of(i)
		end

feature -- Additional Helper Methods

	restore_heap(flag: BOOLEAN)
		-- Restore the heap property of every value at valid index i
		-- being larger than the value of its child nodes

		-- set `flag` (true) if the intended use is to restore after
		-- invoking `remove_maximum`; `flag` is unset (false) if
		-- intended use is for constructing the heap from scratch
		-- (i.e. BuildHeap)

		local
			i: INTEGER

		do
			-- CASE: remove_maximum
			if flag then
				heapify(1)

			-- CASE: build_heap	
			else
				from
					i := count//2
				until
					i < 1
				loop
					heapify(i)
					i := i - 1
				end
			end
		end

	up_heap
		-- Relocate the most recently inserted value in the heap
		-- to its appropriate position

		local
			i: INTEGER

		do
			-- from the index that was just inserted at
			from
				i := count
			until
				i = 1
			loop
				-- swap the values at the nodes if the
				-- child value is greater than its parent
				if array[i] > parent_of(i) then
		  			swap(i, (i//2))
					i := i//2
				else
					i := 1
				end
			end
		end

	swap(i: INTEGER; j: INTEGER)
		-- feature used to swap the value
		-- stored at indices i and j in
		-- the heap
		local
			temp: INTEGER
		do
			temp := array[i]
			array[i] := array[j]
			array[j] := temp
		end

invariant
	-- All invariants are completed for you. Do not modify this section.

	implementation_indices:
		array.lower = 1 and array.upper = max_capacity

	no_heap_overflow:
		count <= max_capacity

	no_heap_underflow:
		count >= 0

	-- The tree is filled up from indices 1 to `count` in the array.
	-- Indices `count` + 1 to `n` should store zeros.
	-- all stored keys are strictly positive; all unused slots store zeros
	contents_of_heap:
		across 1 |..| count is i all array[i] > 0 end
		and
		across (count + 1) |..| max_capacity is i all array[i] = 0 end

	-- The maximum heap property.
	 heap_property:
		is_a_max_heap (1)
end
