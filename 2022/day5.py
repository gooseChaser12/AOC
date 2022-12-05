# Way to tokenize input because split and slice wasn't working the way
# I wanted them to.
def tokenize_input(line): 
    lst = []
    lb = 0
    while (lb + 3) < len(line):
        token = line[lb:(lb+3)]
        lst.append(token)
        lb = lb + 4
    return lst


def display_stacks(stacks):
    for st in stacks:
        print(st)


# Iteratively moving the crates
def crate_mover_9000(qty: int, src: int, dest: int, stacks):
    if qty < len(stacks[src]):
        for i in range(qty):
            tmp = stacks[src].pop(0)
            stacks[dest].insert(0, tmp)
        return stacks
    else:
        print("QTY TOO BIG 9k")


# Recursively moving the crates
def crate_mover_9001(qty, src, dest, stacks):
    if qty == 1:
        tmp = stacks[src].pop(0)
        stacks[dest].insert(0, tmp)
        return stacks
    if qty < len(stacks[src]):
        tmp = stacks[src].pop(0)
        s2 = crate_mover_9001((qty - 1), src, dest, stacks)
        s2[dest].insert(0, tmp)
        return s2
    else:
        print("QTY TOO BIG 9k1")


def handler(lines):
    stk = []
    nk1s = []
    num_empty = 0
    for line in lines:
        ls = line.split()

        # Using empty lists to increment sections in input
        if ls == []:
            num_empty = num_empty + 1
        else:

            # Gathering initial stacks
            if num_empty == 1:
                tokens = tokenize_input(line)
                # Parse input into stacks
                for i in range(len(tokens)):
                    if i >= len(stk):
                        stk.append([])
                        nk1s.append([])
                    if tokens[i] != "   ":  # account for spaces, but don't include 
                        stk[i].append(tokens[i])
                        nk1s[i].append(tokens[i])

            # Handling moves from src to destination
            elif num_empty == 2:
                qty = int(ls[1])
                src = int(ls[3])-1
                dest = int(ls[5])-1
                stk = crate_mover_9000(qty, src, dest, stk)
                nk1s = crate_mover_9001(qty, src, dest, nk1s)
                
    # Collect the top of the stacks
    a1 = []
    a2 = []
    for st in stk:
        a1.append(st[0])
    for nk in nk1s:
        a2.append(nk[0])
    return (a1, a2)


def main():
    try:
        f = open("day5.txt", mode='r', encoding='utf-8')
        lines = f.readlines()
        ans = handler(lines)
        print("ANS 1 : ", ans[0])
        print("ANS 2 : ", ans[1])
        f.close()
    except (FileNotFoundError):
        print("Can't open file")


main()
