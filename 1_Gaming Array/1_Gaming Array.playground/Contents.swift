func gamingArray(arr: [Int]) -> String {
    let count = arr.count - 1
    guard count > 0 else { return "BOB" }
    var win: Bool = true
    var max = arr[0]
    for i in 1...count {
        if arr[i] > max {
            max = arr[i]
            win = !win
        }
    }
    if win {
        return "BOB"
    }
    else {
        return "ANDY"
    }
}

