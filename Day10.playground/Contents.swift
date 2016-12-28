import Foundation
import AdventOfCodeHelpers

/*
 --- Day 10: Balance Bots ---

 You come upon a factory in which many robots are zooming around handing small microchips to each other.

 Upon closer examination, you notice that each bot only proceeds when it has two microchips, and once it does, it gives each one to a different bot or puts it in a marked "output" bin. Sometimes, bots take microchips from "input" bins, too.

 Inspecting one of the microchips, it seems like they each contain a single number; the bots must use some logic to decide what to do with each chip. You access the local control computer and download the bots' instructions (your puzzle input).

 Some of the instructions specify that a specific-valued microchip should be given to a specific bot; the rest of the instructions indicate what a given bot should do with its lower-value or higher-value chip.

 For example, consider the following instructions:

 value 5 goes to bot 2
 bot 2 gives low to bot 1 and high to bot 0
 value 3 goes to bot 1
 bot 1 gives low to output 1 and high to bot 0
 bot 0 gives low to output 2 and high to output 0
 value 2 goes to bot 2
 Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2 chip and a value-5 chip.
 Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its higher one (5) to bot 0.
 Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives the value-3 chip to bot 0.
 Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in output 0.
 In the end, output bin 0 contains a value-5 microchip, output bin 1 contains a value-2 microchip, and output bin 2 contains a value-3 microchip. In this configuration, bot number 2 is responsible for comparing value-5 microchips with value-2 microchips.

 Based on your instructions, what is the number of the bot that is responsible for comparing value-61 microchips with value-17 microchips?

 Your puzzle answer was 73.

 --- Part Two ---

 What do you get if you multiply together the values of one chip in each of outputs 0, 1, and 2?

 Your puzzle answer was 3965.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.
 
 You can also [Share] this puzzle.
 */

enum Target {
    case bot(Int)
    case output(Int)

    static func from(_ typeString: String, _ numString: String) -> Target {
        if typeString == "bot" {
            return .bot(Int(numString)!)
        } else if typeString == "output" {
            return .output(Int(numString)!)
        }
        fatalError()
    }
}

enum Command {
    case give(value: Int, botNumber: Int)
    case pass(fromBotnumber: Int, lowTarget: Target, highTarget: Target)

    static func from(_ string: String) -> Command {

        let giveMatches = Regexp("value (\\d+) goes to bot (\\d+)").captureGroupMatches(in: string)[0]
        if giveMatches.count == 2 {
            return .give(value: Int(giveMatches[0])!, botNumber: Int(giveMatches[1])!)
        }

        let passMatches = Regexp("bot (\\d+) gives low to (\\w+) (\\d+) and high to (\\w+) (\\d+)").captureGroupMatches(in: string)[0]
        if passMatches.count == 5 {
            return .pass(fromBotnumber: Int(passMatches[0])!,
                         lowTarget: Target.from(passMatches[1], passMatches[2]),
                         highTarget: Target.from(passMatches[3], passMatches[4]))
        }
        fatalError()
    }
}

class Bot {
    private var valuesStorage: [Int] = []

    func giveValue(_ value: Int) {
        valuesStorage.append(value)
        assert(valuesStorage.count <= 2)
    }

    func takeValues() -> (lower: Int, higher: Int)? {
        if let lower = valuesStorage.sorted().first, let higher = valuesStorage.sorted().last, valuesStorage.count == 2 {
            valuesStorage = []
            return (lower: lower, higher: higher)
        }
        return nil
    }
}

class Factory {
    private var bots: [Int: Bot] = [:]
    private(set) var outputs: [Int: Int] = [:]
    private(set) var firstToCompare17And61: Int?

    private func bot(_ botNumber: Int) -> Bot {
        if let bot = bots[botNumber] {
            return bot
        } else {
            let bot = Bot()
            bots[botNumber] = bot
            return bot
        }
    }

    func process(_ commands: [Command]) {
        var commandsToProcess = commands

        while !commandsToProcess.isEmpty {
            for i in 0..<commandsToProcess.count {
                var commandProcessed = false

                switch commandsToProcess[i] {
                case .give(let value, let botNumber):
                    bot(botNumber).giveValue(value)
                    commandProcessed = true
                case .pass(let fromBotnumber, let lowTarget, let highTarget):
                    if let values = bot(fromBotnumber).takeValues() {
                        print(values)

                        if firstToCompare17And61 == nil && values == (lower: 17, higher: 61) {
                            firstToCompare17And61 = fromBotnumber
                        }

                        switch lowTarget {
                        case .bot(let botNumber):
                            bot(botNumber).giveValue(values.lower)
                        case .output(let outputNumber):
                            outputs[outputNumber] = values.lower
                        }

                        switch highTarget {
                        case .bot(let botNumber):
                            bot(botNumber).giveValue(values.higher)
                        case .output(let outputNumber):
                            outputs[outputNumber] = values.higher
                        }

                        commandProcessed = true
                    }
                }

                if commandProcessed {
                    commandsToProcess.remove(at: i)
                    break
                }
            }
        }
    }
}

class Day10 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let commands = input.components(separatedBy: "\n").filter { !$0.isEmpty }.map(Command.from(_:))
        let factory = Factory()
        factory.process(commands)

        return (String(factory.firstToCompare17And61!), String([0, 1, 2].reduce(1) { $0 * factory.outputs[$1]! }))
    }
}

printTime {
    print(Day10().solve()) //success: 73, 3965
}
