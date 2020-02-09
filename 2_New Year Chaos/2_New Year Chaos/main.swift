//
//  main.swift
//  2_New Year Chaos
//
//  Created by Oleksander on 09.02.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation

func minimumBribes(q: [Int]) -> Void {
    guard q.count > 1 else { print(0); return }
    var sumVzatok = 0
    var vzatka = 0
    var vzatka2Flag = false
    var varNegArr = [Int]()
    
    for (i, v) in q.enumerated() {
        vzatka = v - i - 1
        if vzatka > 2 { print("Too chaotic"); return }
        if vzatka > 0 {
            sumVzatok = sumVzatok + vzatka
            if vzatka == 2 { vzatka2Flag = true }
            else { vzatka2Flag = false}
        }
        else {
            if vzatka == 0 {
                if vzatka2Flag {
                    sumVzatok = sumVzatok + 1
                }
            }
            else {
                if varNegArr.count < 1 {
                    varNegArr.append(v)
                }
                else {
                    varNegArr.insert(v, at: 0)
                    if varNegArr[0] < varNegArr[1] {
                        var i = 1
                        while i < varNegArr.count  {
                            if varNegArr[0] < varNegArr[i] {
                                sumVzatok = sumVzatok + 1
                            }
                            else {
                                break
                            }
                            i = i + 1
                        }
                        varNegArr.removeAll()
                    }
                }
            }
            vzatka2Flag = false
        }
    }
    print(sumVzatok)
}

var q = [1, 2, 5, 3, 7, 8, 6, 4]

minimumBribes(q:q)


