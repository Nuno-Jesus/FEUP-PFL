import Polynome

strToPolyTest :: String -> Polynome -> Bool
strToPolyTest str p = strToPoly str == p 

addPolyTest :: Polynome -> Polynome -> Polynome -> Bool
addPolyTest p1 p2 p3 = addPoly p1 p2 == p3

multPolyTest :: Polynome -> Polynome -> Polynome -> Bool
multPolyTest p1 p2 p3 = multPoly p1 p2 == p3

derivePolyTest :: Polynome -> Polynome -> Bool
derivePolyTest p1 p2 = derivePoly p1 == p2

normPolyTest :: Polynome -> Polynome -> Bool
normPolyTest p1 p2 = normPoly p1 == p2

polyToStrTest :: Polynome -> String -> Bool
polyToStrTest p str = polyToStr p == str




