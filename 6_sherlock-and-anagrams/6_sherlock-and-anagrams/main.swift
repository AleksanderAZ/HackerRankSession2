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
    for prefSub in 1...countS {
        let pString = s.prefix(prefSub)
        let countSubPref = pString.count
        for suffSub in 1...countSubPref {
            let countSubSuffix = countS - prefSub + suffSub
            if countSubSuffix < suffSub { break }
            let spString = pString.suffix(suffSub)
            let sString = s.suffix(countSubSuffix)
            for rangeFind in 0...(countSubSuffix-suffSub) {
                var findSString = String(sString.suffix(countSubSuffix-rangeFind).prefix(suffSub))
                var flagFind = true
                for c in String(spString) {
                    if let index = findSString.firstIndex(of: c) {
                        let count = findSString.count
                        let distans = findSString.distance(from: findSString.startIndex, to: index)
                        let l = String(findSString.prefix(distans))
                        let r = String(findSString.suffix(count - distans - 1))
                        findSString = String(l + r)
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

let s = "cdavcd"
print(sherlockAndAnagrams(s: s))
