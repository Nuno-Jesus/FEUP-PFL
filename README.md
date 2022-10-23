# 1# Pratical Assignment

## Description
The project objective is to develop, in Haskell, a program capable of manipulating polynomials. The main functionalities are addition, normalization, derivation, multiplication, parsing a polynomial into a string, and vice-versa. The code should undergo test cases.

## The Polynomial Structure
A **Literal** is a tuple where the first element is the variable and the second element is an integer representing its exponent.

```haskell 
	type Literal = (Char, Int)
```

A **Monome** is a tuple, where the first element is an integer representing the coefficient, and the second element is a list of **Literal**. 

```haskell 
	type Monome = (Int, [Literal])
```

A list of monomials () defines a polynomial.

```haskell 
	type Polynome = [Monome]
```
 
 This structure allows us to manipulate specific parts of the polynomial, like breaking the problem into little pieces, solving them, and putting everything back together.

## Strategies used to implement the main functions

 - Normalization:
   <ol>
	<li>Filter literals with exponent equal to zero and filter monomials with coefficient equal to zero;</li>
    <li>Order literals by variable and monomials by literal;</li>
    <li>Group monomials by literals into sublists;</li>
    <li>Solve each sublist of monomials into a single monomial;</li>
    <li>Repeat step 1.</li>
   </ol>
 - Addition:
   <ol>
	<li>Concatenate the two polinomials;</li>
    <li>Normalize the resulting polinomial using normPoly function.</li>
   </ol>
- Multiplication:
   <ol>
	<li>Normalize both polynomials;</li>
    <li>Multiply each term of the first polynomial with each one of the second:
		<ol>
        	<li>Concatenate the monomials lists of literals;</li>
        	<li>Sort and group resulting list by variable;</li>
        	<li>Calculate resulting literal from each sublist of literal with the same variable.</li>
   		</ol>
	</li>
    <li>Normalize resulting polynomial.</li>
   </ol>
- Derivation:
    <ol>
	<li>Normalize polynomial;</li>
    <li>Apply the derivative of each monomial in relation with a variable:</li>
        <ol>
        	<li>Find variable in the term;</li>
        	<li>Apply changes to the coefficient and the exponent of the variable;</li>
        	<li>If the variable does not match in the monomial then coefficient equal to zero</li>
   		</ol>
    <li>Normalize result</li>
    </ol>

- Converting String to Polynomial:
	<ol>
		<li>Take as many as characters as needed to define a Monome (until the next signal is found) and parse it;</li>
		<li>Assemble a Monome with the first characters of the token that define the coefficient and with the result of parsing the rest of the string (containing the literals);</li>
		<li>Assemble the List of Literals by parsing each pair of characters to find a variable and its exponent (if it exists);</li>
		<li>Repeat step 1 until no more monomes are found.</li>
	</ol>

- Converting Polynomial to String
    <ol>
        <li>Isolate and convert each Monomial;</li>
        <li>Isolate and convert each literal from the monomial</li>
        <li>Concatenate the resulting string of the literals conversion with the string representing the coefficient</li>
        <li>Assemble the resulting strings of the monomials</li>
   </ol>


## Testing
We made auxiliary functions to aid us testing our program, each function tests a specific functionaliy. In Main.hs there is a do block which uses these auxiliary functions to test some examples.

