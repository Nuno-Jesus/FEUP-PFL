{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use :" #-}
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

    4*x^2y^3 + 3*x + 1*y^3x^2 + y + 0*z 
    [(4,[('x',2), ('y', 3)]), (3,[('x',1)]), (1, [('y', 3), ('x',2)]), (1,[('y',1)]), (0,[('z',1)])] 

 -}

sortLiterals :: Polynome -> Polynome
sortLiterals p = [(fst x, sort (snd x)) | x <- p]

cleanZeros :: Polynome -> Polynome
cleanZeros = filter (\m -> fst m /= 0)

sameLiteral :: Monome -> Monome -> Bool
sameLiteral m1 m2 = snd m1 == snd m2

groupMonomes :: Polynome -> [Polynome]
groupMonomes p = groupBy sameLiteral (sortOn snd (sortLiterals (cleanZeros p)))

sumAll :: Polynome -> Monome
sumAll lst = (sum (map fst lst), snd (head lst))

normPoly :: Polynome -> Polynome
normPoly p = [sumAll m | m <- groupMonomes p]

addPoly :: Polynome -> Polynome -> Polynome
addPoly p1 p2 = normPoly (normPoly p1 ++ normPoly p2)

deriveMonome :: Char -> Monome -> Monome
deriveMonome dim m = (fst m * fromMaybe 0 (lookup dim (snd m)), 
  map (\l -> if fst l == dim then (fst l, snd l - 1) else l) (snd m))

derivePoly :: Char -> Polynome -> Polynome
derivePoly dim p = cleanZeros (map (deriveMonome dim) (normPoly p))

multPoly :: Polynome -> Polynome -> Polynome
multPoly p1 p2 = [multMono a b | a <- normPoly p1, b <- normPoly p2]

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
strToPoly str = strToPoly' $ filter (\c -> c /= '^' && c/= ' ') str

isSignal :: Char -> Bool
isSignal c = c == '+' || c == '-'

notSignal :: Char -> Bool
notSignal c = c /= '+' && c /= '-'

stringToInt :: String -> Int
stringToInt [] = 0
stringToInt str = digitToInt (head str) * 10 ^ (length str - 1) + stringToInt (tail str)