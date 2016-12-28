import Foundation
import AdventOfCodeHelpers

public typealias Register = String

enum Value: CustomStringConvertible {
    case constant(Int)
    case register(Register)

    public static func fromString(_ string: String) -> Value {
        if let constant = Int(string) {
            return .constant(constant)
        }
        return .register(string)
    }

    var description: String {
        switch self {
        case .constant(let value):
            return String(value)
        case .register(let value):
            return value
        }
    }
}

enum Command: CustomStringConvertible {
    case copy(from: Value, to: Value)
    case increment(Value)
    case decrement(Value)
    case jump(when: Value, toOffset: Value)
    case toggle(atOffset: Value)
    case transmit(Value)

    var description: String {
        switch self {
        case .copy(from: let from, to: let to):
            return "cpy \(from) \(to)"
        case .increment(let value):
            return "inc \(value)"
        case .decrement(let value):
            return "dec \(value)"
        case .jump(when: let when, toOffset: let offset):
            return "jnz \(when) \(offset)"
        case .toggle(atOffset: let offset):
            return "tgl \(offset)"
        case .transmit(let value):
            return "out \(value)"
        }
    }
}

class Computer {
    private(set) var registers: [Register: Int]
    private(set) var transmitted: [Int] = []

    init(_ registers: [Register: Int] = [:]) {
        self.registers = registers
    }

    func execute(_ startingCommands: [Command]) {
        var instructionPointer = 0
        var commands = startingCommands

        while instructionPointer < commands.count && transmitted.count < 12 {
            let instruction = commands[instructionPointer]
//            print(instructionPointer, "|", instruction, "|", registers)

            if let multiply = predictMultiply(executing: commands, whenOnInstruction: instructionPointer) {
                registers[multiply.target] = read(multiply.target) + abs(toConstant(multiply.source)) * abs(read(multiply.otherSource)) * (multiply.substracting ? -1 : 1)
                registers[multiply.otherSource] = 0
                registers[multiply.tmpRegister] = 0
                instructionPointer += 6
                continue
            }

            if let add = predictAdd(executing: commands, whenOnInstruction: instructionPointer) {
                registers[add.target] = read(add.target) + abs(read(add.source)) * (add.substracting ? -1 : 1)
                registers[add.source] = 0
                instructionPointer += 3
                continue
            }

            switch instruction {
            case .copy(from: let from, to: let to):
                let fromConstant = toConstant(from)

                switch to {
                case .register(let register):
                    registers[register] = fromConstant
                case .constant(_): break
                }
            case .increment(let value):
                switch value {
                case .register(let register):
                    registers[register] = read(register) + 1
                case .constant(_): break
                }
            case .decrement(let value):
                switch value {
                case .register(let register):
                    registers[register] = read(register) - 1
                case .constant(_): break
                }
            case .jump(when: let when, toOffset: let offset):
                let whenConstant = toConstant(when)
                if whenConstant != 0 {
                    let offsetConstant = toConstant(offset)
                    instructionPointer += offsetConstant - 1
                }
            case .toggle(atOffset: let offset):
                let offsetConstant = toConstant(offset) + instructionPointer
                guard offsetConstant >= 0 && offsetConstant < commands.count else { break }
                let targetInstruction = commands[offsetConstant]
                switch targetInstruction {
                case .copy(from: let from, to: let to):
                    commands[offsetConstant] = .jump(when: from, toOffset: to)
                case .increment(let value):
                    commands[offsetConstant] = .decrement(value)
                case .decrement(let value):
                    commands[offsetConstant] = .increment(value)
                case .jump(when: let when, toOffset: let offset):
                    commands[offsetConstant] = .copy(from: when, to: offset)
                case .toggle(atOffset: let offset):
                    commands[offsetConstant] = .increment(offset)
                case .transmit(let value):
                    commands[offsetConstant] = .increment(value)
                }
            case .transmit(let value):
                transmitted.append(toConstant(value))
            }
            instructionPointer += 1
        }
    }

    private func predictAdd(executing commands: [Command], whenOnInstruction instructionPointer: Int) -> (target: Register, source: Register, substracting: Bool)? {
        if instructionPointer + 2 < commands.count,
            case .jump(when: .register(let whenRegister), toOffset: .constant(-2)) = commands[instructionPointer + 2] {
            if case .increment(.register(let firstRegister)) = commands[instructionPointer],
                case .increment(.register(let secondRegister)) = commands[instructionPointer + 1] {
                if whenRegister == firstRegister {
                    return (target: secondRegister, source: whenRegister, substracting: false)
                } else if whenRegister == secondRegister {
                    return (target: firstRegister, source: whenRegister, substracting: false)
                }
            } else if case .increment(.register(let firstRegister)) = commands[instructionPointer],
                case .decrement(.register(let secondRegister)) = commands[instructionPointer + 1] {
                if whenRegister == firstRegister {
                    return (target: secondRegister, source: whenRegister, substracting: true)
                } else if whenRegister == secondRegister {
                    return (target: firstRegister, source: whenRegister, substracting: false)
                }
            } else if case .decrement(.register(let firstRegister)) = commands[instructionPointer],
                case .increment(.register(let secondRegister)) = commands[instructionPointer + 1] {
                if whenRegister == firstRegister {
                    return (target: secondRegister, source: whenRegister, substracting: false)
                } else if whenRegister == secondRegister {
                    return (target: firstRegister, source: whenRegister, substracting: true)
                }
            } else if case .decrement(.register(let firstRegister)) = commands[instructionPointer],
                case .decrement(.register(let secondRegister)) = commands[instructionPointer + 1] {
                if whenRegister == firstRegister {
                    return (target: secondRegister, source: whenRegister, substracting: true)
                } else if whenRegister == secondRegister {
                    return (target: firstRegister, source: whenRegister, substracting: true)
                }
            }
        }
        return nil
    }

    private func predictMultiply(executing commands: [Command], whenOnInstruction instructionPointer: Int) -> (target: Register, source: Value, otherSource: Register, tmpRegister: Register, substracting: Bool)? {
        if instructionPointer + 5 < commands.count,
            case .copy(from: let fromValue, to: .register(let toRegister)) = commands[instructionPointer],
            case .jump(when: .register(let whenRegister), toOffset: .constant(-5)) = commands[instructionPointer + 5],
            let add = predictAdd(executing: commands, whenOnInstruction: instructionPointer + 1),
            toRegister == add.source {
            if case .increment(.register(whenRegister)) = commands[instructionPointer + 4] {
                return (target: add.target, source: fromValue, otherSource: whenRegister, tmpRegister: add.source, substracting: add.substracting)
            } else if case .decrement(.register(whenRegister)) = commands[instructionPointer + 4] {
                return (target: add.target, source: fromValue, otherSource: whenRegister, tmpRegister: add.source, substracting: add.substracting)
            }
        }
        return nil
    }

    private func toConstant(_ value: Value) -> Int {
        switch value {
        case .register(let register):
            return read(register)
        case .constant(let constant):
            return constant
        }
    }

    private func read(_ register: String) -> Int {
        return registers[register] ?? 0
    }
}

public class Day25 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> String {
        let program = parseInput()
        let targetNumber = 0b101010101010

        let computer = Computer()
        computer.execute(program)
        let transmittedNumber = computer.transmitted.enumerated().reduce(0) {$0 + $1.element << $1.offset }

        return String(targetNumber - transmittedNumber)
    }

    private func parseInput() -> [Command] {
        return input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").map { commandString in
            let commandStringComponents = commandString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            if let commandTypeString = commandStringComponents.first {
                let operands = commandStringComponents.dropFirst().map(Value.fromString(_:))
                if commandTypeString == "cpy", operands.count == 2 {
                    return .copy(from: operands[0], to: operands[1])
                } else if commandTypeString == "inc", operands.count == 1 {
                    return .increment(operands[0])
                } else if commandTypeString == "dec", operands.count == 1 {
                    return .decrement(operands[0])
                } else if commandTypeString == "jnz", operands.count == 2 {
                    return .jump(when: operands[0], toOffset: operands[1])
                } else if commandTypeString == "tgl", operands.count == 1 {
                    return .toggle(atOffset: operands[0])
                } else if commandTypeString == "out", operands.count == 1 {
                    return .transmit(operands[0])
                }
            }
            fatalError()
        }
    }
}
