import Poly

strToPolyTest :: String -> Polynome -> String
strToPolyTest str p = if (strToPoly str) == p then "Success" else "Test Failed"

addPolyTest :: Polynome -> Polynome -> Polynome -> String
addPolyTest p1 p2 p3 = if (addPoly p1 p2) == p3 then "Success" else "Test failed"

multPolyTest :: Polynome -> Polynome -> Polynome -> String
multPolyTest p1 p2 p3 = if (multPoly p1 p2) == p3 then "Success" else "Test Failed"

derivePolyTest :: Polynome -> Polynome -> Char -> String
derivePolyTest p1 p2 dim = if (derivePoly dim p1) == p2 then "Success" else "Test failed"

normPolyTest :: Polynome -> Polynome -> String
normPolyTest p1 p2 = if (normPoly p1) == p2 then "Success" else "Test failed"

polyToStrTest :: Polynome -> String -> String
polyToStrTest p str = if (polyToStr p) == str then "Success" else "Test failed"

main :: IO()
main = do 
	putStrLn "\n\t>>>>>>>>>>>>>>>>>>>>>> STRING TO POLYNOME <<<<<<<<<<<<<<<<<<<<<<\n"
	putStrLn ("Test 1: " ++ strToPolyTest "" [])
 	putStrLn ("Test 2: " ++ strToPolyTest "0" [(0, [])])
	putStrLn ("Test 3: " ++ strToPolyTest "4" [(4, [])])
	putStrLn ("Test 4: " ++ strToPolyTest "-4" [(-4, [])])
	putStrLn ("Test 5: " ++ strToPolyTest "3x" [(3, [('x', 1)])])
	putStrLn ("Test 6: " ++ strToPolyTest "9x ^10" [(9, [('x', 10)])])
	putStrLn ("Test 7: " ++ strToPolyTest "-10x^10 + 2xy^8" [(-10, [('x', 10)]), (2, [('x', 1), ('y', 8)])])
	putStrLn ("Test 8: " ++ strToPolyTest "3y^2z^4 -0x^8 +4" [(3, [('y', 2), ('z', 4)]), (0, [('x', 8)]), (4, [])])

	putStrLn ("\n\t>>>>>>>>>>>>>>>>>>>>>> NORMALIZING POLYNOMES <<<<<<<<<<<<<<<<<<<<<<\n")
	putStrLn ("Test 1: " ++ normPolyTest [] [(0, [])])
	putStrLn ("Test 2: " ++ normPolyTest [(8, []), (7, [])] [(15, [])])
	putStrLn ("Test 3: " ++ normPolyTest [(1, [('x', 1)]), (4, [('x', 1)])] [(5, [('x', 1)])])
	putStrLn ("Test 4: " ++ normPolyTest [(12, [('x', 1)]), (-4, [('y', 1)])] [(12, [('x', 1)]), (-4, [('y', 1)])])
	putStrLn ("Test 5: " ++ normPolyTest [(-12, [('x', 1)]), (4, [('x', 1)])] [(-8, [('x', 1)])])
	putStrLn ("Test 6: " ++ normPolyTest [(-12, [('x', 1), ('y', 3)]), (4, [('y', 3), ('x', 1)]), (-5, [])] [(-5,[]), (-8, [('x', 1), ('y', 3)])]) 
	putStrLn ("Test 7: " ++ normPolyTest [(1, [('x', 2)]), (-1, [('x', 2)])] [(0, [])])
	putStrLn ("Test 8: " ++ normPolyTest [(4,[('x',2), ('y', 3)]), (3,[('x',1)]), (1, [('y', 3), ('x',2)]), (1,[('y',1)]), (0,[('z',1)])] [(3,[('x',1)]),(5,[('x',2),('y',3)]),(1,[('y',1)])])

	putStrLn ("\n\t>>>>>>>>>>>>>>>>>>>>>> ADDING POLYNOMES <<<<<<<<<<<<<<<<<<<<<<\n")
	putStrLn ("Test 1: " ++ addPolyTest [(10,[('x', 1)])] [(15,[('x', 1)])] [(25, [('x', 1)])])
	putStrLn ("Test 2: " ++ addPolyTest [(10,[('x', 1),('y',1)])] [(4,[('y',1),('x', 1)])] [(14, [('x', 1),('y',1)])])
	putStrLn ("Test 3: " ++ addPolyTest [(10,[('x', 1)])] [(-15,[('x', 1)])] [(-5, [('x', 1)])])
	putStrLn ("Test 4: " ++ addPolyTest [(5,[('x', 1)])] [(-4,[('y', 1)])] [(5, [('x', 1)]), (-4, [('y', 1)])])
	putStrLn ("Test 5: " ++ addPolyTest [(-3,[('x', 2), ('y',1)])] [(9,[('x', 1), ('y',1)])] [(9,[('x', 1), ('y', 1)]), (-3,[('x',2), ('y', 1)])])
	putStrLn ("Test 6: " ++ addPolyTest [(-3,[('x', 2), ('y',1)])] [(9,[('y',1),('x',2)])] [(6, [('x', 2), ('y', 1)])])
	putStrLn ("Test 7: " ++ addPolyTest [(-3,[('x', 2), ('y',1)]), (1,[])] [(9,[('x', 1), ('y',1)]), (2,[])] [(3,[]), (9,[('x', 1), ('y', 1)]), (-3,[('x',2), ('y', 1)])])
	putStrLn ("Test 8: " ++ addPolyTest [(-1,[('x', 1)])] [(1,[('x', 1)])] [(0, [])])

	putStrLn ("\n\t>>>>>>>>>>>>>>>>>>>>>> DERIVING POLYNOMES <<<<<<<<<<<<<<<<<<<<<<\n")
	putStrLn ("Test 1: " ++ derivePolyTest [(1, [])] [(0, [])] 'x')
	putStrLn ("Test 2: " ++ derivePolyTest [(1, [('x', 2)])] [(2, [('x', 1)])] 'x')
	putStrLn ("Test 3: " ++ derivePolyTest [(1, [('x', 2)]), (-3, [('x', 1)]), (10, [('x', 10)])] [(-3, []), (2, [('x', 1)]), (100, [('x', 9)])] 'x')
	putStrLn ("Test 4: " ++ derivePolyTest [(7, [('x', 3), ('y', 1)])] [(21, [('x', 2), ('y', 1)])] 'x')
	putStrLn ("Test 5: " ++ derivePolyTest [(7, [('x', 3), ('y', 1)])] [(7, [('x', 3)])] 'y')
	putStrLn ("Test 6: " ++ derivePolyTest [(1, []), (4, []), (9, [])] [(0, [])] 'x')
	putStrLn ("Test 7: " ++ derivePolyTest [(1, [('x', 2)]), (4, [('x', 2)]), (9, [('x', 2)])] [(28, [('x', 1)])] 'x')
	putStrLn ("Test 8: " ++ derivePolyTest [(1, [('x', 2)]), (4, [('y', 2)]), (9, [('z', 2)])] [(2, [('x', 1)])] 'x')

	putStrLn ("\n\t>>>>>>>>>>>>>>>>>>>>>> MULT POLYNOMES <<<<<<<<<<<<<<<<<<<<<<\n")
	putStrLn ("Test 1: " ++ multPolyTest [(1, [('x',1), ('y',1)])] [(0, [])] [(0, [])] )
	putStrLn ("Test 2: " ++ multPolyTest [(1, [('x',1), ('y',1)])] [(0, []), (1,[('z',1)])] [(1,[('x',1), ('y',1), ('z',1)])] )
	putStrLn ("Test 3: " ++ multPolyTest [(1, [('x',2)])] [(5, [('x',4)])] [(5, [('x',6)])] )
	putStrLn ("Test 4: " ++ multPolyTest [(0, [('x', 3), ('y', 1)])] [(21, [('x', 2), ('y', 1)])] [(0, [])] )
	putStrLn ("Test 5: " ++ multPolyTest [(7, [('x', 3), ('y', 1)]), (13, [('z',1)])] [(4, [('x', 1), ('z', 3)]),(-1, [('y', 3)])] [(52,[('x',1),('z',4)]),(-7,[('x',3),('y',4)]),(28,[('x',4),('y',1),('z', 3)]),(-13,[('y',3),('z',1)])])

	putStrLn "\n\t>>>>>>>>>>>>>>>>>>>>>> POLYNOME TO STRING <<<<<<<<<<<<<<<<<<<<<<\n"
	putStrLn ("Test 1: " ++ polyToStrTest [] "0")
 	putStrLn ("Test 2: " ++ polyToStrTest [(0, [])] "0")
	putStrLn ("Test 3: " ++ polyToStrTest [(4, [])] "4")
	putStrLn ("Test 4: " ++ polyToStrTest [(-4, [('x', 1)])] "-4x")
	putStrLn ("Test 5: " ++ polyToStrTest [(90, [('x', 30)])] "90x^30")
	putStrLn ("Test 6: " ++ polyToStrTest [(9, [('x', 1), ('y', 1), ('z', 1)]), (1, [('x', 2), ('y', 2), ('z', 2)])] "9xyz + x^2y^2z^2")
	putStrLn ("Test 7: " ++ polyToStrTest [(-10, [('x', 10)]), (2, [('x', 1), ('y', 8)])] "-10x^10 + 2xy^8")
	putStrLn ("Test 8: " ++ polyToStrTest [(3, [('y', 2), ('z', 4)]), (7, [('x', 8)]), (4, [])] "3y^2z^4 + 7x^8 + 4")
