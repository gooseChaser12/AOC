import System.IO
-- I will figure this out one day...

main = do
    let list = []
    -- handle <- openFile "day6.txt" ReadMode  -- openFile outputs a IO Handle
    -- hClose handle
    contents <- readFile "../input/day6.txt"
    print contents

