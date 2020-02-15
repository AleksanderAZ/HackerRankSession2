//
//  main.swift
//  7_two-pluses
//
//  Created by Oleksander on 14.02.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation

func twoPluses(grid: [String]) -> Int {

    let nR = grid.count - 1
    guard nR > -1 else { return 0 }
    guard nR > 0 else { return 0 }
    let mC = grid[0].count - 1
    guard mC > -1 else { return 0 }
    var linePlus = [Int]()
    var rPlus = [Int]()
    var cPlus = [Int]()
    var maxFindPlus: Int = 0
    let startIndex = grid[0].startIndex
    var r = 1
    var c = 1
    while (r < nR) {
        c = 1
        while (c < mC) {
            if grid[r][grid[r].index(startIndex, offsetBy: c)] == "G" {
                maxFindPlus = 1
                var ru = r - 1
                var rd = r + 1
                var cl = c - 1
                var cr = c + 1
                while (ru >= 0 && rd <= nR && cl >= 0 && cr <= mC) {
                    if (grid[ru][grid[ru].index(startIndex, offsetBy: c)] == "G" &&  grid[rd][grid[rd].index(startIndex, offsetBy: c)] == "G" && grid[r][grid[r].index(startIndex, offsetBy: cl)] == "G" && grid[r][grid[r].index(startIndex, offsetBy: cr)] == "G") {
                        maxFindPlus += 1
                    }
                    else {
                        break
                    }
                    ru = ru - 1
                    rd = rd + 1
                    cl = cl - 1
                    cr = cr + 1
                }
                linePlus.append(1)
                rPlus.append(r)
                cPlus.append(c)
                if (maxFindPlus > 1) {
                    var i = 0
                    while (i < linePlus.count) {
                        if linePlus[i] < maxFindPlus {
                            break
                        }
                        i += 1
                    }
                    linePlus.insert(maxFindPlus, at: i)
                    rPlus.insert(r, at: i)
                    cPlus.insert(c, at: i)
                }
            }
            c += 1
        }
        r += 1
    }
    for i in 0...mC {
        if grid[0][grid[0].index(startIndex, offsetBy: i)] == "G" {
            linePlus.append(1)
            rPlus.append(0)
            cPlus.append(i)
        }
        if grid[nR][grid[nR].index(startIndex, offsetBy: i)] == "G" {
            linePlus.append(1)
            rPlus.append(nR)
            cPlus.append(i)
        }
    }
    for i in 0...nR {
        if grid[i][grid[i].index(startIndex, offsetBy: 0)] == "G" {
            linePlus.append(1)
            rPlus.append(i)
            cPlus.append(0)
        }
        if grid[i][grid[i].index(startIndex, offsetBy: mC)] == "G" {
            linePlus.append(1)
            rPlus.append(i)
            cPlus.append(mC)
        }
    }
    var maxMult = 0
    var mult = 0
    r = 0
    while(r < linePlus.count - 1) {
        while (linePlus[r] >= 1) {
            let lOne = linePlus[r] - 1
            let rOne = rPlus[r]
            let cOne = cPlus[r]
            let luROne = rOne - lOne
            let luCOne = cOne - lOne
            let ldROne = rOne + lOne
            let ruCOne = cOne + lOne
            c = r + 1
            while(c < linePlus.count) {
                var linePlus = linePlus[c]
                let rTwo = rPlus[c]
                let cTwo = cPlus[c]
                c += 1
                while (linePlus >= 1) {
                    let lTwo = linePlus - 1
                    let luRTwo = rTwo - lTwo
                    let luCTwo = cTwo - lTwo
                    let ldRTwo = rTwo + lTwo
                    let ruCTwo = cTwo + lTwo
                    linePlus -= 1
                    if (rTwo == rOne && (luCTwo >= luCOne &&  luCTwo <= ruCOne || ruCTwo >= luCOne && ruCTwo <= ruCOne)) {
                        continue
                    }
                    if (cTwo == cOne && (luRTwo >= luROne &&  luRTwo <= ldROne || ldRTwo >= luROne && ldRTwo <= ldROne)) {
                        continue
                    }
                    if (rOne >= luRTwo && rOne <= ldRTwo && cTwo >= luCOne  && cTwo <= ruCOne) {
                        continue
                    }
                    if (rTwo >= luROne && rTwo <= ldROne && cOne >= luCTwo && cOne <= ruCTwo) {
                        continue
                    }
                    mult = (lOne * 4 + 1)  * (lTwo * 4 + 1)
                    if (maxMult < mult) {maxMult = mult}
                }
            }
            linePlus[r] -= 1
        }
        r += 1
    }
    return maxMult
}

//------Test-------

let grid = ["BGBBGB",
            "GGGGGG",
            "BGBBGB",
            "GGGGGG",
            "BGBBGB",
            "BGBBGB"]

let grid2 = ["GGGGGG",
             "GBBBGB",
             "GGGGGG",
             "GGBBGB",
             "GGGGGG"]

let grid1 = ["BBBBBB",
             "BBBBGB",
             "BBBGGG",
             "BBBBGB",
             "BBBBBB"]

let g = ["GGGGGGGG",
         "GBGBGGBG",
         "GBGBGGBG",
         "GGGGGGGG",
         "GBGBGGBG",
         "GGGGGGGG",
         "GBGBGGBG",
         "GGGGGGGG"]

let g1 = [  "GGGGGGGGGGGG",
            "GBGGBBBBBBBG",
            "GBGGBBBBBBBG",
            "GGGGGGGGGGGG",
            "GGGGGGGGGGGG",
            "GGGGGGGGGGGG",
            "GGGGGGGGGGGG",
            "GBGGBBBBBBBG",
            "GBGGBBBBBBBG",
            "GBGGBBBBBBBG",
            "GGGGGGGGGGGG",
            "GBGGBBBBBBBG"]

let g2 = [  "GGGGGGGGGGGG",
            "G xG       G",
            "G xG       G",
            "xxxxxGGGGGGG",
            "GGxoGGGGGGGG",
            "GGxoGGGGGGGG",
            "GoooooGGGGGG",
            "G Go       G",
            "G Go       G",
            "G GG       G",
            "GGGGGGGGGGGG",
            "G GG       G"]

print(twoPluses(grid: grid))
print(twoPluses(grid: grid1))
print(twoPluses(grid: grid2))
print(twoPluses(grid: g))
print(twoPluses(grid: g1))
