//
//  main.swift
//  8_Optimization and Multithreading
//
//  Created by Oleksander on 25.02.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation

func binSum(list: [Int], _ i: Int, _ j: Int) -> Int {
    guard i < j else {
        guard i == j else { return 0 }
        return list[i]
    }
    let mid = (i + j) / 2
    let lsum = (i...j).reduce(0) { return $0 &+ $1 }
    let rsum = list[i...j].reduce(list[mid], { return $0 &+ $1 })

    //print("i=\(i) j=\(j) mid=\(mid) lsum=\(lsum) rsum=\(rsum) ")
    return lsum &* (i &* binSum(list: list, i, mid - 1) &+ j &* binSum(list: list, mid + 1, j)) &+
        rsum &* (j &* binSum(list: list, i, mid - 1) &+ i &* binSum(list: list, mid + 1, j))
}

func binSum(list: [Int]) -> Int {
    return binSum(list: list, 0, list.count - 1)
}
//=======================================================================

func binSumNew(list: [Int], _ i: Int, _ j: Int) -> (Int, Int, Int) {
    
   // guard i < j else {
    //    guard i == j else { return (0, 0, 0) }
   //         return (list[i], i, list[i])
   // }
    let mid = Int((i + j) / 2)
    
    if i == mid {
        if i == j {
            return (list[j], j, list[j])
        }
        let lsum = mid &+ j
        let sumItem = list[mid] &+ list[j]
        //print("i=\(i) j=\(j) mid=\(mid) lsum=\(lsum) rsum=\(rsum) ----11111")
        return (lsum &* (j &* list[j]) &+ (list[mid] &+ sumItem) &* (i &* list[j]), lsum, sumItem)
    }
    
    let (lBinSum, lIndexSum, lItemSum) = binSumNew(list: list, i, mid - 1)
    let (rBinSum, rIndexSum, rItemSum) = binSumNew(list: list, mid + 1, j)
    let lsum = lIndexSum  &+ mid &+ rIndexSum
    let sumItem = lItemSum &+ list[mid] &+ rItemSum
    let rsum = list[mid] &+ sumItem
    //var result = 0
    //if (i == 0) {
    //    result = lsum &* (j &* rBinSum) &+ rsum &* (j &* lBinSum)
   // }
   // result = lsum &* (i &* lBinSum &+ j &* rBinSum) &+ rsum &* (j &* lBinSum &+ i &* rBinSum)
    
    //print("i=\(i) j=\(j) mid=\(mid) lsum=\(lsum) rsum=\(rsum) ")
    
    return (lsum &* (i &* lBinSum &+ j &* rBinSum) &+ rsum &* (j &* lBinSum &+ i &* rBinSum), lsum, sumItem)
}

func binSumNew(list: [Int]) -> Int {
    let (lBinSum, _, _) = binSumNew(list: list, 0, list.count - 1)
    return lBinSum
}

func binSumNew(list: [Int], in numberOfThreads: Int) -> Int {
    
    return 0
}

var date = Date()
let len = 10000000
let cores = 8
var pt = [Int]()
pt.reserveCapacity(len)
date = Date()
for _ in 0...len {
    pt.append(Int(arc4random_uniform(10)))
}
var tNew = Date().timeIntervalSince(date)
//print(pt, "------------start= \(tNew)")

var s = 0.0

for _ in 1...10 {
    date = Date()
    let rNew = binSumNew(list: pt)
    tNew = Date().timeIntervalSince(date)
    s = s + Double(tNew)
    print("-------------rNew= \(rNew) timeNew= \(tNew)")
    //date = Date()
  //  let r = binSum(list: pt)
   // let t = Date().timeIntervalSince(date)
   // print("r=\(r) rN=\(rNew) \( r == rNew) t=\(t)  tN=\(tNew)")
}
print("avarrage time =\(s/10)")

//---------------------------------------------

class MergeSort {
    typealias ListType = UnsafeMutablePointer<Int>
    
    private var queue: OperationQueue
    
    private var a: ListType
    private var b: ListType
    private let count: Int
    private let blockSize: Int
    
    private init(list: [Int], in queue: OperationQueue, blockSize: Int) {
        self.a = UnsafeMutablePointer(mutating: list)
        self.b = UnsafeMutablePointer(mutating: list)
        
        self.count = list.count
        self.blockSize = blockSize
        self.queue = queue
    }
    
    private func merge(_ isBuffer: Bool, _ i: Int, mid: Int, _ j: Int) {
       
    }
    
    static private func insertionSort(a: inout ListType, _ i: Int, _ j: Int) {
        guard i < j else {return}
        for k in i + 1...j {
            let value = a[k]
            var j = k - 1
            while j >= i && a[j] > value {
                a[j + 1] = a[j]
                j -= 1
            }
            a[j + 1] = value
        }
    }
    
    private func sortInOneThread(_ isBuffer: Bool, _ i: Int, _ j: Int) {
        guard j - i > 10 else {
            if !isBuffer {
                MergeSort.insertionSort(a: &self.a, i, j)
            } else {
                MergeSort.insertionSort(a: &self.b, i, j)
            }
            return
        }
        
        let mid = (i + j) / 2
        sortInOneThread(!isBuffer, i, mid)
        sortInOneThread(!isBuffer, mid + 1, j)
        
        merge(isBuffer, i, mid: mid, j)
    }
    
    private func sortInMultiThreads(_ isBuffer: Bool, _ i: Int, _ j: Int) -> Operation {
        guard j - i > blockSize else {
            return BlockOperation {
                self.sortInOneThread(!isBuffer, i, j)
            }
        }
        
        let mid = (i + j) / 2
        let left = sortInMultiThreads(!isBuffer, i, mid)
        let right = sortInMultiThreads(!isBuffer, mid + 1, j)
        queue.addOperation(left)
        queue.addOperation(right)
        
        let mergeOperation = BlockOperation {
            self.merge(isBuffer, i, mid: mid, j)
        }
        mergeOperation.addDependency(left)
        mergeOperation.addDependency(right)
        
        return mergeOperation
    }
    
    private func sortedList() -> [Int] {
        queue.addOperation(self.sortInMultiThreads(false, 0, self.count - 1))
        queue.waitUntilAllOperationsAreFinished()
        return Array(UnsafeBufferPointer<Int>(start: self.a, count: self.count))
    }
    
    static func sort(list: [Int], in queue: OperationQueue, blockSize: Int) -> [Int] {
        guard list.count > 1 else {return list}
        
        let mergeSort = MergeSort(list: list, in: queue, blockSize: blockSize)
        return mergeSort.sortedList()
    }
}

func sort(list: [Int], in cores: Int) -> [Int] {
    let blocksSize = list.count / cores
    
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = cores
    
    return MergeSort.sort(list: list, in: queue, blockSize: blocksSize)
}


/*
let len = 100
let cores = 8

var pt = [Int]()
pt.reserveCapacity(len)

for _ in 0...len {
    pt.append(Int(arc4random_uniform(100000000)))
}

var date = Date()
let mergedSorted = sort(list: pt, in: cores)
print("Swift merge sorting in \(cores) cores algorithm with time  \(Date().timeIntervalSince(date))")

date = Date()
pt = pt.sorted()
print("Swift standat sorting algorithm with time  \(Date().timeIntervalSince(date))")

if !pt.elementsEqual(mergedSorted) {
    print("Result is not matched")
}
*/
