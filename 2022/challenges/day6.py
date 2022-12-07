# Wanted to do with recursion instead of hash table :/
def exists_duplicates(lst: list):
    leng = len(lst)
    if leng >= 1:
        tl = lst.pop(leng-1)
        if exists_duplicates(lst):
            lst.append(tl)
            return True
        else:
            # if list doesn't contain tl
            if lst.count(tl) == 0:
                lst.append(tl)
                return False
            lst.append(tl)
            return True
    return False


def find_marker(line: str, size: int):
    queue = []
    indx = 1
    for c in line:
        # Enqueing current 
        queue.insert(0, c)
        if len(queue) > size:
            # Dequeing characters
            queue.pop(size)
            # If after enque, no duplicates, then we found the packet.
            if not exists_duplicates(queue):
                return indx
        indx = indx + 1


def main():
    try:
        f = open("../input/day6.txt", mode='r', encoding='utf-8')
        line = f.readline()
        print("ANSWER 1: ", find_marker(line, 4))
        print("ANSWER 2: ", find_marker(line, 14))
        f.close()
    except (FileNotFoundError):
        print("Can't open file")


main()
