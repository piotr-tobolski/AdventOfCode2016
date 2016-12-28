import Foundation
import AdventOfCodeHelpers

/*
 --- Day 7: Internet Protocol Version 7 ---

 While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).

 An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by square brackets.

 For example:

 abba[mnop]qrst supports TLS (abba outside square brackets).
 abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
 aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
 ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).
 How many IPs in your puzzle input support TLS?

 Your puzzle answer was 110.

 --- Part Two ---

 You would also like to know which IPs support SSL (super-secret listening).

 An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence which consists of the same character twice with a different character between them, such as xyx or aba. A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.

 For example:

 aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
 xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
 aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
 zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).
 How many IPs in your puzzle input support SSL?

 Your puzzle answer was 242.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.

 You can also [Share] this puzzle.
 */

fileprivate struct IPAddress {
    let string: String

    func supportsTLS() -> Bool {
        var buffer: [Character] = []
        var hypernetSequence = false
        var supportsTLS = false
        for c in string.characters {
            if c == "[" {
                hypernetSequence = true
                buffer = []
                continue
            }

            if c == "]" {
                hypernetSequence = false
                buffer = []
                continue
            }

            if buffer.count == 3 {
                if c != buffer[0] &&
                    c == buffer[2] &&
                    buffer[0] == buffer[1] {
                    if hypernetSequence {
                        supportsTLS = false
                        break
                    } else {
                        supportsTLS = true
                    }
                }
            }

            buffer.insert(c, at: 0)
            while buffer.count > 3 {
                buffer.removeLast()
            }
        }
        return supportsTLS
    }

    func supportsSSL() -> Bool {
        var buffer: [Character] = []
        var substrings: Set<String> = []
        var hypernetSubstrings: Set<String> = []
        var hypernetSequence = false
        for c in string.characters {
            if c == "[" {
                hypernetSequence = true
                buffer = []
                continue
            }

            if c == "]" {
                hypernetSequence = false
                buffer = []
                continue
            }

            buffer.insert(c, at: 0)
            while buffer.count > 3 {
                buffer.removeLast()
            }

            if buffer.count == 3 {
                if c != buffer[1] && c == buffer[2] {
                    if hypernetSequence {
                        hypernetSubstrings.insert("\(buffer[1])\(c)")
                    } else {
                        substrings.insert("\(c)\(buffer[1])")
                    }
                }
            }

            if !substrings.isDisjoint(with: hypernetSubstrings) {
                return true
            }

        }
        return false
    }
}

public class Day7 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let IPAddresses = input.components(separatedBy: "\n").filter { !$0.isEmpty }.map(IPAddress.init(string:))
        let countTLS = IPAddresses.filter {$0.supportsTLS()}.count
        let countSSL = IPAddresses.filter {$0.supportsSSL()}.count
        return (String(countTLS), String(countSSL))
    }
}

printTime {
    print(Day7().solve()) //success: 110, 242
}
