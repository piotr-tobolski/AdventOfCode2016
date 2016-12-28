import Foundation
import AdventOfCodeHelpers
import BTree

struct Elf {
    let number: Int

    init(_ number: Int) {
        self.number = number
    }
}

public class Day19 {
    let input: String

        public init(input: String = "3018458") {
        self.input = input
    }

    public func solve() -> (String, String) {
        let numberOfElves = Int(input)!
        let elves = (1...numberOfElves).map(Elf.init(_:))
        print("generated elves: ", elves.count)

        let part1Result = part1(elves)
        let part2Result = part2(elves)

        return (part1Result, part2Result)
    }

    private func part1(_ startingElves: [Elf]) -> String {
        var elves = startingElves
        var currentIndex = 0
        var newElves: [Elf] = []
        while elves.count > 1 {
            let currentElf = elves[currentIndex]
            newElves.append(currentElf)

            if currentIndex + 1 == elves.count {
                newElves.removeFirst()
            }

            currentIndex = currentIndex + 2

            if currentIndex >= elves.count {
                elves = newElves
                newElves = []
                currentIndex = 0
                print(elves.count)
            }
        }
        print(elves)
        return String(elves[0].number)
    }

    private func part2(_ startingElves: [Elf]) -> String {
        var elves = List(startingElves)
        var currentIndex = 0
        while elves.count > 1 {
            let nextElfIndex = (currentIndex + elves.count / 2) % elves.count
            elves.remove(at: nextElfIndex)

            if currentIndex == elves.count {
                currentIndex = 0
            } else if nextElfIndex > currentIndex {
                currentIndex += 1
                currentIndex %= elves.count
            }

            if elves.count % 1000 == 0 {
                print(elves.count)
            }
        }
        print(elves)
        return String(elves[0].number)
    }
}
