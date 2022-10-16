import Data.List

type Power = (Char, Int)
type Monome = (Int, [Power])
type Polynome = [Monome]

{- 
	3x + 2y + 4x
	[(3, [('x', 1)]), (2, [('y', 1)]), (4, [('x', 1)])]

	[] [(3, [('x', 1)]), (2, [('y', 1)]), (4, [('x', 1)])]
	[(3, [('x', 1)])] [(2, [('y', 1)]), (4, [('x', 1)])]
	[(3, [('x', 1)]), (2, [('y', 1)])] [(4, [('x', 1)])]

	sumMonome :: Monome -> Monome -> [Monome]
	sumMonome m1 m2 = 
		if snd m1 == snd m2 = (fst m1 + fst m2, snd m1)
		else = [m1, m2]

	zipWith sumMonome [(3, [('x', 1)]), (2, [('y', 1)])] [(4, [('x', 1)])]

	4xy + 0x + 3z
	[(4, [('x', 1), ('y', 1)]), (0, [('x', 1)]), (3, [('z', 1)])]

    4*x^2 + 3*x + 1*x^2 + y + 0*z 
    [(4,[('x',2)]), (3,[('x',1)]), (1, [('x',2)]), (1,[('y',1)]), (0,[('z',1)])] 

	foldr sumMonome (0, [(' ', 0)]) [(4,[('x',2)]),(1,[('x',2)])] = (5,[('x',2)])
 -}

cleanZeros :: Polynome -> Polynome
cleanZeros = filter (\m -> fst m /= 0) 

sameLiteral :: Monome -> Monome -> Bool
sameLiteral m1 m2 = snd m1 == snd m2

groupMonomes :: Polynome -> [Polynome]
groupMonomes p = groupBy sameLiteral (sortOn snd (cleanZeros p))

sumAll :: Polynome -> Monome
sumAll lst = (sum (map fst lst), snd (head lst))

normalize :: Polynome -> Polynome
normalize p = [sumAll m | m <- groupMonomes p]

