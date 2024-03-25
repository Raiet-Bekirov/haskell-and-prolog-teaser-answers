import Data.List 
import Data.Char (digitToInt)
import Text.Printf (printf)

-- Number of segments lit for each digit
segments :: Int -> Int
segments n = case n of
    0 -> 6
    1 -> 2
    2 -> 5
    3 -> 5
    4 -> 4
    5 -> 5
    6 -> 6
    7 -> 3
    8 -> 7
    9 -> 6
    _ -> 0

isPrime :: Int -> Bool
isPrime n = n > 1 && all (\x -> n `mod` x /= 0) [2 .. n-1]
    
-- Generate all valid time combinations for the third display
timeCombinations :: [(Int, Int, Int, Int)]
timeCombinations = [(hr, mn, dy, mt) |
                    hr <- [0..23], 
                    mn <- [0..59], 
                    dy <- [1..31], 
                    mt <- [1..12], 
                    validTime hr mn dy mt]

-- Check for valid time based on constraints given
validTime :: Int -> Int -> Int -> Int -> Bool
validTime hr mn dy mt 
    | mt == 2 = dy <= 28
    | mt `elem` [4, 6, 9, 11] = dy <= 30
    | otherwise = dy <= 31

-- Calculate the total segments lit for a given time
totalSegments :: (Int, Int, Int, Int) -> Int
totalSegments (hr, mn, _, _) = sum $ map segments [d1, d2, d3, d4]
    where [d1, d2] = digits hr
          [d3, d4] = digits mn
          digits x = [x `div` 10, x `mod` 10]


generator1 :: [(Int, Int, Int, Int)]
generator1 = filter condition timeCombinations
    where condition time = let segs = totalSegments time in
                           isPrime segs


x_generator1 :: Int
x_generator1 =
  length [ t | t <- ts, t `elem` g ]
  where
    g = generator1 
    ts =
      [ (2, 15, 14, 11)
      , (4, 31, 27, 9)
      , (6, 47, 10, 8)
      , (9, 3, 23, 6)
      , (11, 19, 6, 5)
      , (13, 35, 19, 3)
      , (15, 51, 2, 2)
      , (18, 6, 16, 12)
      , (20, 22, 29, 10)
      , (22, 38, 11, 9)
      ]

-- Checks if all characters in a string are different
allUnique :: String -> Bool
allUnique s = length s == length (nub s)

-- Converts a tuple to a concatenated string of digits
tupleToString :: (Int, Int, Int, Int) -> String
tupleToString (hr, mn, dy, mt) =
  concatMap (printf "%02d") [hr, mn, dy, mt]

-- Calculates the total number of lit segments for the concatenated string of digits
totalSegments1 :: String -> Int
totalSegments1 = sum . map (segments . digitToInt)


-- Helper function to get the next day's date
nextDay :: (Int, Int, Int, Int) -> (Int, Int, Int, Int)
nextDay (hr, mn, dy, mt) =
  let (newDy, newMt) =
        if mt == 2 && dy == 28 then (1, 3)
        else if dy == 30 && mt `elem` [4, 6, 9, 11] then (1, mt + 1)
        else if dy == 31 then (1, if mt == 12 then 1 else mt + 1)
        else (dy + 1, mt)
  in (hr, mn, newDy, newMt)

addOneMinute :: (Int, Int, Int, Int) -> (Int, Int, Int, Int)
addOneMinute (hr, mn, dy, mt) =
  if mn == 59
  then if hr == 23
       then nextDay (0, 0, dy, mt)
       else (hr + 1, 0, dy, mt)
  else (hr, mn + 1, dy, mt)

 
tester1 :: (Int, Int, Int, Int) -> Bool
tester1 tuple = 
  let str = tupleToString tuple
      nextTuple = nextDay tuple
      nextStr = tupleToString nextTuple
      oneMinuteLaterTuple = addOneMinute nextTuple
      oneMinuteLaterStr = tupleToString oneMinuteLaterTuple
      segmentsNow = totalSegments1 str
      segmentsNext = totalSegments1 nextStr
      segmentsOneMinuteLater = totalSegments1 oneMinuteLaterStr
      averageSegments = (segmentsNow + segmentsNext) `div` 2
  in allUnique str && isPrime segmentsNow &&
     allUnique nextStr && isPrime segmentsNext &&
     segmentsOneMinuteLater == averageSegments

x_tester1 :: Int
x_tester1 =
  length [ t | t <- ts, tester1 t ]
  where
    ts =
      [ (6, 59, 17, 24)
      , (6, 59, 17, 34)
      , (6, 59, 27, 14)
      , (6, 59, 27, 41)
      , (8, 59, 12, 46)
      , (16, 59, 7, 24)
      , (16, 59, 7, 42)
      , (16, 59, 7, 43)
      , (16, 59, 27,40)
      , (18, 59, 2, 46)
      ]

main :: IO ()
main = print ( filter tester1 generator1 ) --( filter tester1 generator1 )x_tester1 x_generator1