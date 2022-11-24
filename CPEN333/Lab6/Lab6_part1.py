#student name: Brendan Lai
#student number: 19241173

import multiprocessing
import random #is used to cause some randomness 
import time   #is used to cause some delay to simulate thinking or eating times

def philosopher(id: int, chopstick: list, chopsticksList: list): 
    """
       implements a thinking-eating philosopher
       id is used to identifier philosopher #id (id is between 0 to numberOfPhilosophers-1)
       chopstick is the list of semaphores associated with the chopsticks 
    """
    def eatForAWhile():   #simulates philosopher eating time with a random delay
        print(f"DEBUG: philosopher{id} eating")
        time.sleep(round(random.uniform(.1, .3), 2)) #a random delay (100 to 300 ms)
    
    def thinkForAWhile(): #simulates philosopher thinking time with a random delay
        print(f"DEBUG: philosopher{id} thinking")
        time.sleep(round(random.uniform(.1, .3), 2)) #a random delay (100 to 300 ms)

    for _ in range(6): #to make testing easier, instead of a forever loop we use a finite loop
            
        leftChopstick = id
        rightChopstick = (id + 1) % 5      #5 is number of philosophers
        
        hasEaten = False # boolean for managing if we have eaten in this iteration

        while not hasEaten:

            # Booleans for managing whether either left or right chopstick is acquirable
            leftAcquirable = chopsticksList[leftChopstick].acquire(block=False)
            rightAcquirable = chopsticksList[rightChopstick].acquire(block=False)
            
            # If both are free we then actually acquire left and right, eat, release, think
            if leftAcquirable and rightAcquirable:
                # Acquire the left and right chopsticks
                chopstick[leftChopstick].acquire()
                print(f"DEBUG: philosopher{id} has chopstick{leftChopstick}")
                chopstick[rightChopstick].acquire()
                print(f"DEBUG: philosopher{id} has chopstick{rightChopstick}")

                eatForAWhile()

                # Release the chopsticks (left & right) and also remove from the shared chopsticksList
                print(f"DEBUG: philosopher{id} is to release chopstick{rightChopstick}")
                chopstick[rightChopstick].release()
                chopsticksList[rightChopstick].release()

                print(f"DEBUG: philosopher{id} is to release chopstick{leftChopstick}")
                chopstick[leftChopstick].release()
                chopsticksList[leftChopstick].release()

                thinkForAWhile()

                hasEaten = True # Exit the while loop now that the philosopher has eaten in this iteration

            # if the left chopstick was acquired release it
            elif leftAcquirable:
                chopsticksList[leftChopstick].release()

            # if the right chopstick was acquired release it
            elif rightAcquirable:
                chopsticksList[rightChopstick].release()

            # if neither was acquired do nothing do nothing / "think"

if __name__ == "__main__":
    semaphoreList = list()          #this list will hold one semaphore per chopstick
    numberOfPhilosophers = 5

    # List will hold a lock for each chopstick used to guarantee its corresponding semaphore can be acquired
    chopsticksList = list() 

    for i in range(numberOfPhilosophers):             
        semaphoreList.append(multiprocessing.Semaphore(1))    #one semaphore per chopstick
        chopsticksList.append(multiprocessing.Lock()) # one lock per chopstick

    philosopherProcessList = list()
    for i in range(numberOfPhilosophers): #instantiate all processes representing philosophers
        philosopherProcessList.append(multiprocessing.Process(target=philosopher, args=(i, semaphoreList, chopsticksList)))
    for j in range(numberOfPhilosophers): #start all child processes
        philosopherProcessList[j].start()
    for k in range(numberOfPhilosophers): #join all child processes
        philosopherProcessList[k].join()