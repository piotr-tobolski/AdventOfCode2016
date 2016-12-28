import Foundation
import AdventOfCodeHelpers

/*
 --- Day 1: No Time for a Taxicab ---

 Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars. Unfortunately, the stars have been stolen... by the Easter Bunny. To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.

 Collect stars by solving puzzles. Two puzzles will be made available on each day in the advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

 You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.

 The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.

 There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?

 For example:

 Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
 R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
 R5, L5, R5, R3 leaves you 12 blocks away.
 How many blocks away is Easter Bunny HQ?

 Your puzzle answer was 209.

 --- Part Two ---

 Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny HQ is actually at the first location you visit twice.

 For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East.

 How many blocks away is the first location you visit twice?

 Your puzzle answer was 136.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.

 You can also [Share] this puzzle.
 */

fileprivate struct Coordinates: Hashable {
    var hashValue: Int {
        return x & y<<16
    }

    static func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    let x: Int
    let y: Int

    func distanceFromCenter() -> UInt {
        return UInt(abs(x) + abs(y))
    }

    func moved(by distance: UInt, in direction: Direction) -> [Coordinates] {
        var newX = x
        var newY = y
        var visitedCoordinates: [Coordinates] = []

        for _ in 0..<distance {
            switch direction {
            case .N: newY += 1
            case .S: newY -= 1
            case .W: newX -= 1
            case .E: newX += 1
            }
            visitedCoordinates.append(Coordinates(x: newX, y: newY))
        }

        return visitedCoordinates
    }
}

fileprivate enum MovementDirection: String {
    case L
    case R
}

fileprivate struct Movement {
    let direction: MovementDirection
    let distance: UInt
}

fileprivate enum Direction: String {
    case N
    case S
    case W
    case E

    func moved(by movementDirection: MovementDirection) -> Direction {
        switch movementDirection {
        case .L:
            switch self {
            case .N: return .W
            case .S: return .E
            case .W: return .S
            case .E: return .N
            }
        case .R:
            switch self {
            case .N: return .E
            case .S: return .W
            case .W: return .N
            case .E: return .S
            }
        }
    }
}

fileprivate struct Position {
    let direction: Direction
    let coordinates: Coordinates

    init() {
        self.init(direction: .N, coordinates: Coordinates(x: 0, y: 0))
    }

    private init(direction: Direction, coordinates: Coordinates) {
        self.direction = direction
        self.coordinates = coordinates
    }

    func moved(by movement: Movement) -> (newPosition: Position, visitedCoordinates: [Coordinates]) {
        let newDirection = direction.moved(by: movement.direction)
        let visitedCoordinates = coordinates.moved(by: movement.distance, in: newDirection)
        let newCoordinates = visitedCoordinates.last ?? coordinates
        return (newPosition: Position(direction: newDirection, coordinates: newCoordinates), visitedCoordinates: visitedCoordinates)
    }
}

public class Day1 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (finalPosition: String, firstVisitedTwice: String?) {
        let movements = input.trimmingCharacters(in: .newlines).components(separatedBy: ", ").flatMap { component -> Movement? in
            let idx = component.index(after: component.startIndex)
            let directionString = component.substring(to: idx)
            let distanceString = component.substring(from: idx)

            guard let direction = MovementDirection(rawValue: directionString), let distance = UInt(distanceString) else {
                return nil
            }

            return Movement(direction: direction, distance: distance)
        }

        var allVisitedCoordinates: Set<Coordinates> = [Coordinates(x: 0, y: 0)]
        var firstVisitedTwice: Coordinates?

        let finalPosition = movements.reduce(Position()) {
            let moveResult = $0.moved(by: $1)
            let newPosition = moveResult.newPosition
            if firstVisitedTwice == nil {
                let visitedCoordinates = moveResult.visitedCoordinates
                for coordinates in visitedCoordinates {
                    if !allVisitedCoordinates.insert(coordinates).inserted {
                        firstVisitedTwice = coordinates
                        break;
                    }
                }
            }

            return newPosition
            }.coordinates.distanceFromCenter()

        if let firstVisitedTwice = firstVisitedTwice?.distanceFromCenter() {
            return (String(finalPosition), String(firstVisitedTwice))
        }
        
        return (String(finalPosition), nil)
    }
}

printTime {
    print(Day1().solve()) //success: 209, 136
}
