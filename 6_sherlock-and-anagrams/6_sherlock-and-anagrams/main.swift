//
//  main.swift
//  6_sherlock-and-anagrams
//
//  Created by Oleksander on 16.02.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation

func sherlockAndAnagrams(s: String) -> Int {
    
    let countS = s.count - 1
    var sumCount = 0
    
    var findString = s
    
    while findString.count > 1 {
        var sum = 0
        var number = 0
        let p = findString.removeFirst()
        while let index = findString.firstIndex(of: p) {
            findString.remove(at: index)
            number += 1
            sum = sum + number
        }
        sumCount = sumCount + sum
    }
    
    for prefSub in 2...countS {
        for suffSub in 2...prefSub {
            let countSubSuffix = countS - prefSub + suffSub
            for rangeFind in 0...(countS - prefSub) {
                var findSString = s.suffix(countSubSuffix-rangeFind).prefix(suffSub)
                var flagFind = true
                for c in s.prefix(prefSub).suffix(suffSub) {
                    if let index = findSString.firstIndex(of: c) {
                        findSString.remove(at: index)
                    }
                    else {
                        flagFind = false
                        break
                    }
                }
                if flagFind == true {
                    sumCount = sumCount + 1
                }
            }
        }
    }
    return sumCount
}

func sherlockAndAnagrams1(s: String) -> Int {
    
    let countS = s.count - 1
    var sumCount = 0
    
    for prefSub in 1...countS {
        for suffSub in 1...prefSub {
            let countSubSuffix = countS - prefSub + suffSub
            for rangeFind in 0...(countS - prefSub) {
                var findSString = s.suffix(countSubSuffix-rangeFind).prefix(suffSub)
                var flagFind = true
                for c in s.prefix(prefSub).suffix(suffSub) {
                    if let index = findSString.firstIndex(of: c) {
                        findSString.remove(at: index)
                    }
                    else {
                        flagFind = false
                        break
                    }
                }
                if flagFind == true {
                    sumCount = sumCount + 1
                }
            }
        }
    }
    return sumCount
}
let s = "aaaa"
print(sherlockAndAnagrams(s: s))
print(sherlockAndAnagrams1(s: s))
