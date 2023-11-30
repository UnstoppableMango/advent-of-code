module Main where

import Text.Printf (printf)

data Action = Forward Int | Aim Int

toHeading :: (String, Int) -> (Int, Int)
toHeading ("forward", x) = (x, 0)
toHeading ("down", x) = (0, x)
toHeading ("up", x) = (0, -x)

toAction :: (String, Int) -> Action
toAction ("forward", x) = Forward x
toAction ("down", x) = Aim x
toAction ("up", x) = Aim (-x)

toHeadingWithAim :: (Int, Int, Int) -> Action -> (Int, Int, Int)
toHeadingWithAim (x, y, aim) (Forward amm) = (x + amm, y + (amm * aim), aim)
toHeadingWithAim (x, y, aim) (Aim amm) = (x, y, aim + amm)

add :: (Int, Int) -> (Int, Int) -> (Int, Int)
add (x, y) (u, v) = (x + u, y + v)

pairs :: [String] -> (String, Int)
pairs (x : y : _) = (x, read y)

part1 :: [String] -> Int
part1 input = uncurry (*) $ foldl add (0, 0) $ map (toHeading . pairs . words) input

part2 :: [String] -> Int
part2 input = (\(x, y, _) -> x * y) $ foldl toHeadingWithAim (0, 0, 0) $ map (toAction . pairs . words) input

main :: IO ()
main = do
  input <- lines <$> readFile "./input.txt"
  printf "Part1 %d\n" (part1 input)
  printf "Part2 %d\n" (part2 input)
