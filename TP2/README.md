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
|`io.pl`   |Holds the role to output the game results to the console and reading user input| 
|`main.pl` |Simply contains the `play` predicate| 
|`menu.pl` |Reponsible for handling the user input and mapping to the correct menu option| 
|`tools.pl`|Utility predicates| 

------------------

### **Internal State Representation**
To keep track of the game's internal state, we make use of a `gameState` data structure that holds this structure:

|Field|Description|
|:--:|:--|
|Board      |Matrix where each element is a list, representing the pile of rocks|
|Player 1   |This structure is composed by the player's id(0), the player's piece, the player's type(human, greedy robot, ...), the current number of pieces still to be played|
|Player 2   |This structure is composed by the player's id(1), the player's piece, the player's type(human, greedy robot, ...), the current number of pieces still to be played|
|Player turn|0 or 1 depending on which turn it is. Shifts after each move|

The `gameState` data structure is initialized like this:
```Prolog
	init_game(Type1, Type2, gameState(NewBoard, player(0, Type1, 'R', 8), player(1, Type2, 'B', 8), 0)) :-
	init_board(NewBoard).
```
In the `init_game` predicate, the `Type1` and the `Type2` indicate, respectively, the type of Player1 and Player2. Each player gets initialized with 8 pieces and the respective id and piece type. The `init_board` predicate outputs the `NewBoard` variable, initializing the board. Finally the game's turn is always initialized with 0, so Player1 is always the first.

We assign RGB colors to distinguish the different stones: (R)ed for player 1, (B)lue for player 2 and (G)reen for neutral color stones.

These are examples of the game state through the game
- Initial Game State

```	Prolog
gameState(NewBoard, player(0, 'h', 'R', 8), player(1, 'h', 'B', 8), 0))
```
New Board:

```Prolog
[GG] [..] [..] [GG]  
[..] [..] [..] [..]
[..] [..] [..] [..]
[GG] [..] [..] [GG]
```
- Mid Game State

```	Prolog
gameState(MidGameBoard, player(0, 'cr', 'R', 6), player(1, 'cg', 'B', 7), 1))
```
MidGameBoard:
```Prolog
[B.] [GG] [GG] [..]  
[..] [R.] [R.] [..]
[..] [G.] [..] [..]
[..] [G.] [..] [GG]
```

- End Game State

```	Prolog
gameState(EndGameBoard, player(0, 'h', 'R', 3), player(1, 'cg', 'B', 3), 0))
```
EndGameBoard:

```Prolog
[...] [RG.] [...] [GG.]  
[...] [G..] [...] [B..]
[...] [GR.] [RRR] [...]
[B..] [B..] [GGB] [GB.]
```

------------------

### **Game State Visualization**

The game has a rectangular board that is printed before every player move. The board is represented using a 4x4 grid. This is an example of a possible board.

```Prolog
  0    1    2    3
0 [GG] [..] [..] [GG]  
1 [..] [..] [..] [..]
2 [..] [..] [..] [..]
3 [GG] [..] [..] [GG]
```

Here is what we do to represent the game cells:

Each cell is represented like a stack were the top is the most right element. In order to make the the visual aspect organized, we have a predicate in `board.pl` called `max_cell_size(+Board, -MaxCellSize)` wich outputs the size of the largest stack in the game. This is useful to print each cell with an offset, keeping the rows aligned. The cell offset is filled with the `'.'` character. Cells that only possess `'.'` characters are empty.

This is the code that handles the game displaying:
```Prolog
display_game(gameState(Board, player(Turn, Type , _, _), _, Turn)):-
	length(Board, Size),
	display_move_direction(Size),
	display_board(Type, Board).
	
display_game(gameState(Board, _, player(Turn, Type, _, _), Turn)):-
	length(Board, Size),
	display_move_direction(Size),
	display_board(Type, Board).
```

The `display_move_direction(+Size)` predicate gives information about the board. The `display_board(+Size)` predicate displays the board.

In the `display_board(+Type, +Board)` predicate, if a computer type player makes a move, the game asks for input before continuing, to assure the user sees the board before the next move.

There are also display predicates for the menu, such as:

- `print_title`: prints the title of the game in the menu;
- `print_options`: prints different game modes in the menu.

And finally, input reading predicates:

- `read_keyboard(-Input)`:  general input reading function;
- `read_move(-Move)`: ask user for move and validate input;
- `read_option(-Option)`: ask user for menu option;

------------------

### **Game Plays Execution**

The qawale game is a link of actions were we first place a stone in a non-empty stack, and then we need to specify a path where the pile will travel.

The game plays are acquired through the `choose_move(+Board, +Player, -Move)` predicate which behaves differently depending on the type of the player. In all cases, the predicate generates the valid moves. The move that gets picked depends on the player Type. If the play is made by the greedy bot, then a greedy move is selected from the list. On the other hand, the random bot selects a random move from the list. The human player is promped for input, and after validation, it checks if the chossen move is a member of the valid move list using the `evaluate_move(+Board, +Move)` predicate, if not it prompts the user again. Let's focus on the human perspective:  

Even thought there are two steps, the palacing of the stone and the movement of the pile, the user has to specify the two parts together. The reason we opted for this solution is because, the valid moves are outputed this way. The following steps represent the two plays that need to happen each turn, still, the user input in step 2 is an extension of the input in 1.

1. The user specifies the coordinates of the cell to place a stone on using this notation:

```txt
	X0-Y0 
```
2. We get the path to distribute the stack using the following regular expression...

```txt
	X0-Y0 X1-Y1 X2-Y2 ...
```
...where each position after `X0-Y0`  represents the path made by the stack of rocks. 
The input must respect the following constraints:
 - User has to specify step 1. and step 2. in the same input, just like explained before; 
 - The move chossen by the player, needs to be a valid move;
 - X and Y coordenates have to be between 0 and 9.

Each play is validated by applying the following logic:

The predicate `valid_moves(+Board, -List)`, declared in `game.pl`, receives the current board and outputs the list of valid moves. Given that the user input was accepted it still needs to be a member of this list, to be executed.

The move predicate was implemented as follows:

```Prolog
move(gameState(Board, player(Turn, Type, Piece, NP), Player2, Turn), Move, gameState(NewBoard, player(Turn, Type, Piece, NP1), Player2, NextTurn)):-
	move_aux(Board, Piece, Move, NewBoard),
	NP1 is NP-1,
	next_turn(Turn, NextTurn).
```
Where `move_aux(+Board, +Piece, +Move, -NewBoard)` predicate is declared as:
```Prolog
move_aux(Board, Piece, [X-Y|T], NewBoard):-
	push_piece(Board, X-Y, Piece, Stack, NewBoardAux),
	walk(NewBoardAux, T, Stack, NewBoard).
```
The `push_piece(+Board, +Position, +Piece, -Stack, -NewBoard)` predicate is responsable for ensuring the first step of the move, which is placing the stone on top of the stack. Finally we move the stack using the predicate `walk(+Board, +Path, +Stack, -NewBoard)`. At this point, we know the move is safe, because we already checked it in the `evaluate_move(+Board, +Move)` predicate. 

------------------

### **Valid Plays**

A move starts by placing a rock on top of a existing pile, so the first part of calculating a valid move is to locate every non-empty cell on the board. After placing the rock on top of a cell, we need to move the stack, the trick is, the stack cannot comeback to a cell it was before, so the second part is to calculate a path that respects that rule.  

The `valid_moves(+Board, -List)` predicate was implemented as follows:
```Prolog
	valid_moves(Board, List):-
	get_piles(Board, Piles),
	valid_moves_aux(Board, Piles, List).
```
Where `valid_moves_aux(+Board, +Piles, -List)` predicate is declared as:
```
valid_moves_aux(_, [], []).
valid_moves_aux(Board, [H|T], List):-
	findall(Path, (get_path(Board, H, Path)), List1),
	valid_moves_aux(Board, T, List2),
	append(List1, List2, List).
```
We use the `findall` predicate to collect every valid_move given by the `get_path(+Board, +Position, -Path)` predicate, which is defined as:
```
get_path(Board, X-Y, Path):-
	at(Board, X, Y, Elem),
	length(Elem, PileSize),
	PileSize1 is PileSize+1,
	length(Board, Limit),
	dfs(X-Y, PileSize1, Limit, Path)
```
The `X-Y` variables represent the initial position, the stack were the rock was placed. Given that the stack has to leave a rock behind after a move, the distance it will 'walk' is given by the `PileSize1`. After that the boundaries of the board need to be established. The board is always a N x N matrix, therefore the boundarie is always from 0 up to N(not inclusive). The `dfs` predicate is an utility that emulates a graph within the board and aplies the dfs algorithm on it. From the start position it will choose a valid direction(respects the limits established) to walk and recursively calculate the path. It is usefull to store previous visited positions to assure the stack never comesback to a already visited position.  

------------------

### **Endgame**

The game ends whenever one of the players manages to get a 4-stone row or column of theirs stones in the top view of the board.

In order to verify that, we sweep each row and column to find any combination of 4 stacks in a row that have the same head. 

If the players run out of stones before reaching the winning state, the game ends in a draw. Another draw scenario is if a player, accidently or not, makes a row but at the same time completes the opponents row aswell.

The `verify_end(+Board, +Piece)` predicate was implemented as follows:
```
verify_end(Board, Piece):- verify_columns(Board, Piece).
verify_end(Board, Piece):- verify_rows(Board, Piece).
```

Were the `verify_rows(+Board, +Piece)` predicate is true if atleast one row of the `+Board`, verifies that the top of each cell is equal to `+Piece`.

The `verify_columns(+Board, +Piece)` predicate calls `verify_rows` on the transpose of the `+Board`.

The `game_loop(+GameState)` predicate will evaluate each player's piece before every play with the `verify_end` predicate, in case a player wins, the congratulations message gets promped.

------------------

### **Board Evaluation**

In order to evaluate the board, three pillars are established

- A board were the user wins is always worth 100000 points;
- A board were the enemy wins is worth 0 points;
- For anything in between, the score is given by the number of cells in the board where, the top piece is equal to the player's piece.   


The `board_score(+Board, +Piece, -Score)` was implemented as follows:
```Prolog
board_score(Board, Piece, 0):-
	opposite_piece(Piece, EnemyPiece),
	verify_end(NewBoard, EnemyPiece).
	
board_score(Board, Piece, 100000):-
	verify_end(NewBoard, Piece).

board_score(Board, Piece, Score):-
	count_top_pieces(NewBoard, Piece, Score).
```
------------------

### **Computer Plays**

Depending on the level of the computer, we use different strategies to generate automated plays.

- random computer

Simply generate all possible moves using `valid_moves` predicate and select a random move from the list using `random_member` predicate imported from the `random` library. 

- greedy computer

After generating all valid moves, using the predicate `setof`, we collect and order all the (move-score) pair. For each move, we get the resulting Board, and using the `board_score` predicate, calculate the score of the resulting board. In the end we select the move with the highest score. If there are multiple moves with max score select a random move from that group of max scores.      


The `board_score(+Board, +Piece, -Score)` was implemented as follows:

```Prolog
choose_move(Board, player(_, 'cr', _, _), Move):-
	valid_moves(Board, List),
	random_member(Move, List).
	
choose_move(Board, player(_, 'cg', Piece, _), BestMove):-
	valid_moves(Board, Moves),
	setof(Score-Move, (member(Move, Moves), move_score(Board, Move, Piece, Score)), Set),
	best_move(Set, BestMove).
```

The first `choose_move` predicate corresponds to the computer random type. The second one corresponds to the computer greedy type.

------------------

## **Conclusions**

Overall there were four main points we would like to speak off:

Due to misinformation during initial research about the game, we ended up failing to follow some of the original rules. Winning by diagonal was not something we considered. When the stack moves, even thought
it can not return to the previous position, it can circle it's way back to a previous position as long as the path is indirect, ironically the solution for this problem is simpler, as we would only need to ensure the new position of the stack was not equal to the previous one. The visual representation of the game was lacking some important imformation that could help the user visualize the state of the game.
And finally, the game was made to support different board sizes, but in the end, for the same reason as with the other issues we were out of time to implement these functionalities.  

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

