import Foundation
import AdventOfCodeHelpers

public class Day20 {
    let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let blacklistRanges = parseInput()
        let nonOverlappingBlacklist = nonOverlapping(blacklistRanges).sorted { $0.0.lowerBound < $0.1.lowerBound }
        let minimumAllowed = nonOverlappingBlacklist[0].upperBound + 1
        let totalAllowed = 1 + nonOverlappingBlacklist.reduce(UInt32.max) { $0 - UInt32($1.count) }
        return (String(minimumAllowed), String(totalAllowed))
    }

    private func nonOverlapping(_ ranges:[CountableClosedRange<Int>]) -> [CountableClosedRange<Int>] {
        var reducedRanges = ranges
        var index = 0
        while index < (reducedRanges.count - 1) {
            let range = reducedRanges[index]
            for otherIndex in (index + 1)..<reducedRanges.count {
                let otherRange = reducedRanges[otherIndex]
                if range.overlaps(otherRange) ||
                    (range.lowerBound - otherRange.upperBound) == 1 ||
                    (otherRange.lowerBound - range.upperBound) == 1 {
                    reducedRanges.remove(at: otherIndex)
                    reducedRanges.remove(at: index)
                    reducedRanges.append(min(range.lowerBound, otherRange.lowerBound)...max(range.upperBound, otherRange.upperBound))
                    index = -1
                    break
                }
            }
            index += 1
        }
        return reducedRanges
    }

    private func parseInput() -> [CountableClosedRange<Int>] {
        return input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").map { $0.components(separatedBy: "-")}.map { Int($0[0])!...Int($0[1])! }
    }
}
