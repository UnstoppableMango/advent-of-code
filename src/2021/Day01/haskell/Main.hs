module Main where

import Text.Printf (printf)

getInput :: String -> IO [Int]
getInput f = map read . lines <$> readFile f

increases :: Int -> Int -> Int
increases x y
  | x < y = 1
  | otherwise = 0

tupleIncreases :: (Int, Int) -> Int
tupleIncreases (x, y) = increases x y

pairs :: [a] -> [(a, a)]
pairs [] = []
pairs [x, y] = [(x, y)]
pairs (x : y : xs) = (x, y) : pairs (y : xs)

groups :: [Int] -> [Int]
groups [] = []
groups [x, y, z] = [x + y + z]
groups (x : y : z : xs) = (x + y + z) : groups (y : z : xs)

part1 :: [Int] -> Int
part1 input = sum $ map tupleIncreases $ pairs input

part2 :: [Int] -> Int
part2 input = sum $ map (uncurry increases) $ pairs $ groups input

main :: IO ()
main = do
  input <- getInput "../input.txt"
  printf "Part1 %d\n" (part1 input)
  printf "Part2 %d\n" (part2 input)
