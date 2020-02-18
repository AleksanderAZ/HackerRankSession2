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
    
    var findString = s.prefix(countS+1)
    var indexP = findString.startIndex
    
    while (indexP < findString.index(before: findString.endIndex)) {
        var sum = 0
        var number = 0
        let p = findString[indexP]
        var index = findString.index(after: indexP)
        while index < findString.endIndex {
            if (p == findString[index]) {
                findString.remove(at: index)
                number += 1
                sum = sum + number
            }
            else {
                index = findString.index(after: index)
            }
        }
        indexP = findString.index(after: indexP)
        sumCount = sumCount + sum
    }

    for prefSub in 2...countS {
        for suffSub in 2...prefSub {
            let p = s.prefix(prefSub).suffix(suffSub)
            let countSubSuffix = countS - prefSub + suffSub
            for rangeFind in 0...(countS - prefSub) {
                var findString = s.suffix(countSubSuffix-rangeFind).prefix(suffSub)
                var flagFind = false
                for c in p {
                    flagFind = false
                    var index = findString.startIndex
                    while index < findString.endIndex {
                        if (c == findString[index]) {
                            findString.remove(at: index)
                            flagFind = true
                            break
                        }
                        else {
                            index = findString.index(after: index)
                        }
                    }
                    if (flagFind == false) {
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

var ss = ["ifailuhkqqhucpoltgtyovarjsnrbfpvmupwjjjfiwwhrlkpekxxnebfrwibylcvkfealgonjkzwlyfhhkefuvgndgdnbelgruel",
 "gffryqktmwocejbxfidpjfgrrkpowoxwggxaknmltjcpazgtnakcfcogzatyskqjyorcftwxjrtgayvllutrjxpbzggjxbmxpnde",
 "mqmtjwxaaaxklheghvqcyhaaegtlyntxmoluqlzvuzgkwhkkfpwarkckansgabfclzgnumdrojexnrdunivxqjzfbzsodycnsnmw",
 "ofeqjnqnxwidhbuxxhfwargwkikjqwyghpsygjxyrarcoacwnhxyqlrviikfuiuotifznqmzpjrxycnqktkryutpqvbgbgthfges",
"zjekimenscyiamnwlpxytkndjsygifmqlqibxxqlauxamfviftquntvkwppxrzuncyenacfivtigvfsadtlytzymuwvpntngkyhw",
 "ioqfhajbwdfnudqfsjhikzdjcbdymoecaokeomuimlzcaqkfmvquarmvlnrurdblzholugvwtkunirmnmsatrtbqlioauaxbcehl",
 "kaggklnwxoigxncgxnkrtdjnoeblhlxsblnqitdkoiftxnsafukbdhasdeihlhfrqkfzqhvnsmsgnrayhsyjsniutmgpfjmssfsg",
 "fhithnigqftuzzgpdiquhlsozksxxfreddmsmvqgfgzntphmgggszwtkcbmjsllwtukgqvpvxvmatuanbeossqwtpgzbagaukmta",
 "rqjfiszbigkdqxkfwtsbvksmfrffoanseuenvmxzsugidncvtifqesgreupsamtsyfrsvwlvhtyzgjgnmsowjwhovsmfvwuniasw",
 "dxskilnpkkdxwpeefvgkyohnwxtrrtxtckkdgnawrdjtcpzplywyxmwtemwmtklnclqccklotbpsrkazqolefprenwaozixvlxhu"]

var res = [
399,
471,
370,
403,
428,
412,
472,
457,
467,
447]

for (i, v) in ss.enumerated() {
    print(sherlockAndAnagrams(s: v) == res[i])
}


 
/*
 int sherlockAndAnagrams(string s) {
     
     int countS ;
     countS = s.size() - 1;
     int sumCount = 0;
     int summ = 0;
     int n = 0;
     int index;
     
     int countSubSuffix;
     string findSString    ;
     for (int prefSub=2; prefSub<=countS; prefSub++) {
         for (int suffSub=2; suffSub<=prefSub; suffSub++) {
             for (int rangeFind=1; rangeFind<=(countS - prefSub+ 1); rangeFind++) {
                 findSString = s.substr(prefSub - suffSub + rangeFind, suffSub);
                 bool flagFind = true;
                 string p = s.substr(prefSub-suffSub,suffSub);
                 for (int indexP=0; indexP<p.size(); indexP++) {
                     index = findSString.find(p[indexP]) ;
                     if (index > -1 ) {
                         findSString.erase(index,1);
                     }
                     else {
                         flagFind = false;
                         break;
                     }
                 }
                 if (flagFind == true) {
                     sumCount = sumCount + 1;
                 }
             }
         }
     }
     return sumCount;
 }
 */
 
