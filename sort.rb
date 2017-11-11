testArray = [36, 7, 4, 11, 8, 3, 21, 5]
puts 'The array is ' + testArray.to_s


#copies an array into another so that they don't share a pointer
def copyArr(arr)
    temp = []
    for el in arr
        temp.push(el)
    end
    return temp
end


#SELECTION SORT
def selection(a)
    arr = copyArr(a)
    puts 'Running selection sort on array: ' + arr.to_s
    newArray = []
    n = arr.length-1
    #check the array from 0 to length-1 for the min, swap the min with the last element of the array
    #then check the array 0 to length-2 for the next min, etc.
    #at each step, push the min onto the new array, which is returned at the end
    while n >= 0
        min = yield(arr, n)
        newArray.push(arr[min])
        temp = arr[n]
        arr[n] = arr[min]
        arr[min] = temp
        n = n - 1
    end
    newArray
end

#this block finds the min and returns its index
selectionSortedArray = selection(testArray) do |arr, n|
    i = 0
    min = arr[0]
    minIndex = 0
    while i <= n
        if arr[i] < min
            min = arr[i]
            minIndex = i
        end
        i = i + 1
    end
    minIndex
end

puts "Selection sorted array: " + selectionSortedArray.to_s



#INSERTION SORT
def insertion(arr)
    puts 'Running insertion sort on array: ' + arr.to_s
    newArray = []
    #build the sorted array in newArray
    #push the first element of arr onto newArray. By itself, it is sorted
    #push the next element of arr onto newArray
    #the block then performs swaps to put the element in the correct position in the sorted array
    for el in arr
        newArray.push(el)
        newArray = yield newArray
    end
    newArray
end

#this block puts the pushed element into the correct position by swapping
insertionSortedArray = insertion(testArray) do |arr|
    i = arr.length-1
    while i > 0 do
        if arr[i] < arr[i-1]
            temp = arr[i-1]
            arr[i-1] = arr[i]
            arr[i] = temp
        end
        i = i-1
    end
    arr
end

puts 'Insertion sorted array: ' + insertionSortedArray.to_s


#MERGE SORT
#This mergesort only works for lists with lengths that are powers of 2
def mergeSort(arr)
    puts "Running merge sort on array: " + arr.to_s
    temp = copyArr(arr)
    #this block determines what the subproblems that should be merged are
    splitMerge(temp, 1, arr) do |a, t, n|
        if n == 1
            return a
        end
        jump = a.length/n
        i = 0
        while i < a.length
            lo = i
            mid = (i + jump) - 1
            hi = mid + jump
            merge(a, lo, mid, hi, t)
            i = i + (jump*2)
        end
        t
    end
end

#n is the number of subproblems - starts as 1, and is multiplied by 2 
#until n = length of the array i.e. each subproblem is one element
def splitMerge(temp, n, arr, &block)
    if n == arr.length
        return yield(arr, temp, n) #first yield evaluated in the recursion
    end
    return yield(splitMerge(arr, n*2, temp, &block), temp, n) #recur in the yield statement
end

#merges subproblems into one list
def merge(arr, lo, mid, hi, temp)
    counterOne = lo
    counterTwo = mid+1
    i = lo
    while i <= hi
        if counterOne == mid+1 || (counterTwo <= hi && arr[counterOne] > arr[counterTwo])
            temp[i] = arr[counterTwo]
            counterTwo = counterTwo + 1
        else
            temp[i] = arr[counterOne]
            counterOne = counterOne + 1
        end
        i = i+1
    end
end

puts 'Merge sorted array: ' + mergeSort(testArray).to_s