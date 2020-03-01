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

class BinSumMultyTred {
    
    typealias ListType = UnsafeMutablePointer<Int>
    
    private var queue: OperationQueue
    private var list: ListType
    private let blockSize: Int
    private let count: Int
    
    private init(list: [Int], in queue: OperationQueue, blockSize: Int) {
        self.list = UnsafeMutablePointer(mutating: list)
        self.count = list.count
        self.blockSize = blockSize
        self.queue = queue
    }
        
    static private func binSumOne(list: inout ListType, _ i: Int, _ j: Int) -> (Int, Int, Int) {
        guard i < j else {
            guard i == j else { return (0, 0, 0) }
            return (list[i], i, list[i])
        }
        let mid = Int((i + j) / 2)
        let (lBinSum, lIndexSum, lItemSum) = binSumOne(list: &list, i, mid - 1)
        let (rBinSum, rIndexSum, rItemSum) = binSumOne(list: &list, mid + 1, j)
        let lsum = lIndexSum  &+ mid &+ rIndexSum
        let sumItem = lItemSum &+ list[mid] &+ rItemSum
        let rsum = list[mid] &+ sumItem

        return (lsum &* (i &* lBinSum &+ j &* rBinSum) &+ rsum &* (j &* lBinSum &+ i &* rBinSum), lsum, sumItem)
    }

    private func binSumMultyTred( _ i: Int, _ j: Int,  complit: @escaping (Int, Int, Int)-> Void)  -> Operation {
        
        guard i < j else {
            guard i == j else {
                let mergeOperation = BlockOperation {
                    complit(0, 0, 0)
                }
                return mergeOperation
            }
            let itemMid = list[i]
            let mergeOperation = BlockOperation {
                complit(itemMid, i, itemMid)
            }
            return mergeOperation
        }

        let mid = Int((i + j) / 2)
        
        if (blockSize > j - i ) {
            let mergeOperation = BlockOperation {
                let (lBinSum, lIndexSum, lItemSum) = BinSumMultyTred.binSumOne(list: &self.list, i, j)

                complit(lBinSum, lIndexSum, lItemSum)
            }
            
            return mergeOperation
        }
        else {
            var lBinSum: Int = 0
            var lIndexSum: Int = 0
            var lItemSum: Int = 0
            var rBinSum: Int = 0
            var rIndexSum: Int = 0
            var rItemSum: Int = 0
            let itemMid = self.list[mid]
            
            let left = binSumMultyTred( i, mid - 1) { (typlBinSum, typlIndexSum, typlItemSum) in
                lBinSum = typlBinSum
                lIndexSum = typlIndexSum
                lItemSum = typlItemSum
            }
            
            let right = binSumMultyTred( mid + 1, j) { (typrBinSum, typrIndexSum, typrItemSum) in
                rBinSum = typrBinSum
                rIndexSum = typrIndexSum
                rItemSum = typrItemSum
            }
            
            let mergeOperation = BlockOperation {
                let lsum = lIndexSum  &+ mid &+ rIndexSum
                let sumItem = lItemSum &+ itemMid &+ rItemSum
                let rsum = itemMid &+ sumItem
                let binSum  = (lsum &* (i &* lBinSum &+ j &* rBinSum) &+ rsum &* (j &* lBinSum &+ i &* rBinSum))

                complit(binSum, lsum, sumItem)
            }
            
            queue.addOperation(left)
            queue.addOperation(right)
            
            mergeOperation.addDependency(left)
            mergeOperation.addDependency(right)
            
            return mergeOperation
        }
    }

    static func binSum(list: [Int], in queue: OperationQueue, blockSize: Int) -> Int {
        let count = list.count
        let binSumMultyTred = BinSumMultyTred(list: list, in: queue, blockSize: blockSize)
        var binSum = 0
        let left = binSumMultyTred.binSumMultyTred(0, count - 1) { (typlBinSum, typlIndexSum, typlItemSum) in
            binSum = typlBinSum
        }
        queue.addOperation(left)
        queue.waitUntilAllOperationsAreFinished()
    
        return binSum
    }
}

func binSum(list: [Int], in numberOfThreads: Int) -> Int {
    let blockSize = (list.count - 1) / numberOfThreads
    
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = numberOfThreads

    return BinSumMultyTred.binSum(list: list, in: queue, blockSize: blockSize)
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
var date: Date
let len = 50000000
var pt = [Int]()
pt.reserveCapacity(len)
for _ in 0...len {
    pt.append(Int(arc4random_uniform(1000000000)))
}

// ------------ Optimization --------------------

date = Date()
let rNew = binSum(list: pt)
let tNew = Date().timeIntervalSince(date)
print("---- tN=\(tNew)  ")

// ----------------- Multithreading --------------

let cores = 4
date = Date()
let rNewMult = binSum(list: pt, in: cores)
let tNewMult = Date().timeIntervalSince(date)
print("---- tNewMult= \(tNewMult) ")

print("--------------- \n \( rNew == rNewMult) \n  tN=\(tNew) tNM=\(tNewMult) ")

// ----------------- Old version ------------------
/*
date = Date()
let r = binSumOld(list: pt)
let t = Date().timeIntervalSince(date)
print("--------------- \n \( r == rNew) \( rNew == rNewMult) \n t=\(t)  tN=\(tNew) tNM=\(tNewMult)")
*/
