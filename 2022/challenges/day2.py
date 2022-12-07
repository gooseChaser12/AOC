def rps_round(p1, p2):
    '''
    Calculating score for player 1
    '''
    # You choose rock
    if p1 == 'X':
        # They choose rock
        if p2 == 'A':
            return 1 + 3
        # They choose paper
        elif p2 == 'B':
            return 1
        # They choose scissor
        return 1 + 6
    # You choose paper
    elif p1 == 'Y':
        # They choose rock
        if p2 == 'A':
            return 2 + 6
        # They choose paper
        elif p2 == 'B':
            return 2 + 3
        # They choose scissor
        return 2
    # You choose scissor
    elif p1 == 'Z':
        # They choose rock
        if p2 == 'A':
            return 3
        # They choose paper
        elif p2 == 'B':
            return 3 + 6
        # They choose scissor
    return 3 + 3

def rps_score(lines):
    score = 0
    for line in lines:
        guide = line.split()
        p2 = guide[0]
        p1 = guide[1]
        score = score + rps_round(p1, p2)
    return score


def rps_round_end(p1, p2):
    # If they choose rock
    if p2 == 'A':
        # Lose with a scissor
        if p1 == 'X':
            return rps_round('Z', p2)
        # Draw with a rock
        if p1 == 'Y':
            return rps_round('X', p2)
        # Win with a paper
        return rps_round('Y', p2)
    # If they choose paper
    elif p2 == 'B':
        # Lose with a rock
        if p1 == 'X':
            return rps_round('X', p2)
        # Draw with a paper
        if p1 == 'Y':
            return rps_round('Y', p2)
        # Win with a scissor
        return rps_round('Z', p2)
    # If they choose scissor
    # Lose with a paper
    if p1 == 'X':
        return rps_round('Y', p2)
    # Draw with a scissor
    if p1 == 'Y':
        return rps_round('Z', p2)
    # Win with a rock
    return rps_round('X', p2)


def rps_end_score(lines):
    score = 0
    for line in lines:
        guide = line.split()
        p1 = guide[1]
        p2 = guide[0]
        score = score + rps_round_end(p1, p2)
    return score


def main():
    try:
        f = open("../input/day2.txt", mode='r', encoding='utf-8')
        lines = f.readlines()
        print("ANS 1 : ", rps_score(lines))
        print("ANS 2 : ", rps_end_score(lines))
        f.close()
    except (FileNotFoundError):
        print("Can't open file")


main()

# Damn you python and you no switch statements
