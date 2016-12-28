import Foundation
import AdventOfCodeHelpers

enum Tile {
    case safe
    case trap
}

struct Row: CustomStringConvertible {
    let tiles: [Tile]

    var description: String {
        return tiles.reduce("") { $0 + ($1 == .trap ? "^" : ".") }
    }

    var safeTilesCount: Int {
        return tiles.filter { $0 == .safe }.count
    }

    func nextRowTile(at index: Int) -> Tile {
        let leftTile = index - 1 >= 0 ? tiles[index - 1] : .safe
        //        let centerTile = tiles[index]
        let rightTile = index + 1 < tiles.count ? tiles[index + 1] : .safe

        if (leftTile == .trap && rightTile == .safe) || (leftTile == .safe && rightTile == .trap) {
            return .trap
        } else {
            return .safe
        }
    }
}

struct Room: CustomStringConvertible {
    let rows: [Row]

    init(startingRows: [Row], totalRows: Int) {
        var rows = startingRows

        for previousRowIndex in startingRows.count..<totalRows {
            var newTiles: [Tile] = []
            let previousRow = rows[previousRowIndex - 1]
            for rowIndex in previousRow.tiles.indices {
                newTiles.append(previousRow.nextRowTile(at: rowIndex))
            }
            rows.append(Row(tiles: newTiles))
            print(previousRowIndex)
        }

        self.rows = rows
    }

    var description: String {
        return rows.map { $0.description }.joined(separator: "\n")
    }

    var safeTilesCount: Int {
        return rows.reduce(0) { $0 + $1.safeTilesCount }
    }
}

public class Day18 {
    let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let firstRow = Row(tiles: parseInput())

        let smallRoom = Room(startingRows: [firstRow], totalRows: 40)
        let smallRoomSafeTilesCount = smallRoom.safeTilesCount
        print(smallRoomSafeTilesCount)

        let bigRoom = Room(startingRows: smallRoom.rows, totalRows: 400000)
        let bigRoomSafeTilesCount = bigRoom.safeTilesCount
        print(bigRoomSafeTilesCount)

        return (String(smallRoomSafeTilesCount), String(bigRoomSafeTilesCount))
    }

    private func parseInput() -> [Tile] {
        return input.trimmingCharacters(in: .whitespacesAndNewlines).characters.reduce([Tile]()) { $0 + [(String($1) == "^") ? Tile.trap : Tile.safe]}
    }
}
