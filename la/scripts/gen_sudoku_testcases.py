def reformat_sudoku(input_string):
    # Parse the input string to create a 2D list of integers
    rows = input_string.strip().splitlines()
    grid = [list(map(int, row.split())) for row in rows]
    
    # Initialize lists for each number (1 to 4)
    reformatted = [[] for _ in range(4)]
    
    # Populate the lists based on the grid's values
    for row in range(len(grid)):
        for col in range(len(grid[row])):
            value = grid[row][col]
            # Append the row/column position for the specific number (value)
            reformatted[value - 1].append(f"{row + 1}/{col + 1}")
    
    return reformatted

# Example input as a string
sudoku_input = """
1	2	3	4
3	4	1	2
4	3	2	1
2	1	4	3
"""

def print_without_quotes(lists):
    st = ""
    st += "["
    for index, lst in enumerate(lists):
        st += "["
        st += ", ".join(lst)
        st += "]"
        if index != len(lists) - 1:
            st += ", "
    st += "]"
    return st

# Format and print the result
formatted_output = reformat_sudoku(sudoku_input)
st = print_without_quotes(formatted_output)

# Get last used index from file: testcaseindex
with open("testcaseindex", "r") as file:
    testcase_index = int(file.read())

final_str1 = f"""
test(sudoku_true_on_valid_solution{testcase_index + 1}, [true]) :-
  fullPlacement({st})."""


def replace_one_with_result_var(lists, target_index):
    st = ""
    answer_str = ""
    st += "["
    for index, lst in enumerate(lists):
        if index == target_index:
            st += "Result"
            if target_index != len(lists) - 1:
                st += ", "
                
            answer_str = ", ".join(lst)
            
            continue
        st += "["
        st += ", ".join(lst)
        st += "]"
        if index != len(lists) - 1:
            st += ", "
    st += "]"
    return st, answer_str

def replace_one_sublist_item_with_result_var(lists, sublist_index, sublist_item_index):
    st = ""
    answer_str = ""
    st += "["
    for index, lst in enumerate(lists):
        if index == sublist_index:
            st += "["
            st += ", ".join(lst[:sublist_item_index])

            if sublist_item_index != 0:
                st += ", "
            st += "Result"
            if sublist_item_index != len(lst) - 1:
              st += ", "
            st += ", ".join(lst[sublist_item_index+1:])
            st += "]"
            answer_str = lst[sublist_item_index]

            if index != len(lists) - 1:
                st += ", "
            continue
        st += "["
        st += ", ".join(lst)
        st += "]"
        if index != len(lists) - 1:
            st += ", "
    st += "]"
    return st, answer_str

# missing_first = formatted_output[1:]
# answer = formatted_output[0]
# answer_str = "[" + ", ".join(answer) + "]"
# st_missing_first = print_without_quotes(missing_first)
# final_str2 = f"""

list_titles = ["ones", "twos", "threes", "fours"]

print(f"/* ------------------------------- Solution {testcase_index + 1} ------------------------------- */")

print(final_str1)
for i in range(4):
    replaced_str, answer_str = replace_one_with_result_var(formatted_output, i)
    final_str2 = f"""
test(sudoku_correctly_places_{list_titles[i]}_in_solution{testcase_index+1}, [true(subset([{answer_str}], Result))]) :-
  fullPlacement({replaced_str})."""

    print(final_str2)

import random
for i in range(4):
    # get random outer list index
    index = random.randint(0, 3)
    # get random inner list index
    inner_index = random.randint(0, len(formatted_output[index])-1)
    replaced_str, answer_str = replace_one_sublist_item_with_result_var(formatted_output, index, inner_index)

    final_str3 = f"""
test(sudoku_correctly_places_single_item_in_solution{testcase_index+1}, [true(Result == {answer_str})]) :-
  fullPlacement({replaced_str})."""

    print(final_str3)


print()

# Update the testcaseindex file
with open("testcaseindex", "w") as file:
    file.write(str(testcase_index + 1))
