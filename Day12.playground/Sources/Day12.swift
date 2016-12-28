import Foundation
import AdventOfCodeHelpers

public typealias Register = String

public enum Value {
    case constant(Int)
    case register(Register)

    public static func fromString(_ string: String) -> Value {
        if let constant = Int(string) {
            return .constant(constant)
        }
        return .register(string)
    }
}

public enum Command {
    case copy(from: Value, to: Value)
    case increment(Value)
    case decrement(Value)
    case jump(when: Value, toOffset: Value)
}

public class Computer {
    public private(set) var registers: [String: Int]

    public init(_ registers: [String: Int] = [:]) {
        self.registers = registers
    }

    public func execute(_ commands: [Command]) {
        var instructionPointer = 0

        while instructionPointer < commands.count {
            let instruction = commands[instructionPointer]
            instructionPointer += 1

            switch instruction {
            case .copy(from: let from, to: let to):
                let fromConstant = toConstant(from)

                switch to {
                case .register(let register):
                    registers[register] = fromConstant
                case .constant(_):
                    fatalError("Trying to copy to constant")
                }
            case.increment(let value):
                switch value {
                case .register(let register):
                    registers[register] = read(register) + 1
                case .constant(_):
                    fatalError("Trying increment constant")
                }
            case.decrement(let value):
                switch value {
                case .register(let register):
                    registers[register] = read(register) - 1
                case .constant(_):
                    fatalError("Trying decrement constant")
                }
            case .jump(when: let when, toOffset: let offset):
                let whenConstant = toConstant(when)
                if whenConstant != 0 {
                    let offsetConstant = toConstant(offset)
                    instructionPointer += offsetConstant - 1
                }
            }
        }
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

public class Day12 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let program = parseInput()
        print(program)
        print(program.count)

        let computer = Computer()
        computer.execute(program)
        print(computer.registers)

        let preprogrammedComputer = Computer([ "c" : 1 ])
        preprogrammedComputer.execute(program)
        print(preprogrammedComputer.registers)

        return (String(computer.registers["a"] ?? Int.min), String(preprogrammedComputer.registers["a"] ?? Int.min))

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
                }
            }
            fatalError()
        }
    }
}
