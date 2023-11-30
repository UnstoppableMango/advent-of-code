import Text.Printf (printf)
import Data.Char (digitToInt)
import Control.Applicative (liftA2)
import Data.Map (fromListWith, toList)

data Point = Point { x, y :: Int }
  deriving (Ord, Eq, Show)

data Line = Line { start, end :: Point }
  deriving (Show)

type Input = [Line]

frequency :: (Ord a) => [a] -> [(a, Int)]
frequency xs = toList (fromListWith (+) [(x, 1) | x <- xs])

splitOn :: Char -> String -> [String]
splitOn c s = case dropWhile (== c) s of
  "" -> []
  s' -> w : splitOn c s''
    where
      (w, s'') = break (== c) s'

xEqual :: Line -> Bool
xEqual (Line start end) = x start == x end

yEqual :: Line -> Bool
yEqual (Line start end) = y start == y end

toRange :: Point -> Point -> [Point]
toRange (Point x1 y1) (Point x2 y2) =
  [ Point x y | x <- [(min x1 x2)..(max x1 x2)],
                y <- [(min y1 y2)..(max y1 y2)],
                ((x - x1) * (y1 - y2) ) == ((y - y1) * (x1 - x2)) ]

allPoints :: [Line] -> [Point]
allPoints = concatMap (\(Line start end) -> toRange start end)

part1 :: Input -> Int
part1 input = length $ filter (>=2) $ map snd $ frequency $ allPoints hv
  where hv = filter (liftA2 (||) xEqual yEqual) input

part2 :: Input -> Int
part2 = length . filter (>=2) . map snd . frequency . allPoints

prepare :: [String] -> Input
prepare = map toLine
  where toLine i = Line {
          start = toPoint $ head $ words i,
          end = toPoint $ last $ words i
        }
        toPoint csv = Point {
          x = read $ head $ splitOn ',' csv,
          y = read $ last $ splitOn ',' csv
        }

main :: IO ()
main = do
  input <- lines <$> readFile "./input.txt"
  printf "Part1: %d\n" (part1 $ prepare input)
  printf "Part2: %d\n" (part2 $ prepare input)
