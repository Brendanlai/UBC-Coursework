# student name: Brendan Lai
# student number: 19241173

# A command-line Tic-Tac-Toe game 
import random

board = [' '] * 9 # A list of 9 strings, one for each cell, 
                  # will contain ' ' or 'X' or 'O'
played = set()    # A set to keep track of the played cells 

def init() -> None:
    """ prints the banner messages 
        and prints the intial board on the screen
    """
    print("Welcome to Tic-Tac-Toe!")
    print("You play X (first move) and computer plays O.")
    print("Computer plays randomly, not strategically.")
    printBoard()

def printBoard() -> None:
    """ prints the board on the screen based on the values in the board list """
    print(f"\n{board[0]} | {board[1]} | {board[2]}    0 | 1 | 2")
    print("--+---+--    --+---+--")
    print(f"{board[3]} | {board[4]} | {board[5]}    3 | 4 | 5")
    print("--+---+--    --+---+--")
    print(f"{board[6]} | {board[7]} | {board[8]}    6 | 7 | 8\n")


def playerNextMove() -> None:
    """ prompts the player for a valid cell number, 
        and prints the info and the updated board;
        error checks that the input is a valid cell number 
    """
    playerMove = True
    while playerMove:
        try:
            # If input is not an integer an error is thrown when casting to int
            move = int(input("Next move for X (state a valid cell num): "))

            if move < 0 or move > 8 or move in played:
                print("Must enter a valid cell number")
            else:
                print(f"You chose cell {move}")
                board[move] = "X"
                played.add(move)
                playerMove = False
        except:
            print("Must be an integer")

    printBoard()
    

def computerNextMove() -> None:
    """ Computer randomly chooses a valid cell, 
        and prints the info and the updated board 
    """
    compMove = True
    while compMove:
        move = random.randint(0,8) # Gets random integer from 0 to 8 inclusive
        if move not in played:
            print(f"Computer chose cell {move}")
            board[move] = "O"
            played.add(move)
            compMove = False

    printBoard()


def hasWon(who: str) -> bool:
    """ returns True if who (being passed 'X' or 'O') has won, False otherwise """
    # Checks Rows
    if board[0] == who and board[1] == who and board[2] == who:
        return True
    elif board[3] == who and board[4] == who and board[5] == who:
        return True
    elif board[6] == who and board[7] == who and board[8] == who:
        return True
    # Checks Columns
    elif board[0] == who and board[3] == who and board[6] == who:
        return True
    elif board[1] == who and board[4] == who and board[7] == who:
        return True
    elif board[2] == who and board[5] == who and board[8] == who:
        return True
    # Checks Diagonals
    elif board[0] == who and board[4] == who and board[8] == who:
        return True
    elif board[6] == who and board[4] == who and board[2] == who:
        return True
    
    return False


def terminate(who: str) -> bool:
    """ returns True if who (being passed 'X' or 'O') has won or if it's a draw, False otherwise;
        it also prints the final messages:
                "You won! Thanks for playing." or 
                "You lost! Thanks for playing." or 
                "A draw! Thanks for playing."  
    """
    if hasWon(who):
        if who == "X":
            print("You won! Thanks for playing.") 
        else:
            print("You Lost! Thanks for playing.")
        
        return True

    # Check if draw (all cells are filled and no winner)
    if len(played) == 9:
        print("A Draw! Thanks for playing")
        return True

    return False


if __name__ == "__main__":
    # Use as is. 
    init()
    while True:
        playerNextMove()            # X starts first
        if(terminate('X')): break   # if X won or a draw, print message and terminate
        computerNextMove()          # computer plays O
        if(terminate('O')): break   # if O won or a draw, print message and terminate
