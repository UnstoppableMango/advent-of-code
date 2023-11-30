module Main where

import Data.Char (digitToInt)
import Data.Map (mapMaybe)
import Text.Printf (printf)
import Data.List (transpose)

type Input = ([Int], [Board])

data Tile = Marked | Unmarked Int
  deriving (Eq, Show)

type Board = [[Tile]]

testBoard :: Board
testBoard = map (map Unmarked)
  [ [1, 2, 3]
  , [4, 5, 6]
  , [7, 8, 9] ]

splitOn :: Char -> String -> [String]
splitOn c s = case dropWhile (== c) s of
  "" -> []
  s' -> w : splitOn c s''
    where
      (w, s'') = break (== c) s'

toTile :: String -> Tile
toTile = Unmarked . read

mark :: Int -> Board -> Board
mark roll = map (map go)
  where go x | x == Unmarked roll = Marked
             | otherwise = x

bingo :: Board -> Bool
bingo b = rows b || cols b
  where rows = any (all (Marked ==))
        cols = rows . transpose

score :: Board -> Int
score = sum . map tileToInt . concat
  where tileToInt (Unmarked x) = x
        tileToInt _ = 0

part1 :: Input -> Int
part1 (rolls, boards) = roll * score board
  where ([roll], [board]) = calc rolls boards
        calc (r:rs) b
          | any bingo marked = ([r], filter bingo marked)
          | otherwise = calc rs marked
          where marked = map (mark r) b

part2 :: Input -> Int
part2 (rolls, boards) = roll * score board
  where ([roll], [board]) = calc rolls boards
        calc (r:rs) b
          | all bingo marked = ([r], map (mark r) $ filter (not . bingo) b)
          | otherwise = calc rs marked
          where marked = map (mark r) b

toBoards :: [String] -> [Board]
toBoards [] = []
toBoards x 
  | rest == [""] = [board]
  | otherwise = board : toBoards rest
  where clean = dropWhile (== "") x
        board = map (map toTile . words) $ takeWhile (/= "") clean
        rest = dropWhile (/= "") clean

prepare :: [String] -> Input
prepare x = (toRolls $ head x, toBoards $ tail x)
  where
    toRolls csv = map read $ splitOn ',' csv

main :: IO ()
main = do
  input <- lines <$> readFile "./input.txt"
  printf "Part1: %d\n" (part1 $ prepare input)
  printf "Part2: %d\n" (part2 $ prepare input)
