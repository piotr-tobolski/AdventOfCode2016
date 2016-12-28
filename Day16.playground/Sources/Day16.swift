import Foundation
import AdventOfCodeHelpers

public class Day16 {
    let input: String

    public init(input: String = "11011110011011101") {
        self.input = input
    }

    public func solve() -> (String, String) {
        let shortData = expand(input, to: 272)
        let shortDataChecksum = checksum(shortData)

        let longData = expand(input, to: 35651584)
        let longDataChecksum = checksum(longData)

        return (String(shortDataChecksum), String(longDataChecksum))
    }

    private func expand(_ data: String, to requiredLength: Int) -> String {
        var newData = data
        while newData.utf8.count < requiredLength {
            print(newData.utf8.count)
            newData = newData + "0" + newData.characters.reversed().reduce("") { $0 + (String($1) == "0" ? "1" : "0") }
        }

        return newData.substring(to: newData.index(newData.startIndex, offsetBy: requiredLength))
    }

    private func checksum(_ data: String) -> String {
        var newData = data
        while newData.utf8.count % 2 == 0 {
            var utf8String = newData.utf8CString
            newData = ""
            for i in stride(from: 0, to: utf8String.count - 1, by: 2) {
                if utf8String[i] == utf8String[i + 1] {
                    newData.append("1")
                } else {
                    newData.append("0")
                }
            }
            print(newData.utf8.count)
        }
        return newData
    }
}
