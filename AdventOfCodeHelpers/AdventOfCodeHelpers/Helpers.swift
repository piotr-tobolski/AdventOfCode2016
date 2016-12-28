import Foundation

public func resource(named: String) -> String {
    let path = Bundle.main.path(forResource: named, ofType: "txt")
    return try! String(contentsOfFile: path!)
}

public func printTime(_ block: () -> () ) {
    let date = Date()
    print("started at: \(date)")
    block()
    print("Execution took \(-date.timeIntervalSinceNow) seconds")
}

public struct Regexp {
    let regularExpression: NSRegularExpression

    public init(_ pattern: String) {
        regularExpression = try! NSRegularExpression(pattern: pattern, options: [])
    }

    public func captureGroupMatches(in string: String) -> [[String]] {
        return regularExpression
            .matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count))
            .map { match in
                var matches: [String] = []
                for i in 1...regularExpression.numberOfCaptureGroups {
                    let captureGroupRange = match.rangeAt(i)
                    if captureGroupRange.location != NSNotFound {
                        let startIndex = string.index(string.startIndex, offsetBy: captureGroupRange.location)
                        let endIndex = string.index(startIndex, offsetBy: captureGroupRange.length)
                        matches.append(string.substring(with: startIndex..<endIndex))
                    }
                }
                
                return matches
        }
    }

    public func matches(in string: String) -> [String] {
        return regularExpression
            .matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count))
            .map {
                let startIndex = string.index(string.startIndex, offsetBy: $0.range.location)
                let endIndex = string.index(startIndex, offsetBy: $0.range.length)

                return string.substring(with: startIndex..<endIndex)
        }
    }
}

