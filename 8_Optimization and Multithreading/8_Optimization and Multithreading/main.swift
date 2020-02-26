//
//  main.swift
//  8_Optimization and Multithreading
//
//  Created by Oleksander on 25.02.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation

// ---- One Thread -------

func binSum(list: [Int], _ i: Int, _ j: Int) -> (Int, Int, Int) {
    guard i < j else {
        guard i == j else { return (0, 0, 0) }
            return (list[i], i, list[i])
    }
    let mid = Int((i + j) / 2)
    let (lBinSum, lIndexSum, lItemSum) = binSum(list: list, i, mid - 1)
    let (rBinSum, rIndexSum, rItemSum) = binSum(list: list, mid + 1, j)
    let lsum = lIndexSum  &+ mid &+ rIndexSum
    let sumItem = lItemSum &+ list[mid] &+ rItemSum
    let rsum = list[mid] &+ sumItem
    
    return (lsum &* (i &* lBinSum &+ j &* rBinSum) &+ rsum &* (j &* lBinSum &+ i &* rBinSum), lsum, sumItem)
}

func binSum(list: [Int]) -> Int {
    let (lBinSum, _, _) = binSum(list: list, 0, list.count - 1)
    return lBinSum
}

//  ---------  multy Thread -----------


func binSumMultyTred(list: [Int], _ i: Int, _ j: Int, queue: OperationQueue, blocksSize: Int) -> (Int, Int, Int) {
    guard i < j else {
        guard i == j else { return (0, 0, 0) }
            return (list[i], i, list[i])
    }
    let mid = Int((i + j) / 2)

    var lBinSum: Int
    var lIndexSum: Int
    var lItemSum: Int
    var rBinSum: Int
    var rIndexSum: Int
    var rItemSum: Int
    
    if j - i > blocksSize {
        let (typlBinSum, typlIndexSum, typlItemSum) = binSumMultyTred(list: list, i, mid - 1, queue: queue, blocksSize: blocksSize)
        let (typrBinSum, typrIndexSum, typrItemSum) = binSumMultyTred(list: list, mid + 1, j, queue: queue, blocksSize: blocksSize)
        
        lBinSum = typlBinSum
        lIndexSum = typlIndexSum
        lItemSum = typlItemSum
        rBinSum = typrBinSum
        rIndexSum = typrIndexSum
        rIndexSum = typrIndexSum
        rItemSum = typrItemSum
    }
    else {
        let (typlBinSum, typlIndexSum, typlItemSum) = binSum(list: list, i, mid - 1)
        let (typrBinSum, typrIndexSum, typrItemSum) = binSum(list: list, mid + 1, j)
        lBinSum = typlBinSum
        lIndexSum = typlIndexSum
        lItemSum = typlItemSum
        rBinSum = typrBinSum
        rIndexSum = typrIndexSum
        rIndexSum = typrIndexSum
        rItemSum = typrItemSum
    }
    
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
    
    let lsum = lIndexSum  &+ mid &+ rIndexSum
    let sumItem = lItemSum &+ list[mid] &+ rItemSum
    let rsum = list[mid] &+ sumItem
    
    return (lsum &* (i &* lBinSum &+ j &* rBinSum) &+ rsum &* (j &* lBinSum &+ i &* rBinSum), lsum, sumItem)
}

func binSum(list: [Int], in numberOfThreads: Int) -> Int {
    let blocksSize = list.count / numberOfThreads / 2
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = numberOfThreads
    let (lBinSum, _, _) = binSumMultyTred(list: list, 0, list.count - 1, queue: queue, blocksSize: blocksSize)

    return lBinSum
}


//====================Old version ===================================================
func binSumOld(list: [Int], _ i: Int, _ j: Int) -> Int {
    guard i < j else {
        guard i == j else { return 0 }
        return list[i]
    }
    let mid = (i + j) / 2
    let lsum = (i...j).reduce(0) { return $0 &+ $1 }
    let rsum = list[i...j].reduce(list[mid], { return $0 &+ $1 })

    return lsum &* (i &* binSumOld(list: list, i, mid - 1) &+ j &* binSumOld(list: list, mid + 1, j)) &+
        rsum &* (j &* binSumOld(list: list, i, mid - 1) &+ i &* binSumOld(list: list, mid + 1, j))
}

func binSumOld(list: [Int]) -> Int {
    return binSumOld(list: list, 0, list.count - 1)
}

//==================== Test ==========================
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
    let rNew = binSum(list: pt)
    tNew = Date().timeIntervalSince(date)
    s = s + Double(tNew)
    print("-------------rNew= \(rNew) timeNew= \(tNew)")
    // ------ run Old true
    if (false) {
        date = Date()
        let r = binSum(list: pt)
        let t = Date().timeIntervalSince(date)
        print("r=\(r) rN=\(rNew) \( r == rNew) t=\(t)  tN=\(tNew)")
    }
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

