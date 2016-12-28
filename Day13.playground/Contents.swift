import Foundation
import AdventOfCodeHelpers

/*
 --- Day 13: A Maze of Twisty Little Cubicles ---

 You arrive at the first floor of this new building to discover a much less welcoming environment than the shiny atrium of the last one. Instead, you are in a maze of twisty little cubicles, all alike.

 Every location in this area is addressed by a pair of non-negative integers (x,y). Each such coordinate is either a wall or an open space. You can't move diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward positive x and y; negative values are invalid, as they represent a location outside the building. You are in a small waiting area at 1,1.

 While it seems chaotic, a nearby morale-boosting poster explains, the layout is actually quite logical. You can determine whether a given x,y coordinate will be a wall or an open space using a simple system:

 Find x*x + 3*x + 2*x*y + y + y*y.
 Add the office designer's favorite number (your puzzle input).
 Find the binary representation of that sum; count the number of bits that are 1.
 If the number of bits that are 1 is even, it's an open space.
 If the number of bits that are 1 is odd, it's a wall.
 For example, if the office designer's favorite number were 10, drawing walls as # and open spaces as ., the corner of the building containing 0,0 would look like this:

 0123456789
 0 .#.####.##
 1 ..#..#...#
 2 #....##...
 3 ###.#.###.
 4 .##..#..#.
 5 ..##....#.
 6 #...##.###
 Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as O:

 0123456789
 0 .#.####.##
 1 .O#..#...#
 2 #OOO.##...
 3 ###O#.###.
 4 .##OO#OO#.
 5 ..##OOO.#.
 6 #...##.###
 Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current location, 1,1).

 What is the fewest number of steps required for you to reach 31,39?

 Your puzzle answer was 92.

 --- Part Two ---

 How many locations (distinct x,y coordinates, including your starting location) can you reach in at most 50 steps?

 Your puzzle answer was 124.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 Your puzzle input was 1350.
 
 You can also [Share] this puzzle.
 */

extension UInt {
    var bitCount: Int {
        var bitCount = 0
        var selfCopy = self
        while selfCopy != 0 {
            if selfCopy & 1 == 1 {
                bitCount += 1
            }
            selfCopy >>= 1
        }
        return bitCount
    }
}

struct Node: Hashable {
    let x: Int
    let y: Int
    var cost: Int

    var hashValue: Int {
        return x ^ y
    }

    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func neighbors(_ officeDesignersFavoriteNumber: Int) -> [Node] {
        var neighbors: [Node] = []
        [-1, 1].forEach {
            let horizontalNeighbor = Node(x: x + $0, y: y, cost: cost + 1)
            if horizontalNeighbor.x >= 0 && horizontalNeighbor.isValid(officeDesignersFavoriteNumber) {
                neighbors.append(horizontalNeighbor)
            }

            let verticalNeighbor = Node(x: x, y: y + $0, cost: cost + 1)
            if verticalNeighbor.y >= 0 && verticalNeighbor.isValid(officeDesignersFavoriteNumber) {
                neighbors.append(verticalNeighbor)
            }
        }
        return neighbors
    }

    func isValid(_ officeDesignersFavoriteNumber: Int) -> Bool {
        let equation = x*x + 3*x + 2*x*y + y + y*y + officeDesignersFavoriteNumber
        return UInt(equation).bitCount % 2 == 0
    }

}

class Day13 {
    let input: String

    init(input: String = "1350") {
        self.input = input
    }

    func solve() -> (String, String) {
        let officeDesignersFavoriteNumber = Int(input)!
        let startingNode = Node(x: 1, y: 1, cost: 0)
        let endNode = Node(x: 31, y: 39, cost: -1)
        var pendingNodes = [startingNode]
        var visitedNodes = Set<Node>([startingNode])
        var finalCost: Int? = nil
        var numberOfLocationsWithMax50Steps: Int? = nil

        while !pendingNodes.isEmpty && (finalCost == nil || numberOfLocationsWithMax50Steps == nil) {
            let bestNode = pendingNodes.removeFirst()
            bestNode.neighbors(officeDesignersFavoriteNumber).filter { visitedNodes.insert($0).inserted }.forEach { node in
                pendingNodes.append(node)

                if node == endNode {
                    finalCost = node.cost
                    print("visited: ", visitedNodes.count)
                }
            }

            if numberOfLocationsWithMax50Steps == nil && bestNode.cost > 50 {
                numberOfLocationsWithMax50Steps = visitedNodes.filter { $0.cost <= 50 }.count
            }
        }

        var string = ""
        for i in 0...50 {
            for j in 0...50 {
                let node = Node(x: i, y: j, cost: 0)
                if node == startingNode {
                    string.append("SS")
                } else if node == endNode {
                    string.append("FF")
                } else if let index = visitedNodes.index(of: node) {
                    if visitedNodes[index].cost <= 9 {
                        string.append("0")
                        string.append(String(visitedNodes[index].cost))
                    } else if visitedNodes[index].cost <= 50 {
                        string.append(String(visitedNodes[index].cost))
                    } else {
                        string.append("--")
                    }
                } else if node.isValid(officeDesignersFavoriteNumber) {
                    string.append("  ")
                } else {
                    string.append("[]")
                }
            }
            string.append("\n");
        }
        print(string)

        return (String(finalCost ?? -1), String(numberOfLocationsWithMax50Steps ?? -1))
    }
}

printTime {
    print(Day13().solve()) // 92, 124
}
