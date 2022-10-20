#student name: Brendan Lai
#student number: 19241173

import threading
import random #is used to cause some randomness 
import time   #is used to cause some delay in item production/consumption

class circularBuffer: 
    """ 
        This class implement a barebone circular buffer.
        Use as is.
    """
    def __init__ (self, size: int):
        """ 
            The size of the buffer is set by the initializer 
            and remains fixed.
        """
        self._buffer = [0] * size   #initilize a list of length size
                                    #all zeroed (initial value doesn't matter)
        self._in_index = 0   #the in reference point
        self._out_index = 0  #the out reference point

    def insert(self, item: int):
        """ 
            Inserts the item in the buffer.
            The safeguard to make sure the item can be inserted
            is done externally.
        """
        self._buffer[self._in_index] = item
        self._in_index = (self._in_index + 1) % SIZE

    def remove(self) -> int:
        """ 
            Removes an item from the buffer and returns it.
            The safeguard to make sure an item can be removed
            is done externally.
        """
        item = self._buffer[self._out_index]
        self._out_index = (self._out_index + 1) % SIZE
        return item

def producer() -> None:
    """
        Implement the producer function to be used by the producer thread.
        It must correctly use full, empty and mutex.
    """
    def waitForItemToBeProduced() -> int: #inner function; use as is
        time.sleep(round(random.uniform(.1, .3), 2)) #a random delay (100 to 300 ms)
        return random.randint(1, 99)  #an item is produced

    for _ in range(SIZE * 2): #we just produce twice the buffer size for testing
        item = waitForItemToBeProduced()  #wait for an item to be produced
        print(f"DEBUG: {item} produced")

        empty.acquire() # Acquire empty semaphore to verify enough space in buffer

        with mutex: #insert to buffer when mutex is acquired then release mutex by definition
            buffer.insert(item)

        full.release() # Release the full semaphore upon completion as item count is incremented (by 1)

def consumer() -> None:
    """
        Implement the consumer function to be used by the consumer thread.
        It must correctly use full, empty and mutex.
    """
    for _ in range(SIZE * 2): #we just consume twice the buffer size for testing
        
        full.acquire() # Acquire full semaphore ensuring at least 1 item is in the buffer before moving on

        with mutex: # Acquire lock and then item gets removed item from buffer. mutex released by 
            item = buffer.remove()

        empty.release() # Release the empty semaphore as number of items has decremented (by 1)

        #use the following code as is
        def waitForItemToBeConsumed(item) -> None: #inner function; use as is
            time.sleep(round(random.uniform(.1, .3), 2)) #a random delay (100 to 300 ms)
            #to simulate consumption, item is thrown away here by just ignoring it
        waitForItemToBeConsumed(item)  #wait for the item to be consumed
        print(f"DEBUG: {item} consumed")

if __name__ == "__main__":
    SIZE = 5  #buffer size
    buffer = circularBuffer(SIZE)  #initialize the buffer

    full = threading.Semaphore(0)         #full semaphore: number of full buffers
                                          #initial value set to 0
    empty = threading.Semaphore(SIZE)     #empty semaphore: number of empty buffers
                                          #initial value set to SIZE
    mutex = threading.Lock()  #lock for protecting data on insertion or removal
    
    # Producer-consumer threads created, started, and completed below
    producerThread = threading.Thread(target=producer)
    consumerThread = threading.Thread(target=consumer)

    producerThread.start()
    consumerThread.start()

    producerThread.join()
    consumerThread.join()
