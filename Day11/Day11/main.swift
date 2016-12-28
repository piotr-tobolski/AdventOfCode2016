import Foundation

/*
 --- Day 11: Radioisotope Thermoelectric Generators ---

 You come upon a column of four floors that have been entirely sealed off from the rest of the building except for a small dedicated lobby. There are some radiation warnings and a big sign which reads "Radioisotope Testing Facility".

 According to the project status board, this facility is currently being used to experiment with Radioisotope Thermoelectric Generators (RTGs, or simply "generators") that are designed to be paired with specially-constructed microchips. Basically, an RTG is a highly radioactive rock that generates electricity through heat.

 The experimental RTGs have poor radiation containment, so they're dangerously radioactive. The chips are prototypes and don't have normal radiation shielding, but they do have the ability to generate an electromagnetic radiation shield when powered. Unfortunately, they can only be powered by their corresponding RTG. An RTG powering a microchip is still dangerous to other microchips.

 In other words, if a chip is ever left in the same area as another RTG, and it's not connected to its own RTG, the chip will be fried. Therefore, it is assumed that you will follow procedure and keep chips connected to their corresponding RTG when they're in the same room, and away from other RTGs otherwise.

 These microchips sound very interesting and useful to your current activities, and you'd like to try to retrieve them. The fourth floor of the facility has an assembling machine which can make a self-contained, shielded computer for you to take with you - that is, if you can bring it all of the RTGs and microchips.

 Within the radiation-shielded part of the facility (in which it's safe to have these pre-assembly RTGs), there is an elevator that can move between the four floors. Its capacity rating means it can carry at most yourself and two RTGs or microchips in any combination. (They're rigged to some heavy diagnostic equipment - the assembling machine will detach it for you.) As a security measure, the elevator will only function if it contains at least one RTG or microchip. The elevator always stops on each floor to recharge, and this takes long enough that the items within it and the items on that floor can irradiate each other. (You can prevent this if a Microchip and its Generator end up on the same floor in this way, as they can be connected while the elevator is recharging.)

 You make some notes of the locations of each component of interest (your puzzle input). Before you don a hazmat suit and start moving things around, you'd like to have an idea of what you need to do.

 When you enter the containment area, you and the elevator will start on the first floor.

 For example, suppose the isolated area has the following arrangement:

 The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
 The second floor contains a hydrogen generator.
 The third floor contains a lithium generator.
 The fourth floor contains nothing relevant.
 As a diagram (F# for a Floor number, E for Elevator, H for Hydrogen, L for Lithium, M for Microchip, and G for Generator), the initial state looks like this:

 F4 .  .  .  .  .
 F3 .  .  .  LG .
 F2 .  HG .  .  .
 F1 E  .  HM .  LM
 Then, to get everything up to the assembling machine on the fourth floor, the following steps could be taken:

 Bring the Hydrogen-compatible Microchip to the second floor, which is safe because it can get power from the Hydrogen Generator:

 F4 .  .  .  .  .
 F3 .  .  .  LG .
 F2 E  HG HM .  .
 F1 .  .  .  .  LM
 Bring both Hydrogen-related items to the third floor, which is safe because the Hydrogen-compatible microchip is getting power from its generator:

 F4 .  .  .  .  .
 F3 E  HG HM LG .
 F2 .  .  .  .  .
 F1 .  .  .  .  LM
 Leave the Hydrogen Generator on floor three, but bring the Hydrogen-compatible Microchip back down with you so you can still use the elevator:

 F4 .  .  .  .  .
 F3 .  HG .  LG .
 F2 E  .  HM .  .
 F1 .  .  .  .  LM
 At the first floor, grab the Lithium-compatible Microchip, which is safe because Microchips don't affect each other:

 F4 .  .  .  .  .
 F3 .  HG .  LG .
 F2 .  .  .  .  .
 F1 E  .  HM .  LM
 Bring both Microchips up one floor, where there is nothing to fry them:

 F4 .  .  .  .  .
 F3 .  HG .  LG .
 F2 E  .  HM .  LM
 F1 .  .  .  .  .
 Bring both Microchips up again to floor three, where they can be temporarily connected to their corresponding generators while the elevator recharges, preventing either of them from being fried:

 F4 .  .  .  .  .
 F3 E  HG HM LG LM
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring both Microchips to the fourth floor:

 F4 E  .  HM .  LM
 F3 .  HG .  LG .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Leave the Lithium-compatible microchip on the fourth floor, but bring the Hydrogen-compatible one so you can still use the elevator; this is safe because although the Lithium Generator is on the destination floor, you can connect Hydrogen-compatible microchip to the Hydrogen Generator there:

 F4 .  .  .  .  LM
 F3 E  HG HM LG .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring both Generators up to the fourth floor, which is safe because you can connect the Lithium-compatible Microchip to the Lithium Generator upon arrival:

 F4 E  HG .  LG LM
 F3 .  .  HM .  .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring the Lithium Microchip with you to the third floor so you can use the elevator:

 F4 .  HG .  LG .
 F3 E  .  HM .  LM
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 Bring both Microchips to the fourth floor:

 F4 E  HG HM LG LM
 F3 .  .  .  .  .
 F2 .  .  .  .  .
 F1 .  .  .  .  .
 In this arrangement, it takes 11 steps to collect all of the objects at the fourth floor for assembly. (Each elevator stop counts as one step, even if nothing is added to or removed from it.)

 In your situation, what is the minimum number of steps required to bring all of the objects to the fourth floor?

 Your puzzle answer was 33.

 --- Part Two ---

 You step into the cleanroom separating the lobby from the isolated area and put on the hazmat suit.

 Upon entering the isolated containment area, however, you notice some extra parts on the first floor that weren't listed on the record outside:

 An elerium generator.
 An elerium-compatible microchip.
 A dilithium generator.
 A dilithium-compatible microchip.
 These work just like the other generators and microchips. You'll have to get them up to assembly as well.

 What is the minimum number of steps required to bring all of the objects, including these four new ones, to the fourth floor?

 Your puzzle answer was 57.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.
 
 If you still want to see it, you can get your puzzle input.
 
 You can also [Share] this puzzle.
 */

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

enum Element: String {
    case promethium
    case cobalt
    case curium
    case ruthenium
    case plutonium
    case elerium
    case dilithium
}

enum DeviceType: String {
    case generator
    case microchip
}

enum Move {
    case up(Set<Device>)
    case down(Set<Device>)
}

struct Device: CustomStringConvertible, Hashable, Comparable {
    let element: Element
    let type: DeviceType

    var description: String {
        var description = ""

        switch element {
        case .promethium: description.append("P")
        case .cobalt: description.append("C")
        case .curium: description.append("U")
        case .ruthenium: description.append("R")
        case .plutonium: description.append("L")
        case .elerium: description.append("E")
        case .dilithium: description.append("D")
        }

        switch type {
        case .generator: description.append("G")
        case .microchip: description.append("M")
        }

        return description
    }

    public static func ==(lhs: Device, rhs: Device) -> Bool {
        return lhs.element == rhs.element && lhs.type == rhs.type
    }

    var hashValue: Int {
        var hashValue = 0
        switch element {
        case .promethium: hashValue += 1
        case .cobalt: hashValue += 2
        case .curium: hashValue += 3
        case .ruthenium: hashValue += 4
        case .plutonium: hashValue += 5
        case .elerium: hashValue += 6
        case .dilithium: hashValue += 7
        }

        switch type {
        case .generator: hashValue += 10
        case .microchip: hashValue += 20
        }

        return hashValue
    }

    public static func < (lhs: Device, rhs: Device) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
}

struct Floor: CustomStringConvertible {
    var devices: Set<Device> = []

    var description: String {
        return devices.map { $0.description }.joined(separator: " ")
    }

    init(_ devices: Set<Device>) {
        self.devices = devices
    }

    func devicesToBeTaken() -> Set<Set<Device>> {
        var devicesToBeTaken: Set<Set<Device>> = []

        let devicesArray = Array(devices)

        var indexesToPick: [Set<Int>] = devicesArray.indices.map { Set([$0]) }
        for i in 0..<(devicesArray.count - 1) {
            for j in (i + 1)..<devices.count {
                indexesToPick.append(Set([i, j]))
            }
        }

        let allIndexes: Set<Int> = Set(devicesArray.indices)
        for indexToPick in indexesToPick {
            let pickedDevices = Set(indexToPick.map { devicesArray[$0] })
            if canBeStoredTogether(pickedDevices) {
                let leftDevices = Set(allIndexes.subtracting(indexToPick).map { devicesArray[$0] })
                if canBeStoredTogether(leftDevices) {
                    devicesToBeTaken.insert(pickedDevices)
                }
            }
        }

        return devicesToBeTaken
    }

    private func canBeStoredTogether(_ devices: Set<Device>) -> Bool {
        let microchips = devices.filter { $0.type == .microchip }
        for microchip in microchips {
            let generators = devices.filter { $0.type == .generator }
            if generators.count > 0 && !generators.contains { $0.element == microchip.element } {
                return false
            }
        }
        return true
    }

    func canStore(_ newDevices: Set<Device>) -> Bool {
        return canBeStoredTogether(devices.union(newDevices))
    }
}

struct Facility: CustomStringConvertible {
    var floors: [Floor] = []
    var elevatorLocation = 0

    init(_ floors: [Floor]) {
        self.floors = floors
    }

    private func allDevices() -> [Device] {
        return floors.reduce([]) { $0 + $1.devices }.sorted()
    }

    var description: String {
        var lines: [String] = floors.enumerated().map { "F\($0.0) \($0.0 == elevatorLocation ? "*" : " ") |" }
        for device in allDevices() {
            for (i, _) in lines.enumerated() {
                if i == floorForDevice(device) {
                    lines[i].append("\(device)|")
                } else {
                    lines[i].append("  |")
                }
            }
        }

        return lines.reversed().joined(separator: "\n")
    }

    private func floorForDevice(_ device: Device) -> Int {
        return floors.index { $0.devices.contains(device) }!
    }

    func possibleMoves() -> [Move] {
        var possibleMoves: [Move] = []

        for devices in floors[elevatorLocation].devicesToBeTaken() {
            let floorAbove = elevatorLocation + 1
            if floorAbove < floors.count {
                if floors[floorAbove].canStore(devices) {
                    possibleMoves.append(.up(devices))
                }
            }

            let floorBelow = elevatorLocation - 1
            if floorBelow >= 0 {
                if floors[floorBelow].canStore(devices) {
                    possibleMoves.append(.down(devices))
                }
            }
        }
        return possibleMoves
    }

    mutating func perform(_ move: Move) {
        switch move {
        case .up(let devices):
            let floorAbove = elevatorLocation + 1
            floors[floorAbove].devices.formUnion(devices)
            floors[elevatorLocation].devices.subtract(devices)
            elevatorLocation = floorAbove
        case .down(let devices):
            let floorBelow = elevatorLocation - 1
            floors[floorBelow].devices.formUnion(devices)
            floors[elevatorLocation].devices.subtract(devices)
            elevatorLocation = floorBelow
        }
    }

    func remainingCost() -> Int {
        return floors.reversed().enumerated().reduce(0) { $0 + $1.offset * $1.element.devices.count }
    }

    func compress() -> Int {
        return allDevices().enumerated().reduce(elevatorLocation) { $0 | (floorForDevice($1.1) << ($1.0 * 2 + 2))}
    }
}

struct Path {
    var facility: Facility
    var cost = 0
    var length = 0

    init(facility: Facility) {
        self.facility = facility
    }

    static func < (lhs: Path, rhs: Path) -> Bool {
        return lhs.cost < rhs.cost
    }
}

final class Day11 {
    private let input1: String
    private let input2: String

    public init(input1: String = "The first floor contains a promethium generator and a promethium-compatible microchip.\nThe second floor contains a cobalt generator, a curium generator, a ruthenium generator, and a plutonium generator.\nThe third floor contains a cobalt-compatible microchip, a curium-compatible microchip, a ruthenium-compatible microchip, and a plutonium-compatible microchip.\nThe fourth floor contains nothing relevant.",
                input2: String = "The first floor contains a promethium generator, a promethium-compatible microchip, an elerium generator, an elerium-compatible microchip, a dilithium generator and a dilithium-compatible microchip.\nThe second floor contains a cobalt generator, a curium generator, a ruthenium generator, and a plutonium generator.\nThe third floor contains a cobalt-compatible microchip, a curium-compatible microchip, a ruthenium-compatible microchip, and a plutonium-compatible microchip.\nThe fourth floor contains nothing relevant.") {
        self.input1 = input1
        self.input2 = input2
    }

    public func solve() -> (String, String) {
        let shortestPath1 = leastStepsToFinish(parseInput(input1))
        let shortestPath2 = leastStepsToFinish(parseInput(input2))

        return (String(shortestPath1?.length ?? -1), String(shortestPath2?.length ?? -1))
    }

    private func leastStepsToFinish(_ startingFacility: Facility) -> Path? {
        print(startingFacility)
        var paths = PriorityQueue<Path>(sort: <)
        paths.enqueue(Path(facility: startingFacility))
        var visitedFacilities: SortedSet<Int> = [startingFacility.compress()]
        var shortestPath: Path?
        var lowestCost = Int.max

        while shortestPath == nil {

            guard let firstPath = paths.dequeue() else {
                break
            }


            possibleFacilities(byMoving: firstPath.facility).filter { visitedFacilities.insert($0.compress()).inserted }.forEach { facility in
                let remainingCost = facility.remainingCost()
                var path = Path(facility: facility)
                path.length = firstPath.length + 1
                path.cost = path.length + remainingCost

                if (remainingCost < lowestCost) {
                    lowestCost = remainingCost
                    print("----------")
                    print(path.facility)
                    print("LENGTH: ", path.length)
                    print("COST: ", remainingCost)
                    if lowestCost == 0 {
                        shortestPath = path
                        print("createdFacilities: ", visitedFacilities.count)
                    }
                }
                paths.enqueue(path)
            }

            if visitedFacilities.count % 10000 == 0 {
                print("visitedFacilities: ", visitedFacilities.count)
            }
        }

        return shortestPath
    }

    private func possibleFacilities(byMoving facility: Facility) -> [Facility] {
        return facility.possibleMoves().map { move in
            var newFacility = facility
            newFacility.perform(move)
            return newFacility
        }
    }

    private func parseInput(_ input: String) -> Facility {
        let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }
        var devicesOnFloors: [String: Set<Device>] = [:]

        for line in lines {
            let floorMatches = Regexp("The (\\w*) floor contains (.*)").captureGroupMatches(in: line)[0]
            if floorMatches.count == 1 {
                devicesOnFloors[floorMatches[0]] = []
            } else if floorMatches.count == 2 {
                let devicesMatches = Regexp("\\w+(?=(?:\\sgenerator|-compatible microchip))|generator|microchip").matches(in: floorMatches[1])
                var devices: [Device] = []
                for i in 0..<(devicesMatches.count / 2) {
                    if let element = Element(rawValue: devicesMatches[i*2]), let deviceType = DeviceType(rawValue: devicesMatches[i*2+1]) {
                        devices.append(Device(element: element, type: deviceType))
                    }
                }

                devicesOnFloors[floorMatches[0]] = Set(devices)
            }
        }

        let floors = ["first", "second", "third", "fourth"].map { Floor(devicesOnFloors[$0]!) }
        return Facility(floors)
    }
}

printTime {
    print(Day11().solve()) // success: 33, 57
}
