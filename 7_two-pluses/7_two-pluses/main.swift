//
//  main.swift
//  7_two-pluses
//
//  Created by Oleksander on 14.02.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation

func twoPluses(grid: [String]) -> Int {
    struct PointPlus {
        var r: Int = 0
        var c: Int = 0
    }
    let n = grid.count - 1
    guard n > -1 else { return 0 }
    guard n > 0 else {
        return 0
    }
    let m = grid[0].count - 1
    guard m > -1 else { return 0 }
    var linePlus = [Int]()
    var rPlus = [Int]()
    var cPlus = [Int]()
    var maxFindPlus: Int = 0
    
    
    var r = 1
    var c = 1
    
    while (r < n) {
        while (c < m) {
            if grid[r][grid[r].index(grid[r].startIndex, offsetBy: c)] == "G" {
                maxFindPlus = 1
                var ru = r - 1
                var rd = r + 1
                var cl = c - 1
                var cr = c + 1
                while (ru >= 0 && rd <= n && cl >= 0 && cr <= m) {
                    if (grid[ru][grid[ru].index(grid[ru].startIndex, offsetBy: c)] == "G" &&  grid[rd][grid[rd].index(grid[rd].startIndex, offsetBy: c)] == "G" && grid[r][grid[r].index(grid[r].startIndex, offsetBy: cl)] == "G" && grid[r][grid[r].index(grid[r].startIndex, offsetBy: cr)] == "G") {
                        maxFindPlus += 1
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
    c = 0
    while (c <= m) {
        if grid[0][grid[0].index(grid[0].startIndex, offsetBy: c)] == "G" {
            linePlus.append(1)
            rPlus.append(0)
            cPlus.append(c)
        }
        if grid[n][grid[n].index(grid[n].startIndex, offsetBy: c)] == "G" {
            linePlus.append(1)
            rPlus.append(n)
            cPlus.append(c)
        }
        c += 1
    }
    r = 1
    while (r <= n) {
        if grid[r][grid[r].index(grid[r].startIndex, offsetBy: 0)] == "G" {
            linePlus.append(1)
            rPlus.append(r)
            cPlus.append(0)
        }
        if grid[r][grid[r].index(grid[r].startIndex, offsetBy: m)] == "G" {
            linePlus.append(1)
            rPlus.append(r)
            cPlus.append(m)
        }
        r += 1
    }

    
    r = 0
    var mult = 0
    
    while(r < linePlus.count - 1) {
        c = r + 1
        while(c < linePlus.count) {
            
            
            
            c += 1
        }
        r += 1
    }
    
    
    print(linePlus)
    print(rPlus)
    print(cPlus)
    
    return 0
}

let grid = ["BGBBGB",
            "GGGGGG",
            "BGBBGB"]//,
    //        "GGGGGG",
     //       "BGBBGB",
      //      "BGBBGB"]
print(twoPluses(grid: grid))
