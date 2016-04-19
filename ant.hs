-- Here is where you'll define both Langton's Ant, and how
-- to transition a world
-- You'll definitely want to change this
-- Robert 'Probie' Offner
-- PUT YOUR NAME HERE!
-- Feb 2016

module StudentSources.LangtonsAnt where

-- The import are here to include the content from other files.
-- You can find each file in src/Datastructures
import Datastructures.Ant
import Datastructures.Cells
import Datastructures.SquareWorld
import Datastructures.Transitions


-- #####################################################################
-- ######################## Part 0 Starts Here #########################
-- #####################################################################

-- This function is already done for you! No modification is needed.
-- We wrote this for you to give you an idea of how the
-- turnAnt and moveAnt should be used. When you run
-- ./run_langtons_ant -m part0
-- this function is called to transition the world
walkInACircle :: SquareWorld -> SquareWorld
walkInACircle squareWorld = moveAnt (turnAnt L squareWorld)

-- Students: Please implement this function.
--
-- | The 'turnAnt' function turns the ant to the given direction in the world.
--
-- The first parameter ('direction') specified the direction to which the ant
-- shall turn. The second parameter ('squareWorld') is the old world. This
-- function shall return a new 'SquareWorld' value which differs from the
-- 'squareWorld' parameter by only the 'theAnt' field. The new ant in the new
-- world shall differ from the old 'theAnt' filed by only the 'antOrientation'
-- field, which is the old value turned to the direction specified by the
-- 'direction' parameter. For example, if the old 'antOrientation' value was W
-- and the 'direction' parameter is R, the new 'antOrientation' value shall be
-- N.
--
-- Right now all this does is take the current SquareWorld and return the
-- SquareWorld unchanged. You need to take the Ant in the squareWorld and
-- change its Direction.
turnAnt :: SquareTurn -> SquareWorld -> SquareWorld
turnAnt direction squareWorld = case direction of
                                      L -> let (world,c) = newSquareWorld$(createAnt squareWorld (createTurn direction (getDirection squareWorld))) in transitionWorld c world
                                      R -> let (world,c) = newSquareWorld$(createAnt squareWorld (createTurn direction (getDirection squareWorld))) in transitionWorld c world

createAnt :: SquareWorld->Direction->Ant
createAnt world direction = Ant (getCoord world) direction (antTransition (theAnt world))

createTurn :: SquareTurn->Direction->Direction
createTurn st d = case st of
                  L -> if d == S then E else if d == E then N else if d==N then W else S
                  R -> if d == N then E else if d == W then N else if d==S then W else S


-- Students: Please implement this function.
--
-- | The 'moveAnt' function moves the ant in the given world in its current
-- direction.
--
-- The parameter ('squareWorld') is the current world. This function shall
-- return a new SquareWorld value which differs from the 'squareWorld' parameter
-- by only the 'theAnt' field. The ant in the new world shall differ from the
-- old ant by only the 'antPosition' field. The new 'antPosition' is computed by
-- moving one unit from the old 'antPosition', and the direction to move is
-- specified by the current 'antOrientation' field. For example, if the current
-- 'antOrientation' value is N and the current 'antPosition' is (Coord 0 0), the
-- new 'antPosition' value shall be (Coord 0 1).
--
-- Read the comments in the 'src/Datastructures/Cells.hs' source code for more
-- description about the coordinate system.
--
-- Just like turnAnt all it does now is return the SquareWorld without doing
-- anything. You need to get the Ant and set it's Coord to the square in front
-- of it.
moveAnt :: SquareWorld -> SquareWorld
moveAnt squareWorld = let (world,c) = newSquareWorld$createAntWithCoord$squareWorld in transitionWorld c world

createCoord :: SquareWorld->Coord
createCoord world = case getDirection$world of
                         N->let oldCoord = getCoord$world in Coord (xCoord oldCoord) ((yCoord oldCoord)+1)
                         S->let oldCoord = getCoord$world in Coord (xCoord oldCoord) ((yCoord oldCoord)-1)
                         E->let oldCoord = getCoord$world in Coord ((xCoord oldCoord)+1) (yCoord oldCoord)
                         W->let oldCoord = getCoord$world in Coord ((xCoord oldCoord)-1) (yCoord oldCoord)

createAntWithCoord :: SquareWorld->Ant
createAntWithCoord world = Ant (createCoord world) (getDirection world) (antTransition (theAnt world))

-- Students: Please implement this function.
--
-- | This function extracts the 'antOrientation' field from the 'theAnt' field
-- of the parameter ('squareWorld').
getDirection :: SquareWorld -> Direction
getDirection squareWorld = antOrientation (theAnt squareWorld)

-- Students: Please implement this function.
--
-- | This function extracts the 'antPosition' field from the 'theAnt' field of
-- the parameter ('squareWorld').
getCoord :: SquareWorld -> Coord
getCoord squareWorld = antPosition (theAnt squareWorld)

-- #####################################################################
-- ######################## Part 1 Starts Here #########################
-- #####################################################################

-- Students: Please implement this function.
--
-- This is the main assessable function you need to write for Part 1.
-- When you run ./run_langtons_ant -m square this function is used.
--
-- | The 'transitionWorld' should transform the second parameter ('squareWorld')
-- as if the following actions are carried out sequentially:
--
-- 1. The Ant makes a turn according to the current cell state.
--
-- 2. Transition the cell under the Ant to its next state.
--
-- 3. The Ant moves forward by one cell.
--
-- This function is called on line 78 in src/Main.hs.
--
-- The first parameter ('firstCell') specifies the state of cells not recorded
-- in the 'theWorld' field in the second parameter ('squareWorld'). The second
-- parameter is the old state of the world. The return value shall be the new
-- state of the world, that is, a new SquareWorld value with both the 'theAnt'
-- field and the 'theWorld' field different from the old state. The Ant shall
-- have made the turn and moved forward, and the world shall contain the state
-- of the updated cell.
--
-- Hint: The rule of how the Ant should turn when standing on a cell of each
-- colour is determined by the 'antTransition' field of the Ant. See
-- 'src/Datastructure/Ant.hs' for more descriptions.
--
-- Hint: There are functions that help you find the cells at specific
-- coordinates in the square world.  See 'src/Datastructure/SquareWorld.hs'.
--
-- Hint: You should consider CellState as an opaque type. All you need to know
-- about that type is that (1) you can extract its current colour, and (2) you
-- can transition it to the next state.  See 'src/Datastructure/Cells.hs'.
transitionWorld :: CellState -> SquareWorld -> SquareWorld
transitionWorld firstCell squareWorld = squareWorld


-- ############### Allows for different transition systems #############

-- Students: Implement this function if you want to support different transition
-- systems.
--
-- This function is not meant to help you write transitionWorld.
-- When you run ./run_langtons_ant -m square -t LLRR
-- the "LLRR" is passed to this function. When you implement this
-- you will be able to test out different transition systems
--
-- | The 'readSquareTransition' function takes a String ('str') as parameter.
-- The string may be arbitrarily long. For valid inputs, each character in the
-- string is either L or R. It is invalid if it contains any other characters.
-- For any valid input, this function shall return (Just turns) where 'turns' is
-- a list of SquareTurn values (L or R) matching each input character (L or R).
-- Return Nothing for any invalid inputs.
--
-- Examples:
--
-- >>> readSquareTransition "LLRL"
-- Just [L,L,R,L]
--
-- >>> readSquareTransition "LLRRLRLLRL"
-- Just [L,L,R,R,L,R,L,L,R,L]
--
-- >>> readSquareTransition "LLRPLLL"
-- Nothing
--
-- Because "P" is not a valid character, the entire output is Nothing.
--
-- >>> readSquareTransition ""
-- Just []
--
-- The empty string is still valid because it does not contain any invalid
-- characters.
readSquareTransition :: String -> Maybe [SquareTurn]
readSquareTransition str = Nothing
