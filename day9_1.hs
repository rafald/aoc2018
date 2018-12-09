import qualified Data.Map as M
import Data.List

type ScoreMap = M.Map Int Int
type Board = [Marble]
type Position = Int
type Players = [Int]
type RemainingMarbles = [Int]
type Marble = Int

playGame :: ScoreMap -> Board -> Players -> RemainingMarbles -> ScoreMap
playGame scoreMap board (currentPlayer : nextPlayers) [] = scoreMap
playGame scoreMap board (currentPlayer : nextPlayers) (marble : marbles)
  | marble `mod` 23 == 0 = playGame (M.insertWith (+) currentPlayer (removedMarble + marble) scoreMap) newBoard nextPlayers marbles
  | otherwise = playGame scoreMap (insertNewMarble board marble) nextPlayers marbles
    where (newBoard, removedMarble) = removeMarble board

-- From the problem description: 
-- Then, each Elf takes a turn placing the lowest-numbered remaining marble into the 
-- circle between the marbles that are 1 and 2 marbles clockwise of the current marble.
-- The marble that was just placed then becomes the current marble.
-- Let's define a board as a linked list starting at the current marble, since it's circular anyway
insertNewMarble :: Board -> Marble -> Board
insertNewMarble [0,1] 2 = [2,1,0] --one edge case is not so bad
insertNewMarble b m = m : ((drop 2 b) ++ (take 2 b))

-- Again from the description: the marble 7 marbles counter-clockwise from the current marble is removed
-- from the circle and also added to the current player's score.
removeMarble :: Board -> (Board,Marble)
removeMarble b = (newBoard, removedMarble)
  where revBoard = reverse b
        tailMarbles = drop 7 revBoard
        headMarbles = take 7 revBoard
        removedMarble = last headMarbles
        newBoard = (reverse $ init headMarbles) ++ (reverse tailMarbles)

solution numPlayers numMarbles = maximum . M.elems $ playGame M.empty [0] (cycle [1..numPlayers]) [1..numMarbles]
