import Foundation
import AdventOfCodeHelpers

struct Coordinate: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var hashValue: Int {
        return x ^ y
    }

    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    var description: String {
        return "(\(x), \(y))"
    }

    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    var neighbors: [Coordinate] {
        return [Coordinate(x: 0, y: 1),
                Coordinate(x: 0, y: -1),
                Coordinate(x: 1, y: 0),
                Coordinate(x: -1, y: 0)].map { self + $0 }
    }
}

class Map {
    let locations: [[Location]]

    init(_ locations: [[Location]]) {
        self.locations = locations
    }

    enum Location: Equatable {
        case open
        case wall
        case marked(Int)

        static func ==(lhs: Location, rhs: Location) -> Bool {
            switch (lhs, rhs) {
            case (.open, .open): return true
            case (.wall, .wall): return true
            case (.marked(let a), .marked(let b)) where a == b: return true
            default: return false
            }
        }
    }

    subscript(_ coordinate: Coordinate) -> Location {
        return locations[coordinate.y][coordinate.x]
    }

    lazy var markedCoordinates: [Int: Coordinate] = {
        var markedCoordinates: [Int: Coordinate] = [:]
        self.locations.enumerated().forEach { y, line in
            line.enumerated().forEach { x, location in
                if case .marked(let mark) = location {
                    markedCoordinates[mark] = Coordinate(x: x, y: y)
                }
            }
        }
        return markedCoordinates
    }()

    private var shortestPathCache: [Set<Coordinate>: Int] = [:]

    func shortestPath(from startCoordinate: Coordinate, to endCoordinate: Coordinate) -> Int? {
        let cacheKey = Set([startCoordinate, endCoordinate])
        if let cachedValue = shortestPathCache[cacheKey] {
            return cachedValue
        }

        struct Path {
            let lastCoordinate: Coordinate
            let cost: Int
        }

        var paths = [Path(lastCoordinate: startCoordinate, cost: 0)]
        var visitedCoordinates: Set<Coordinate> = [startCoordinate]

        while !paths.isEmpty {
            let bestPath = paths.removeFirst()

            if bestPath.lastCoordinate == endCoordinate {
                shortestPathCache[cacheKey] = bestPath.cost
                return bestPath.cost
            }

            paths += bestPath
                .lastCoordinate
                .neighbors
                .filter { self[$0] != .wall }
                .filter { visitedCoordinates.insert($0).inserted }
                .map { Path(lastCoordinate: $0, cost: bestPath.cost + 1) }
        }
        
        return nil
    }
}

public class Day24 {
    let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let map = parseInput()
        let startCoordinate = map.markedCoordinates[0]!

        let shortestPath = calculateShortestPath(in: map, starting: startCoordinate, visiting: map.markedCoordinates.values.filter { $0 != startCoordinate})
        let shortestPathReturningToStart = calculateShortestPath(in: map, starting: startCoordinate, visiting: map.markedCoordinates.map { $1 })

        return (String(shortestPath ?? -1), String(shortestPathReturningToStart ?? -1))
    }

    private func calculateShortestPath(in map: Map, starting startCoordinate: Coordinate, visiting coordinatesToVisit: [Coordinate]) -> Int? {
        struct Path {
            let coordinates: [Coordinate]
            let cost: Int
        }

        var paths = [Path(coordinates: [startCoordinate], cost: 0)]
        var shortestPath: Path?

        while !paths.isEmpty {
            paths.sort { $0.0.cost < $0.1.cost }
            let bestPath = paths.removeFirst()

            if bestPath.coordinates.count == coordinatesToVisit.count + 1 {
                shortestPath = bestPath
                break
            }

            paths += coordinatesToVisit
                .filter { !bestPath.coordinates.contains($0) || ($0 == startCoordinate && bestPath.coordinates.count == coordinatesToVisit.count) }
                .map {
                Path(coordinates: bestPath.coordinates + [$0], cost: bestPath.cost + map.shortestPath(from: bestPath.coordinates.last!, to: $0)!)
            }
        }

        return shortestPath?.cost
    }

    private func parseInput() -> Map {
        return Map(input.components(separatedBy: "\n").enumerated().map { lineIndex, line in
            line.characters.map(String.init(_:)).enumerated().map { characterIndex, character -> Map.Location in
                if character == "#" {
                    return .wall
                } else if character == "." {
                    return .open
                } else {
                    return .marked(Int(character)!)
                }
            }
        })
    }
}
