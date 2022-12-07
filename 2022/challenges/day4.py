'''
Some assignments fully contanin another.
    2-9 fully contains 3-7
'''


def exists_subset(ass1, ass2):
    lb1 = int(ass1[0])
    rb1 = int(ass1[1])
    lb2 = int(ass2[0])
    rb2 = int(ass2[1])
    # Check if ass2 fully contained in ass1
    if lb1 <= lb2 and rb2 <= rb1:
        return True
    # Check if ass1 fully contained in ass2
    elif lb2 <= lb1 and rb1 <= rb2:
        return True
    return False 


def exists_overlap(ass1, ass2):
    lb1 = int(ass1[0])
    rb1 = int(ass1[1])
    lb2 = int(ass2[0])
    rb2 = int(ass2[1])
    # If overlap in ass1 lb
    if lb1 <= lb2 and lb2 <= rb1:
        return True
    # If overlap in ass2 lb
    elif lb2 <= lb1 and lb1 <= rb2:
        return True
    # If overlap in ass1 rb
    elif rb2 <= rb1 and lb1 <= rb2:
        return True
    # If overlap in ass2 rb
    elif rb1 <= rb2 and lb2 <= rb1:
        return True
    return False


def get_answers(lines):
    fc = 0
    ovlp = 0
    for line in lines:
        line = line.strip("\n")
        pair = line.split(",")
        ass1 = pair[0].split("-")
        ass2 = pair[1].split("-")
        if exists_subset(ass1, ass2):
            fc = fc + 1
        if exists_overlap(ass1, ass2):
            ovlp = ovlp + 1
    return (fc, ovlp)


def main():
    try:
        f = open("../input/day4.txt", mode='r', encoding='utf-8')
        lines = f.readlines()
        anst = get_answers(lines)
        print("ANS 1 : ", anst[0])
        print("ANS 2 : ", anst[1])
        f.close()
    except (FileNotFoundError):
        print("Can't open file")


main()
