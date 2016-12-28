import Foundation
import AdventOfCodeHelpers

struct Node: Hashable {
    let x: Int
    let y: Int

    enum Status {
        case full
        case empty
        case blocked
//        case direct
        case goal
    }

    var status: Status

    var hashValue: Int {
        return x ^ y
    }

    public static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class StorageCluster: CustomStringConvertible, Hashable {
    private let nodes: [Node]
    let steps: Int

    init(_ nodes: [Node], steps: Int = 0) {
        self.nodes = nodes//.sorted { $0.0.x == $0.1.x ? $0.0.y < $0.1.y : $0.0.x < $0.1.x }
        self.steps = steps
    }

    subscript(_ x: Int, _ y: Int) -> Node {
        get {
            return nodes[x * 27 + y]
        }
        set {

        }
    }

    lazy var description: String = {
        var description = ""
        for y in 0...26 {
            for x in 0...36 {
                if (x == 0 && y == 0) {
                    description.append("(")
                } else {
                    description.append(" ")
                }

                let node = self[x, y]
                switch node.status {
                case .full:
                    description.append(".")
                case .empty:
                    description.append("o")
                case .blocked:
                    description.append("#")
                case .goal:
                    description.append("G")
                }

                if (x == 0 && y == 0) {
                    description.append(")")
                } else {
                    description.append(" ")
                }
            }
            description.append("\n")
        }
        return description
    }()

    private lazy var goalNode: Node = {
        return self.nodes.first { $0.status == .goal }!
    }()

    private lazy var emptyNode: Node = {
        return self.nodes.first { $0.status == .empty }!
    }()

    private lazy var emptyToGoalDistance: Int = {
        return abs(self.goalNode.x - 1 - self.emptyNode.x) + abs(self.goalNode.y - self.emptyNode.y)
    }()

    lazy var remainingCost: Int =  {
        let distanceToGoal = self.goalNode.x + self.goalNode.y
        guard distanceToGoal > 0 else { return 0 }
        return 10 * (self.emptyToGoalDistance + distanceToGoal * 5) + self.steps
    }()

    static func ==(lhs: StorageCluster, rhs: StorageCluster) -> Bool {
//        return lhs.nodes == rhs.nodes
        return lhs.goalNode == rhs.goalNode && lhs.emptyNode == rhs.emptyNode
    }

    var hashValue: Int {
        return steps
    }

    func possibleStorageClusters() -> [StorageCluster] {
        var possibleStorageClusters: [StorageCluster] = []
        if emptyToGoalDistance == 0 {
            var newNodes = self.nodes
            newNodes[emptyNode.x * 27 + emptyNode.y].status = .goal
            newNodes[goalNode.x * 27 + goalNode.y].status = .empty
            possibleStorageClusters.append(StorageCluster(newNodes, steps: steps + 1))
        } else {
            [-1, 1].forEach {
                let offsetX = emptyNode.x + $0
                if offsetX >= 0 && offsetX <= 36 && self[offsetX, emptyNode.y].status == .full {
                    var newNodes = self.nodes
                    newNodes[emptyNode.x * 27 + emptyNode.y].status = .full
                    newNodes[offsetX * 27 + emptyNode.y].status = .empty
                    possibleStorageClusters.append(StorageCluster(newNodes, steps: steps + 1))
                }

                let offsetY = emptyNode.y + $0
                if offsetY >= 0 && offsetY <= 26 && self[emptyNode.x, offsetY].status == .full {
                    var newNodes = self.nodes
                    newNodes[emptyNode.x * 27 + emptyNode.y].status = .full
                    newNodes[emptyNode.x * 27 + offsetY].status = .empty
                    possibleStorageClusters.append(StorageCluster(newNodes, steps: steps + 1))
                }
            }
        }
        return possibleStorageClusters
    }
}

//struct StorageClusterOffset {
//    let emptyX: Int
//    let emptyY: Int
//    let goalX: Int
//    let goalY: Int
//    let cost: Int
//    let remainingCost: Int
//
//    func possibleMoves(whenBlocked: [Node]) -> [StorageClusterOffset] {
//
//        return []
//    }
//}

public class Day22 {
    let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let nodes = parseInput()
        let possiblePairsCount = nodes.filter { $0.status == .full }.count
        let startingCluster = StorageCluster(nodes)

        var pendingStorageClusters = [startingCluster]
        var visitedStorageClusters = Set<StorageCluster>([startingCluster])
        var finalSteps: Int?

        while !pendingStorageClusters.isEmpty && finalSteps == nil {
            pendingStorageClusters.sort { $0.0.remainingCost < $0.1.remainingCost }

            let bestCluster = pendingStorageClusters.removeFirst()
            bestCluster.possibleStorageClusters().filter { visitedStorageClusters.insert($0).inserted }.forEach { storageCluster in
                pendingStorageClusters.append(storageCluster)

                if storageCluster.remainingCost == 0 {
                    finalSteps = storageCluster.steps
                    print("visited: ", visitedStorageClusters.count)
                }
            }
        }

        return (String(possiblePairsCount), String(finalSteps ?? -1))
    }

    private func parseInput() -> [Node] {
        return input
            .components(separatedBy: "\n")
            .map { Regexp("/dev/grid/node-x(\\d+)-y(\\d+)\\s+\\d+T\\s+(\\d+)T").captureGroupMatches(in: $0) }
            .flatMap { $0.first }
            .map {
                let x = Int($0[0])!
                let y = Int($0[1])!
                let used = Int($0[2])!
                let status: Node.Status
                if x == 36 && y == 0 {
                    status = .goal
                } else if used == 0 {
                    status = .empty
                } else if used > 400 {
                    status = .blocked
                } else {
                    status = .full
                }
                return Node(x: x, y: y, status: status)
        }
    }
}
