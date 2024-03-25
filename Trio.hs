import Data.List 

-- Define the main function to generate the list of tuples
generator2 :: [(String, String, String, String, String)]
generator2 = 
  [ (n1, n2, n3, n4, n5)
  | n1 <- filter special threeDigitNumbers    -- Filter three-digit numbers that don't contain '0' and have unique digits
  , let twoDigitNumbers = [ take 2 perm | perm <- permutations n1 ]  -- Generate two-digit permutations of n1
  , n2 <- twoDigitNumbers, head n1 /= head n2  -- Ensure first digit of n1 isn't the same as that of n2
  , n3 <- permutations n1                     -- n3 is any permutation of n1
  , n4 <- twoDigitNumbers, n4 /= n2           -- n4 is a two-digit permutation, but different from n2
  , n5 <- permutations n1, n5 /= n1, n5 /= n3 -- n5 is a permutation of n1 but not the same as n1 or n3
  ]

-- List of all three-digit numbers as strings
threeDigitNumbers :: [String]
threeDigitNumbers = map show [123..987]

-- Check if a string is 'special' (doesn't have '0' and has unique digits)
special :: String -> Bool
special s = not ('0' `elem` s) && nodups s

-- Check if a list has duplicate elements
nodups :: Eq a => [a] -> Bool
nodups s = s == nub s


x_generator2 :: Int
x_generator2 =
    length [t | t <- ts, t `elem` g]
    where
        g = generator2
        ts = 
            [ ("123", "21", "123", "12", "123")
            , ("162", "26", "261", "12", "621")
            , ("219", "19", "912", "21", "291")
            , ("329", "92", "932", "32", "239")
            , ("439", "94", "394", "43", "394")
            , ("549", "95", "945", "95", "945")
            , ("568", "68", "586", "56", "586")
            , ("769", "67", "679", "97", "796")
            , ("879", "79", "897", "98", "789")
            , ("987", "79", "789", "79", "789")
            ]

tester2 :: (String, String, String, String, String) -> Bool
tester2 (s1, s2, s3, s4, s5) =
    n1 - n2 == n3
    && n3 - n4 == n5
    && n1 + n3 + n5 < 2000
  where
    n1 = read s1 :: Int
    n2 = read s2 :: Int
    n3 = read s3 :: Int
    n4 = read s4 :: Int
    n5 = read s5 :: Int

x_tester2 :: Int
x_tester2 = length [t | t <- ts, tester2 t]
    where
        ts =
            [ ("138", "01", "137", "50", "87")
            , ("143", "01", "142", "52", "90")
            , ("171", "02", "169", "79", "90")
            , ("152", "03", "149", "54", "95")
            , ("159", "04", "155", "61", "94")
            , ("161", "05", "156", "63", "93")
            , ("182", "06", "176", "80", "96")
            , ("151", "07", "144", "57", "87")
            , ("165", "08", "157", "64", "93")
            , ("174", "09", "165", "71", "94")
            ]

main :: IO ()
main = print (filter tester2 generator2) --x_tester2 x_generator2 (filter tester2 generator2)