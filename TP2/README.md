# **Qawale**

## **Installation and Execution**

Other than Sicstus, **no other software** is required to execute the game.
To run the program, you should follow these steps:

1. Open Sicstus.
2. Consult `main.pl`, located on the `src` folder.
3. Call the `play` predicate without any arguments.

------------------

## **Game Description**

- Qawale is a game designed to be strategic, yet simple and very fun. Typically you play in a **4x4** board, where you place stones (of your color) on top of other stone stacks. You must then move the stack and leave a stone for each cell you pass on. The game ends whenever a player has 4 stones of its color in a row/column/diagonal from the top view of the board.

### **Rules**

		1. The board is initialized with a stack of 2 neutral colors in each board's corner.
		2. In the first player's turn, they should choose a stack to place a stone on and move it across the board, leaving the bottom stone for each cell in the crossing path. The path must be shaped ortogonaly (no diagonal moves).
		3. You CANNOT place a pebble directly on an empty cell.
		4. You CANNOT go back over a cell that you have just passed through. However, you can return to a particular space by circling back to it.
		5. The winner is decided whenever one of the players manages to have a 4-stone row, column or diagonal view of their color.

### **Notes**

		1. A 4-stone stack of the same color is not valid for the winning case.
		2. If both players run out of pebbles and none of the managed to draw their line, the game ends in draw.

Official Site - [Hachette Board Games](https://www.hachetteboardgames.com/products/qawale)

Rulesbook - [Rulesbook](https://randolphca.sharepoint.com/sites/Public/Documents%20partages/Forms/AllItems.aspx?id=%2Fsites%2FPublic%2FDocuments%20partages%2FSales%20%2D%20Ventes%2FTOOLS%20OUTILS%2FVisuels%20jeux%20%2D%20Games%20Visual%2FUSA%2FQawale%20%2D%20media%20kit%2FQawale%20%2D%20rules%2Epdf&parent=%2Fsites%2FPublic%2FDocuments%20partages%2FSales%20%2D%20Ventes%2FTOOLS%20OUTILS%2FVisuels%20jeux%20%2D%20Games%20Visual%2FUSA%2FQawale%20%2D%20media%20kit&p=true&ga=1)

------------------

## **Game Logic Implementation**

The `src` folder contains different files, each of them used for different purposes:
	
|   File   | Description |
|   :--:   |:--|
|`board.pl`|Takes care of board-related validations| 
|`game.pl` |Contains predicates to enforce the game rules| 
|`io.pl`   |Holds the role to output the game results to the console| 
|`main.pl` |Simply contains the `play` predicate| 
|`menu.pl` |Reponsible for handling the user input and mapping to the correct menu option| 
|`tools.pl`|Utility predicates| 

### **Internal State Representation**
To keep track of the game's internal state, we make use of a `gameState` data structure that holds this structure:

- Board
- Player 1
- Player 2
- Player turn

### **Game State Visualization**
### **Game Plays Execution**
### **Valid Plays**
### **Endgame**
### **Board Evaluation**
### **Computer Plays**

------------------

## **Conclusions**

------------------

## **Bibliography**

- [Hachette Board Games](https://www.hachetteboardgames.com/products/qawale)
- [Rulesbook](https://randolphca.sharepoint.com/sites/Public/Documents%20partages/Forms/AllItems.aspx?id=%2Fsites%2FPublic%2FDocuments%20partages%2FSales%20%2D%20Ventes%2FTOOLS%20OUTILS%2FVisuels%20jeux%20%2D%20Games%20Visual%2FUSA%2FQawale%20%2D%20media%20kit%2FQawale%20%2D%20rules%2Epdf&parent=%2Fsites%2FPublic%2FDocuments%20partages%2FSales%20%2D%20Ventes%2FTOOLS%20OUTILS%2FVisuels%20jeux%20%2D%20Games%20Visual%2FUSA%2FQawale%20%2D%20media%20kit&p=true&ga=1)

------------------

## **Group Identification**

<table>
	<thead>
		<tr>
			<th>Group</th>
			<th>Number</th>
			<th>Name</th>
			<th>Contribution</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan=2>Qawale_1</td>
			<td>201905477</td>
			<td>Nuno Miguel Carvalho de Jesus</td>
			<td>5%</td>
		</tr>
		<tr>
			<td>202004724</td>
			<td>Vitor Manuel da Silva Cavaleiro</td>
			<td>95%</td>
		</tr>
	</tbody>
</table>

