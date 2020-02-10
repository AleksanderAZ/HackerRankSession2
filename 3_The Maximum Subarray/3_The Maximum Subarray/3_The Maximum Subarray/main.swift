//
//  main.swift
//  3_The Maximum Subarray
//
//  Created by Oleksander on 10.02.2020.
//  Copyright © 2020 Oleksander. All rights reserved.
//

import Foundation


func maxSubarray(arr: [Int]) -> [Int] {
    
    let countArr = arr.count
    guard countArr > 0 else {return [0, 0] }
    guard countArr > 1 else {return [arr[0], arr[0]] }
    var maxSum = arr[0]
    var maxSumSubarray = arr[0]
    var maxSumSubarrayOld = arr[0]
    var startSubarray = 0
    
    var i = 1
    while i < countArr {
        if arr[i] < 0 {
            if maxSum < arr[i] { maxSum = arr[i] }
        }
        else {
            if maxSum < 0 { maxSum = 0 }
            maxSum = maxSum + arr[i]
        }
        // sub
        if maxSumSubarray < 0 {
            if maxSumSubarray < arr[i] {
                maxSumSubarray = arr[i]
                startSubarray = i
            }
        }
        else {
            if startSubarray < i  {
                if maxSumSubarray + arr[i] <= 0 {
                    startSubarray = i + 1
                }
                else {
                    maxSumSubarray = maxSumSubarray + arr[i]
                }
            }
            else {
                maxSumSubarray = arr[i]
            }
        }
        if maxSumSubarrayOld < maxSumSubarray { maxSumSubarrayOld = maxSumSubarray }
        i =  i + 1
    }
    
    return [maxSumSubarrayOld, maxSum]
}

var arr = [-2, -3, -1, -4, -6]

print(maxSubarray(arr: arr))
