{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use :" #-}
{-# HLINT ignore "Use second" #-}

module Polynome where

import Data.List
import Data.Maybe
import Data.Char

type Literal = (Char, Int)
type Monome = (Int, [Literal])
type Polynome = [Monome]

{- 
	3x + 2y + 4x
	[(3, [('x', 1)]), (2, [('y', 1)]), (4, [('x', 1)])]
	
	3xy + 2yx + 4x
	[(3, [('x', 1), ('y', 1)]), (2, [('y', 1), ('x', 1)]), (4, [('x', 1)])]

	4xy + 0x + 3z
	[(4, [('x', 1), ('y', 1)]), (0, [('x', 1)]), (3, [('z', 1)])]

	4x^2y^3 + 3y^3x^2
	[(4, [('x', 2), ('y', 3)]), (3, [('y', 3), ('x', 2)])]

    4x^2y^3 + 3x + y^3x^2 + y + 0z 
    [(4,[('x',2), ('y', 3)]), (3,[('x',1)]), (1, [('y', 3), ('x',2)]), (1,[('y',1)]), (0,[('z',1)])] 

 -}

sortLiterals :: Polynome -> Polynome
sortLiterals p = [(fst x, sort (snd x)) | x <- p]

cleanZeros :: Polynome -> Polynome
cleanZeros [(0, _)] = [(0,[])]
cleanZeros p = filter (\m -> fst m /= 0)  [(fst el, filter (\m -> snd m /= 0) (snd el)) | el <- p]

sameLiteral :: Monome -> Monome -> Bool
sameLiteral m1 m2 = snd m1 == snd m2

groupMonomes :: Polynome -> [Polynome]
groupMonomes p = groupBy sameLiteral $ sortOn snd $ sortLiterals $ cleanZeros p

sumAll :: [Monome] -> Monome
sumAll lst = (sum $ map fst lst, snd $ head lst)

normPoly :: Polynome -> Polynome
normPoly p = cleanZeros [sumAll m | m <- groupMonomes p]

addPoly :: Polynome -> Polynome -> Polynome
addPoly p1 p2 = normPoly (normPoly p1 ++ normPoly p2)

deriveMonome :: Char -> Monome -> Monome
deriveMonome dim m = (fst m * fromMaybe 0 (lookup dim (snd m)), 
  map (\l -> if fst l == dim then (fst l, snd l - 1) else l) (snd m))

derivePoly :: Char -> Polynome -> Polynome
derivePoly dim p = normPoly $ map (deriveMonome dim) (normPoly p)

multPoly :: Polynome -> Polynome -> Polynome
multPoly p1 p2 = normPoly [multMono a b | a <- normPoly p1, b <- normPoly p2]

multMono :: Monome -> Monome -> Monome
multMono m1 m2 = (fst m1 * fst m2, multLiterals $ groupBy sameVar $ sort $ snd m1 ++ snd m2)

multLiterals :: [[Literal]] -> [Literal]
multLiterals lst = [(fst (head x), sum $ snd $ unzip x) | x <- lst]

sameVar :: Literal -> Literal -> Bool
sameVar a b = fst a == fst b

---------------------------------------------- ! PARSING ----------------------------------------------

-- Recieves something like x2y3, xy, x4y, y
strToLiteral :: String -> [Literal]
strToLiteral [] = []
strToLiteral [x] = [(x, 1)]
strToLiteral (x:xs) 
	| isDigit $ head xs = [(x, stringToInt (takeWhile isDigit xs))] 
		++ strToLiteral (dropWhile isDigit xs)
	| isLetter $ head xs = [(x, 1)] 
		++ strToLiteral xs

-- Receives something like -4x2y3, -1x2, 1xy3
strToMono :: String -> Monome
strToMono (x:xs)
	| x == '-' = (-1 * stringToInt (takeWhile isDigit xs), strToLiteral $ dropWhile isDigit xs)
	| x == '+' = (stringToInt (takeWhile isDigit xs), strToLiteral $ dropWhile isDigit xs)
	| isDigit x = (stringToInt (takeWhile isDigit (x:xs)), strToLiteral $ dropWhile isDigit (x:xs))
	| otherwise = (1, strToLiteral (x:xs))

-- Recieves the whole string filtered of ' ' and '^'
strToPoly' :: String -> Polynome
strToPoly' [] = []
strToPoly' str
	| isSignal $ head str = [strToMono (head str : takeWhile notSignal (tail str))] 
		++ strToPoly (dropWhile notSignal (tail str))
	| otherwise = [strToMono (takeWhile notSignal str)] 
		++ strToPoly (dropWhile notSignal str)

-- Recieves the raw string to filter first
strToPoly :: String -> Polynome
strToPoly str = strToPoly' $ normalizeStr (filter (\c -> c /= '^' && c/= ' ') str) False

normalizeStr :: String -> Bool -> String
normalizeStr [] _ = []
normalizeStr (x:xs) hasCoeff 
	| isDigit x = x : normalizeStr xs True
	| isSignal x = x : normalizeStr xs False
	| otherwise = if not hasCoeff 
		then ['1'] ++ [x] ++ normalizeStr xs True
		else [x] ++ normalizeStr xs True 

isSignal :: Char -> Bool
isSignal c = c == '+' || c == '-'

notSignal :: Char -> Bool
notSignal c = c /= '+' && c /= '-'

stringToInt :: String -> Int
stringToInt [] = 0
stringToInt str = digitToInt (head str) * 10 ^ (length str - 1) + stringToInt (tail str)

polyToStr :: Polynome -> String
polyToStr p
    | fst (head p) >= 0 =  drop 3 (foldr ((++) . monoToStr) [] p)
	| otherwise = "-" ++ drop 3 (foldr ((++) . monoToStr) [] p)

monoToStr :: Monome -> String
monoToStr m
    | not (null (snd m)) = numToStr (fst m)  ++ litToStr (snd m)
	| otherwise = numToStr (fst m)

numToStr :: Int -> String
numToStr x
    | x == 1 = " + "
    | x > 1 = " + " ++ show x
    | x == 0 = " + " ++ show 0
	| otherwise = " - " ++ show (abs x)

litToStr :: [Literal] -> String
litToStr [] = []
litToStr (x:xs)
    | snd x == 1 = [fst x] ++ litToStr xs
    | otherwise = [fst x] ++ ['^'] ++ show (snd x) ++ litToStr xs

---------------------------------------------- ! OTHERS ----------------------------------------------

normPoly' :: String -> String
normPoly' p1 = polyToStr $ normPoly $ strToPoly p1

addPoly' :: String -> String -> String
addPoly' p1 p2 = polyToStr $ addPoly (strToPoly p1) (strToPoly p2)

multPoly' :: String -> String -> String
multPoly' p1 p2 = polyToStr $ multPoly (strToPoly p1) (strToPoly p2)

derivePoly' :: String -> Char -> String
derivePoly' p1 ch = polyToStr $ derivePoly ch (strToPoly p1)


-- NEEDTO:
{-
	- Clean Literals where the exponent is 0 X
	- Create the test file
	- Convert polynomials to strings X
	- Refactor the code if there is time to do it
	- Make the README.md and convert to pdf
-} 
