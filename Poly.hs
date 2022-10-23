module Poly where

import Data.List
import Data.Maybe
import Data.Char

type Literal = (Char, Int)
type Monome = (Int, [Literal])
type Polynome = [Monome]

---------------------------------------------- ! NORMALIZING POLYNOMES ----------------------------------------------

sameLiteral :: Monome -> Monome -> Bool
sameLiteral m1 m2 = snd m1 == snd m2

sortLiterals :: Polynome -> Polynome
sortLiterals p = [(fst x, sort (snd x)) | x <- p]

cleanZeros :: Polynome -> Polynome
cleanZeros [(0, _)] = [(0,[])]
cleanZeros p = filter (\m -> fst m /= 0)  [(fst el, filter (\m -> snd m /= 0) (snd el)) | el <- p]

sumMonomes :: [Monome] -> Monome
sumMonomes lst = (sum $ map fst lst, snd $ head lst)

groupMonomes :: Polynome -> [Polynome]
groupMonomes p = groupBy sameLiteral $ sortOn snd $ sortLiterals $ cleanZeros p

normPoly :: Polynome -> Polynome
normPoly [] = [(0, [])]
normPoly p = cleanZeros [sumMonomes x | x <- groupMonomes p]

normPoly' :: String -> String
normPoly' p1 = polyToStr $ normPoly $ strToPoly p1

---------------------------------------------- ! ADDING POLYNOMES ----------------------------------------------

addPoly :: Polynome -> Polynome -> Polynome
addPoly p1 p2 = normPoly (normPoly p1 ++ normPoly p2)


addPoly' :: String -> String -> String
addPoly' p1 p2 = polyToStr $ addPoly (strToPoly p1) (strToPoly p2)

---------------------------------------------- ! DERIVING POLYNOMES ----------------------------------------------

deriveMonome :: Char -> Monome -> Monome
deriveMonome dim m = (fst m * fromMaybe 0 (lookup dim (snd m)), 
  map (\l -> if fst l == dim then (fst l, snd l - 1) else l) (snd m))

derivePoly :: Char -> Polynome -> Polynome
derivePoly dim p = normPoly $ map (deriveMonome dim) (normPoly p)

derivePoly' :: String -> Char -> String
derivePoly' p1 ch = polyToStr $ derivePoly ch (strToPoly p1)

---------------------------------------------- ! MULTIPLYING POLYNOMES ----------------------------------------------

sameVar :: Literal -> Literal -> Bool
sameVar a b = fst a == fst b

multLiterals :: [[Literal]] -> [Literal]
multLiterals lst = [(fst (head x), sum $ snd $ unzip x) | x <- lst]

multMono :: Monome -> Monome -> Monome
multMono m1 m2 = (fst m1 * fst m2, multLiterals $ groupBy sameVar $ sort $ snd m1 ++ snd m2)

multPoly :: Polynome -> Polynome -> Polynome
multPoly p1 p2 = normPoly [multMono a b | a <- normPoly p1, b <- normPoly p2]

multPoly' :: String -> String -> String
multPoly' p1 p2 = polyToStr $ multPoly (strToPoly p1) (strToPoly p2)

---------------------------------------------- ! STRING TO POLYNOME ----------------------------------------------

normStr :: String -> Bool -> String
normStr [] _ = []
normStr (x:xs) n 
	| isDigit x = x : normStr xs True
	| isSignal x = x : normStr xs False
	| otherwise = if not n then ['1'] ++ [x] ++ normStr xs True else [x] ++ normStr xs True 

isSignal :: Char -> Bool
isSignal c = c == '+' || c == '-'

notSignal :: Char -> Bool
notSignal c = c /= '+' && c /= '-'

stringToInt :: String -> Int
stringToInt [] = 0
stringToInt str = digitToInt (head str) * 10 ^ (length str - 1) + stringToInt (tail str)

-- Receives something like x2y3, xy, x4y, y
strToLiteral :: String -> [Literal]
strToLiteral [] = []
strToLiteral [x] = [(x, 1)]
strToLiteral (x:xs) 
	| isDigit $ head xs = [(x, stringToInt (takeWhile isDigit xs))] ++ strToLiteral (dropWhile isDigit xs)
	| isLetter $ head xs = [(x, 1)] ++ strToLiteral xs

-- Receives something like -4x2y3, -1x2, 1xy3
strToMono :: String -> Monome
strToMono (x:xs)
	| x == '-' = (-1 * stringToInt (takeWhile isDigit xs), strToLiteral $ dropWhile isDigit xs)
	| x == '+' = (stringToInt (takeWhile isDigit xs), strToLiteral $ dropWhile isDigit xs)
	| isDigit x = (stringToInt (takeWhile isDigit (x:xs)), strToLiteral $ dropWhile isDigit (x:xs))
	| otherwise = (1, strToLiteral (x:xs))

-- Receives the whole string filtered of ' ' and '^'
strToPoly' :: String -> Polynome
strToPoly' [] = []
strToPoly' str
	| isSignal $ head str = [strToMono (head str : takeWhile notSignal (tail str))] ++ strToPoly (dropWhile notSignal (tail str))
	| otherwise = [strToMono (takeWhile notSignal str)] ++ strToPoly (dropWhile notSignal str)

-- Receives the raw string to filter first
strToPoly :: String -> Polynome
strToPoly str = strToPoly' $ normStr (filter (\c -> c /= '^' && c/= ' ') str) False

---------------------------------------------- ! POLYNOME TO STRING ----------------------------------------------

polyToStr :: Polynome -> String
polyToStr [] = "0"
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


