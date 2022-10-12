#student name: Brendan Lai
#student number: 19241173

import threading

def sortingWorker(firstHalf: bool) -> None:
    """
       If param firstHalf is True, the method
       takes the first half of the shared list testcase,
       and stores the sorted version of it in the shared
       variable sortedFirstHalf.
       Otherwise, it takes the second half of the shared list
       testcase, and stores the sorted version of it in
       the shared variable sortedSecondHalf.
       The sorting is ascending and you can choose any
       sorting algorithm of your choice and code it.
    """

    def sortImplementation(arr):
        """
            This function is a helper method to sort the arrays
            It takes one argument (arr) and returns arr which are both lists
            The method implements the bubble sort algorithm
        """
        n = len(arr)

        # Iterate over whole array
        for i in range(n):
            # Flag telling us if array has been sorted
            # If there was no swap in an iteration then array has been sorted
            isSorted = True 
            
            # look at the list one by one comparing adjacent values
            for j in range(n - i - 1):

                # If the current item is greater than adjacent (right sided next item)
                # Then swap the two elements
                if arr[j] > arr[j+1]:
                    arr[j], arr[j+1] = arr[j + 1], arr[j]
                    isSorted = False # Swap occurred therefore algorithm incomplete

            # If no swap has occurred then list has been completely sorted
            if isSorted:
                break

        return arr

    halfTestcaseLen = len(testcase) // 2
    global sortedFirstHalf
    global sortedSecondHalf

    if firstHalf:
        sortedFirstHalf = sortImplementation(testcase[0:halfTestcaseLen])
    else:
        sortedSecondHalf = sortImplementation(testcase[halfTestcaseLen: halfTestcaseLen * 2])

    

def mergingWorker() -> None:
    """ This function uses the two shared variables
        sortedFirstHalf and sortedSecondHalf, and merges/sorts
        them into a single sorted list that is stored in
        the shared variable sortedFullList.
    """
    global SortedFullList

    i, j = 0, 0
    n = len(testcase) / 2
    
    while i < n and j < n:
        if sortedFirstHalf[i] < sortedSecondHalf[j]:
            SortedFullList.append(sortedFirstHalf[i])
            i += 1
        else:
            SortedFullList.append(sortedSecondHalf[j])
            j += 1

    # Once either first or second half list is completed append the remaining sorted half array to end
    SortedFullList = SortedFullList + sortedFirstHalf[i:] + sortedSecondHalf[j:]


if __name__ == "__main__":
    #shared variables
    testcase = [8,-1,-5,7,3,4,1,3,2,8,-10, -33, 20, 30]
    sortedFirstHalf: list = []
    sortedSecondHalf: list = []
    SortedFullList: list = []
    
    #to implement the rest of the code below, as specified
    t1 = threading.Thread(target=sortingWorker, kwargs={"firstHalf": True,})
    t2 = threading.Thread(target=sortingWorker, kwargs={"firstHalf": False,})
    t1.start()
    t2.start()
    t1.join()
    t2.join()

    t3 = threading.Thread(target=mergingWorker)
    t3.start()
    t3.join()

    #as a simple test, printing the final sorted list
    print("The final sorted list is ", SortedFullList)