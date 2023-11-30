import Text.Printf (printf)

type Input = [Int]

splitOn :: Char -> String -> [String]
splitOn c s = case dropWhile (== c) s of
  "" -> []
  s' -> w : splitOn c s''
    where
      (w, s'') = break (== c) s'

part1 :: Input -> Int
part1 input = do
  let temp = map (subtract 1) input
  0

part2 :: Input -> Int
part2 _ = 0

prepare :: [String] -> Input
prepare = map read . splitOn ',' . head

main :: IO ()
main = do
  input <- lines <$> readFile "./test.txt"
  printf "Part1: %d\n" (part1 $ prepare input)
  printf "Part2: %d\n" (part2 $ prepare input)
