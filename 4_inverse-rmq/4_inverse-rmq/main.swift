//
//  main.swift
//  4_inverse-rmq
//
//  Created by Oleksander on 01.03.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation

func inverse_rmq(strCount: String, strArrayInt: String) {
    
    guard let count = Int(strCount) else { print("NO"); return }
    let arrSrt = strArrayInt.split(separator: " ")
    var arrInt = [Int]()
    var result = ""
    for v in arrSrt {
        guard let i = Int(v) else { print("NO"); return }
        arrInt.append(i)
    }
    arrInt.sort()
    let min = arrInt[0]
    var i = arrInt.index(before: arrInt.endIndex)
    var countDubl = 0
    
    while (i > arrInt.startIndex) {
        let ibefore = arrInt.index(before: i)
        if arrInt[i] == arrInt[ibefore] {
            countDubl += 1
            var flagEnd = true
            if arrInt[i] == min {
                var ie = ibefore
                while ie > arrInt.startIndex {
                    let iebefore = arrInt.index(before: ie)
                    if arrInt[ie] == arrInt[iebefore] {
                        countDubl += 1
                        if countDubl >= count {
                            print("NO")
                            return
                        }
                    }
                    else {
                        flagEnd = false
                        break
                    }
                    arrInt.insert(arrInt.remove(at: ie), at: 0)
                    ie = arrInt.index(before: ie)
                }
            }
            else {
                flagEnd = false
            }
            if flagEnd {
                break
            }
            else {
                if countDubl >= count {
                    print("NO")
                    return
                }
                arrInt.insert(arrInt.remove(at: ibefore), at: 0)
            }
        }
        else {
            countDubl = 0
            i = arrInt.index(before: i)
        }
    }
    
    for i in arrInt {
        result = result + String(i) + " "
    }
    result.removeLast()
    print("YES")
    print(result)
}


inverse_rmq(strCount: "4", strArrayInt: "3 1 3 1 2 4 1")
inverse_rmq(strCount: "2", strArrayInt: "1 1 1")


/*  4   3 1 3 1 2 4 1   --  YES   1 1 3 1 2 3 4 */

