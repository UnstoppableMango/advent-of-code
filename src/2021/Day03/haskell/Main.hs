module Main where

import Data.Char (digitToInt, intToDigit)
import Data.List (transpose, foldl')
import Data.Maybe (mapMaybe)
import GHC.Float (int2Float)
import Text.Printf (printf)

data Bit = Zero | One deriving (Eq, Show)

toBit :: Char -> Bit
toBit '0' = Zero
toBit '1' = One

bitToInt :: Bit -> Int
bitToInt Zero = 0
bitToInt One = 1

frequency :: [Bit] -> (Int, Int)
frequency = foldl count (0, 0)
  where count (a, b) Zero = (a, b + 1)
        count (a, b) One = (a + 1, b)

mostCommon :: (Int, Int) -> Bit -> Bit
mostCommon (x, y) d
  | x > y = One
  | x < y = Zero
  | otherwise = d

leastCommon :: (Int, Int) -> Bit -> Bit
leastCommon (x, y) d
  | x < y = One
  | x > y = Zero
  | otherwise = d

toDecimal :: String -> Int
toDecimal = foldl' (\acc x -> acc * 2 + digitToInt x) 0

asNumber :: [Bit] -> Int
asNumber = foldl' (\acc x -> acc * 2 + bitToInt x) 0

add :: Char -> Char -> Int
add a b = digitToInt a + digitToInt b

toMostLeastCommon :: Float -> Float -> Maybe (Char, Char)
toMostLeastCommon c l
  | c > l = Just ('1', '0')
  | c < l = Just ('0', '1')
  | c == l = Nothing

concatTuple :: [(Char, Char)] -> (String, String)
concatTuple = foldr (\(a, b) (x, y) -> (a : x, b : y)) ("", "")

getMostLeastCommon :: [String] -> (String, String)
getMostLeastCommon input =
  concatTuple $
    mapMaybe (\x -> toMostLeastCommon (int2Float x) (int2Float (length input) / 2)) $
      foldl calc (replicate (length $ head input) 0) input

calc :: [Int] -> String -> [Int]
calc acc x = zipWith (+) acc (map digitToInt x)

result :: String -> String -> Int
result x y = toDecimal x * toDecimal y

scrub :: [[Bit]] -> Bit -> [Bit]
scrub [bits] _ = bits
scrub nums tb = let freq = frequency $ head $ transpose nums
                    mc | tb == One = mostCommon freq tb
                       | tb == Zero = leastCommon freq tb
                    rest = map tail . filter ((== mc) . head) $ nums
                in mc : scrub rest tb

part1 :: [String] -> Int
part1 = uncurry result . getMostLeastCommon

part2 :: [String] -> Int
part2 input = do
  let ogr = calculate One
  let csr = calculate Zero
  ogr * csr
  where nums = map (map toBit) input
        calculate bit = asNumber $ scrub nums bit

main :: IO ()
main = do
  input <- lines <$> readFile "./input.txt"
  printf "Part1: %d\n" (part1 input)
  printf "Part2: %d\n" (part2 input)
