import Foundation
import AdventOfCodeHelpers

/*
 --- Day 21: Scrambled Letters and Hash ---

 The computer system you're breaking into uses a weird scrambling function to store its passwords. It shouldn't be much trouble to create your own scrambled password so you can add it to the system; you just have to implement the scrambler.

 The scrambling function is a series of operations (the exact list is provided in your puzzle input). Starting with the password to be scrambled, apply each operation in succession to the string. The individual operations behave as follows:

 swap position X with position Y means that the letters at indexes X and Y (counting from 0) should be swapped.
 swap letter X with letter Y means that the letters X and Y should be swapped (regardless of where they appear in the string).
 rotate left/right X steps means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
 rotate based on position of letter X means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.
 reverse positions X through Y means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
 move position X to position Y means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.
 For example, suppose you start with abcde and perform the following operations:

 swap position 4 with position 0 swaps the first and last letters, producing the input for the next step, ebcda.
 swap letter d with letter b swaps the positions of d and b: edcba.
 reverse positions 0 through 4 causes the entire string to be reversed, producing abcde.
 rotate left 1 step shifts all letters left one position, causing the first letter to wrap to the end of the string: bcdea.
 move position 1 to position 4 removes the letter at position 1 (c), then inserts it at position 4 (the end of the string): bdeac.
 move position 3 to position 0 removes the letter at position 3 (a), then inserts it at position 0 (the front of the string): abdec.
 rotate based on position of letter b finds the index of letter b (1), then rotates the string right once plus a number of times equal to that index (2): ecabd.
 rotate based on position of letter d finds the index of letter d (4), then rotates the string right once, plus a number of times equal to that index, plus an additional time because the index was at least 4, for a total of 6 right rotations: decab.
 After these steps, the resulting scrambled password is decab.

 Now, you just need to generate a new scrambled password and you can access the system. Given the list of scrambling operations in your puzzle input, what is the result of scrambling abcdefgh?

 Your puzzle answer was agcebfdh.

 --- Part Two ---

 You scrambled the password correctly, but you discover that you can't actually modify the password file on the system. You'll need to un-scramble one of the existing passwords by reversing the scrambling process.

 What is the un-scrambled version of the scrambled password fbgdceah?

 Your puzzle answer was afhdbegc.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.
 
 You can also [Share] this puzzle.
 */

extension String {
    func subrange(from: Int, through: Int) -> ClosedRange<Index> {
        let lowerBound = self.index(self.startIndex, offsetBy: from)
        let upperBound = self.index(lowerBound, offsetBy: through - from)
        return lowerBound...upperBound
    }
}

enum Direction {
    case left
    case right
}

enum Command {
    case swapPositions(Int, Int)
    case swapLetters(String, String)
    case rotateInDirection(_: Direction, steps: Int)
    case rotateBasedOnPosition(of: String)
    case reverse(from: Int, through: Int)
    case move(from: Int, to: Int)
    case reverseRotateBasedOnPosition(of: String)

    func reversedCommand() -> Command {
        switch self {
        case .swapPositions(_, _):
            return self
        case .swapLetters(_, _):
            return self
        case .rotateInDirection(let direction, steps: let steps):
            return .rotateInDirection(direction == .left ? .right : .left, steps: steps)
        case .rotateBasedOnPosition(of: let letter):
            return .reverseRotateBasedOnPosition(of: letter)
        case .reverse(from: _, through: _):
            return self
        case .move(from: let firstPosition, to: let secondPosition):
            return .move(from: secondPosition, to: firstPosition)
        case .reverseRotateBasedOnPosition(of: let letter):
            return .rotateBasedOnPosition(of: letter)
        }
    }
}

class Scrambler {
    let commands: [Command]

    init(_ commands: [Command]) {
        self.commands = commands
    }

    func scramble(_ string: String) -> String {
        return commands.reduce(string) { execute($1, on: $0) }
    }

    func descramble(_ string: String) -> String {
        return commands.map { $0.reversedCommand() }.reversed().reduce(string) { execute($1, on: $0) }
    }

    private func execute(_ command: Command, on string: String) -> String {
        var scrambledString = string
        switch command {
        case .swapPositions(let firstPosition, let secondPosition):
            let firstSubrange = scrambledString.subrange(from: firstPosition, through: firstPosition)
            let secondSubrange = scrambledString.subrange(from: secondPosition, through: secondPosition)
            let firstLetter = scrambledString[firstSubrange]
            let secondLetter = scrambledString[secondSubrange]
            scrambledString.replaceSubrange(firstSubrange, with: secondLetter)
            scrambledString.replaceSubrange(secondSubrange, with: firstLetter)
        case .swapLetters(let firstLetter, let secondLetter):
            let firstSubrange = scrambledString.range(of: firstLetter)!
            let secondSubrange = scrambledString.range(of: secondLetter)!
            scrambledString.replaceSubrange(firstSubrange, with: secondLetter)
            scrambledString.replaceSubrange(secondSubrange, with: firstLetter)
        case .rotateInDirection(let direction, steps: let steps):
            let constrainedSteps = steps % scrambledString.characters.count
            if constrainedSteps != 0 {
                if direction == .left {
                    let subrange = scrambledString.subrange(from: 0, through: constrainedSteps - 1)
                    let substring = scrambledString[subrange]
                    scrambledString.removeSubrange(subrange)
                    scrambledString.append(substring)
                } else {
                    let length = scrambledString.characters.count
                    let subrange = scrambledString.subrange(from: length - constrainedSteps, through: length - 1)
                    let substring = scrambledString[subrange]
                    scrambledString.removeSubrange(subrange)
                    scrambledString = substring + scrambledString
                }
            }
        case .rotateBasedOnPosition(of: let letter):
            let range = scrambledString.range(of: letter)!
            var index = scrambledString.distance(from: scrambledString.startIndex, to: range.lowerBound)
            if index >= 4 {
                index += 2
            } else {
                index += 1
            }
            scrambledString = execute(.rotateInDirection(.right, steps: index), on: scrambledString)
        case .reverse(from: let firstPosition, through: let secondPosition):
            let subrange = scrambledString.subrange(from: firstPosition, through: secondPosition)
            let substring = scrambledString[subrange]
            let reversedSubstring = String(substring.characters.reversed())
            scrambledString.replaceSubrange(subrange, with: reversedSubstring)

        case .move(from: let firstPosition, to: let secondPosition):
            let firstSubrange = scrambledString.subrange(from: firstPosition, through: firstPosition)
            let firstLetter = scrambledString[firstSubrange]
            scrambledString.removeSubrange(firstSubrange)
            let secondSubrange = scrambledString.subrange(from: secondPosition, through: secondPosition)
            scrambledString.insert(contentsOf: firstLetter.characters, at: secondSubrange.lowerBound)
        case .reverseRotateBasedOnPosition(of: let letter):
            let range = scrambledString.range(of: letter)!
            var index = scrambledString.distance(from: scrambledString.startIndex, to: range.lowerBound)
            if index % 2 == 1 {
                index = (index + 1) / 2
            } else if index == 0 {
                index = 1
            } else {
                index = (index + scrambledString.characters.count + 2) / 2
            }
            scrambledString = execute(.rotateInDirection(.left, steps: index), on: scrambledString)
        }
        return scrambledString
    }
}

/*
 rotate based on position of letter X means that
 the whole string should be rotated to the right
 based on the index of letter X (counting from 0)
 as determined before this instruction does any
 rotations. Once the index is determined, rotate
 the string to the right one time, plus a number
 of times equal to that index, plus one additional
 time if the index was at least 4.

 0  -> 1  --> 1
 1  -> 2  --> 3
 2  -> 3  --> 5
 3  -> 4  --> 7
 4  -> 6  --> 2
 5  -> 7  --> 4
 6  -> 0  --> 6
 7  -> 1  --> 0
 */

public class Day21 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let commands = parseInput()
        let scrambler = Scrambler(commands)
        let scrambledString = scrambler.scramble("abcdefgh")
        let descrambledString = scrambler.descramble("fbgdceah")
        return (String(scrambledString), String(descrambledString))
    }

    private func parseInput() -> [Command] {
        return input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").map { commandString in
            if let matches = Regexp("swap position (.+) with position (.+)").captureGroupMatches(in: commandString).first {
                return .swapPositions(Int(matches[0])!, Int(matches[1])!)
            } else if let matches = Regexp("swap letter (.+) with letter (.+)").captureGroupMatches(in: commandString).first {
                return .swapLetters(matches[0], matches[1])
            } else if let matches = Regexp("rotate (left|right) (.+) step").captureGroupMatches(in: commandString).first {
                return .rotateInDirection(matches[0] == "left" ? .left : .right, steps: Int(matches[1])!)
            } else if let matches = Regexp("rotate based on position of letter (.+)").captureGroupMatches(in: commandString).first {
                return .rotateBasedOnPosition(of: matches[0])
            } else if let matches = Regexp("reverse positions (.+) through (.+)").captureGroupMatches(in: commandString).first {
                return .reverse(from: Int(matches[0])!, through: Int(matches[1])!)
            } else if let matches = Regexp("move position (.+) to position (.+)").captureGroupMatches(in: commandString).first {
                return .move(from: Int(matches[0])!, to: Int(matches[1])!)
            }
            fatalError("Couldn't parse \"\(commandString)\"")
        }
    }
}

printTime {
    print(Day21().solve()) // agcebfdh, afhdbegc
}
