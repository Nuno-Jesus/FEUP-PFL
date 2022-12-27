module Poly where

import Data.List
import Data.Maybe
import Data.Char

type Literal = (Char, Int)
type Monome = (Int, [Literal])
type Polynome = [Monome]

---------------------------------------------- ! NORMALIZING POLYNOMES ----------------------------------------------

{-
	@brief Given a Polynome, it returns the same Polynome where each Monome has its Literals sorted.
-}
sortLiterals :: Polynome -> Polynome
sortLiterals p = [(fst x, sort (snd x)) | x <- p]

{-
	@brief Given a Polynome, it returns the same Polynome filtered off null coeffiecient Monomes and 
		null exponent literals. This makes it so it doesn't print unnecessary stuff. First we filter the literals 
		with null exponent using a List Comprehension and later we also take out any null Monomes
-}
cleanZeros :: Polynome -> Polynome
cleanZeros [(0, _)] = [(0,[])]
cleanZeros p = filter (\m -> fst m /= 0)  [(fst el, filter (\m -> snd m /= 0) (snd el)) | el <- p]

{-
	@brief Given a Polynome, it returns a List of Polynome where each Polynome is a group of the Monomes with the 
		same literal part. After calling cleanZeros, we sort the literals of each Monome, so that we can later sort 
		each Monome by its literal parts. In other words, this process groups the Monomes with the same literal part
		so we need to have both literals and Monomes sorted in the right order.
-}
groupMonomes :: Polynome -> [Polynome]
groupMonomes p = groupBy (\m1 m2 -> snd m1 == snd m2) $ sortOn snd $ sortLiterals $ cleanZeros p

{-  
	@brief Given a Polynome, it sums Monomes with the same literal part and cleans any resulting Monomes that end up
		with a null coefficient
-}
normPoly :: Polynome -> Polynome
normPoly [] = [(0, [])]	
normPoly p = reverse $ cleanZeros [(sum (map fst x), snd(head x)) | x <- groupMonomes p]

{- 
	@brief Receives a polynome in a string format and returns its normalized form, also in string format
-}
normPoly' :: String -> String
normPoly' p1 = polyToStr $ normPoly $ strToPoly p1

---------------------------------------------- ! ADDING POLYNOMES ----------------------------------------------

{-
	@brief Given two Polynomes p1 and p2, it returns the sum of both. It simply concatenates both Polynomes to later on
		normalize the result.
-}
addPoly :: Polynome -> Polynome -> Polynome
addPoly p1 p2 = normPoly (p1 ++ p2)

{-
	@brief Given two Polynomes in string format, it returns the sum of both, also in string format. It uses
-}
addPoly' :: String -> String -> String
addPoly' p1 p2 = polyToStr $ addPoly (strToPoly p1) (strToPoly p2)

---------------------------------------------- ! DERIVING POLYNOMES ----------------------------------------------

{-
	@brief Given a dimension dim to derive on and a Monome m, it returns m derived in order to dim. For instance,
		writing deriveMonome 'x' (3, [('x', 2), ('y', 2)]) will result in (6, [('x', 1), ('y', 2)]). 
-}
deriveMonome :: Char -> Monome -> Monome
deriveMonome dim m = (fst m * fromMaybe 0 (lookup dim (snd m)), 
  map (\l -> if fst l == dim then (fst l, snd l - 1) else l) (snd m))


{-
	@brief Given a dimension dim to derive on and a Polynome p, it returns p derived on dim. It applys 
		deriveMonome to each Monome and normalizes the final result.
-}
derivePoly :: Char -> Polynome -> Polynome
derivePoly dim p = normPoly $ map (deriveMonome dim) (normPoly p)

{-
	@brief Given a Polynome in string format and a dimension dim to derive on, it returns p derived on dim, 
		also in string format.
-}
derivePoly' :: String -> Char -> String
derivePoly' p1 ch = polyToStr $ derivePoly ch (strToPoly p1)

---------------------------------------------- ! MULTIPLYING POLYNOMES ----------------------------------------------

{-  
	@brief Given a List of Lists of Literals, it returns a List of Literals where each Literal is the result of summing every
		exponent of the same dimension. In other words, each sublist represents the literals that contain the same dimension. 
		For instance, a possible argument would be [[('x', 2), ('x', 1)], [('y', 4), ('y', 2)]], which would result in
		[('x', 3), ('y', 6)]
-}
multLiterals :: [[Literal]] -> [Literal]
multLiterals lst = [(fst (head x), sum $ snd $ unzip x) | x <- lst]

{-
	@brief Given two Monomes m1 and m2, it returns the multiplication of both. It concatenates the literals of m1 and m2,
		to sort and group them by the same dimension so that the function multLiterals can be used properly.
-}
multMono :: Monome -> Monome -> Monome
multMono m1 m2 = (fst m1 * fst m2, multLiterals $ groupBy (\a b -> fst a == fst b) $ sort $ snd m1 ++ snd m2)


{-
	@brief Given two Polynomes p1 and p2, it returns the multiplication of both Polynomes.
-}
multPoly :: Polynome -> Polynome -> Polynome
multPoly p1 p2 = normPoly [multMono a b | a <- normPoly p1, b <- normPoly p2]

{-
	@brief Given two Polynomes p1 and p2 in string format, it returns the multiplication of both Polynomes, also in string format.
-}
multPoly' :: String -> String -> String
multPoly' p1 p2 = polyToStr $ multPoly (strToPoly p1) (strToPoly p2)

---------------------------------------------- ! STRING TO POLYNOME ----------------------------------------------
{-  
	@brief Given a Polynome in string format, it returns the string with '1' appended to monomes that do not contain a coefficient.
		This is needed to correctly parse the input string. It also makes use of a flag as a second argument to know whether we changed 
		monome or not.
-}
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

{-
	@brief Given a string representing a number, it return its Int representation.
-}
stringToInt :: String -> Int
stringToInt [] = 0
stringToInt str = digitToInt (head str) * 10 ^ (length str - 1) + stringToInt (tail str)

{-
	@brief Given a string representing a set of literals, it returns a List of Literals. It can receive something like "x2y3", "xyz", "x", "".
		This function uses recursion to deal with literals containing multiple dimensions, always parsing 1 character ahead of the current one, which is 
		always a dimension.
-}
strToLiteral :: String -> [Literal]
strToLiteral [] = []
strToLiteral [x] = [(x, 1)]
strToLiteral (x:xs) 
	| isDigit $ head xs = [(x, stringToInt (takeWhile isDigit xs))] ++ strToLiteral (dropWhile isDigit xs)
	| isLetter $ head xs = [(x, 1)] ++ strToLiteral xs

{-
	@brief Given a string representing a monome, it returns a Monome. It can receive something like "-4x2y3", "-1x2", "1xy3".
		This function splits its work in 2 by taking and parsing the first characters containing the signal and/or the coefficient and sending the 
		second part to strToLiteral.
-}
strToMono :: String -> Monome
strToMono (x:xs)
	| x == '-' = (-1 * stringToInt (takeWhile isDigit xs), strToLiteral $ dropWhile isDigit xs)
	| x == '+' = (stringToInt (takeWhile isDigit xs), strToLiteral $ dropWhile isDigit xs)
	| otherwise = (stringToInt (takeWhile isDigit (x:xs)), strToLiteral $ dropWhile isDigit (x:xs))

{-
	@brief Given a string representing a polynome, it returns a Polynome. It receives a polynome in string format, rid of ' ' and '^' characters.
		This function uses recursion to handle polynomes with multiple monomes. It take every character until a signal is found and sends it
		to strToMono.
-}
strToPoly' :: String -> Polynome
strToPoly' [] = []
strToPoly' str
	| isSignal $ head str = [strToMono (head str : takeWhile notSignal (tail str))] ++ strToPoly (dropWhile notSignal (tail str))
	| otherwise = [strToMono (takeWhile notSignal str)] ++ strToPoly (dropWhile notSignal str)

{-
	@brief Given a string representing a Polynome, it returns a Polynome. It receives the raw input of a polynome in string format, to get rid of
		' ' and '^' and concatenate '1' where necessary.
-}
strToPoly :: String -> Polynome
strToPoly str = strToPoly' $ normStr (filter (\c -> c /= '^' && c /= ' ') str) False

---------------------------------------------- ! POLYNOME TO STRING ----------------------------------------------


{- 
	@brief Given a Polynome, it returns a string representing that Polynome. Since the monoToStr always appends either " + " or " - " to each Monome,
		we use drop to take out an unnecessary "+" or spaces in the beggining of the string.
-}
polyToStr :: Polynome -> String
polyToStr [] = "0"
polyToStr p
    | fst (head p) >= 0 =  drop 3 (foldr ((++) . monoToStr) [] p)
	| otherwise = "-" ++ drop 3 (foldr ((++) . monoToStr) [] p)

{- 
	@brief Given a Monome, it returns a string representing that Monome.
-}
monoToStr :: Monome -> String
monoToStr m
    | not (null (snd m)) = numToStr (fst m)  ++ litToStr (snd m)
	| otherwise = numToStr (fst m)

{- 
	@brief Given a coefficient of a Monome, it returns a string representing that coefficient.
-}
numToStr :: Int -> String
numToStr x
    | x == 1 = " + "
    | x > 1 = " + " ++ show x
    | x == 0 = " + " ++ show 0
	| otherwise = " - " ++ show (abs x)

{-
	@brief Given a List of Literals, it returns a string representing each and every Literal.-}
litToStr :: [Literal] -> String
litToStr [] = []
litToStr (x:xs)
    | snd x == 1 = [fst x] ++ litToStr xs
    | otherwise = [fst x] ++ ['^'] ++ show (snd x) ++ litToStr xs


