import Data.List

type Power = (Char, Int)
type Monome = (Int, [Power])
type Polynome = [Monome]

{- 
	3x + 2y + 4x
	[(3, [('x', 1)]), (2, [('y', 1)]), (4, [('x', 1)])]
	
	3xy + 2yx + 4x
	[(3, [('x', 1), ('y', 1)]), (2, [('y', 1), ('x', 1)]), (4, [('x', 1)])]

	4xy + 0x + 3z
	[(4, [('x', 1), ('y', 1)]), (0, [('x', 1)]), (3, [('z', 1)])]

	4xy + 3yx
	[(4, [('x', 1), ('y', 1)]), (3, [('y', 1), ('x', 1)])]

    4*x^2y^3 + 3*x + 1*y^3x^2 + y + 0*z 
    [(4,[('x',2), ('y', 3)]), (3,[('x',1)]), (1, [('y', 3), ('x',2)]), (1,[('y',1)]), (0,[('z',1)])] 

	foldr sumMonome (0, [(' ', 0)]) [(4,[('x',2)]),(1,[('x',2)])] = (5,[('x',2)])
 -}

sortLiterals :: Polynome -> Polynome
sortLiterals p = [(fst x, sort (snd x)) | x <- p]

cleanZeros :: Polynome -> Polynome
cleanZeros = filter (\m -> fst m /= 0)

sameLiteral :: Monome -> Monome -> Bool
sameLiteral m1 m2 = snd m1 == snd m2

groupMonomes :: Polynome -> [Polynome]
groupMonomes p = groupBy sameLiteral (sortOn snd (sortLiterals(cleanZeros p)))

sumAll :: Polynome -> Monome
sumAll lst = (sum (map fst lst), snd (head lst))

normPoly :: Polynome -> Polynome
normPoly p = [sumAll m | m <- groupMonomes p]

addPoly :: Polynome -> Polynome -> Polynome
addPoly p1 p2 = normPoly (p1 ++ p2)

derivePoly :: Char -> Polynome -> Polynome
derivePoly dim p = []

multPoly :: Polynome -> Polynome -> Polynome
multPoly p1 p2 = []



