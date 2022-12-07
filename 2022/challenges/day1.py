def max_cals(lines):
    '''
    Calculates the elf with the most calories.
    '''
    max = 0  # Storing max cal for each elf
    cur_elf = 0  # Storing cal for current elf
    # Iterating through the lines
    for line in lines:
        if line == "\n":
            # Update max value if necessary
            if cur_elf > max:
                max = cur_elf
            # Reset current cal counter
            cur_elf = 0
        else:
            cur_cal = int(line)
            cur_elf = cur_elf + cur_cal
    return max


def sum_list(l):
    '''
    Calculates the sum of all elements in a list.
    '''
    total = 0
    for elt in l:
        total = total + elt
    return total


def top_three(lines):
    '''
    Calculates the sum of the top three caloric elves.
    '''
    max_calories = [0, 0, 0]  # Storing top three cals
    cur_elf = 0
    # Iterating through the lines
    for line in lines:
        if line == "\n":
            if cur_elf >= max_calories[0]:
                max_calories[0] = cur_elf
                # Sorting the list because it's only 3 elements
                # Guarantees smallest element is at front
                max_calories.sort()
            cur_elf = 0
        else:
            cur_cal = int(line)
            cur_elf = cur_elf + cur_cal
    return sum_list(max_calories)


def main():
    try:
        f = open("../input/day1.txt", mode='r', encoding='utf-8')
        lines = f.readlines()
        print("ANS 1 : ", max_cals(lines))
        print("ANS 2 : ", top_three(lines))
        f.close()
    except (FileNotFoundError):
        print("Can't open file")


main()
