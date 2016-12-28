import Foundation
import AdventOfCodeHelpers
import CryptoSwift

struct Node: Hashable {
    let x: Int
    let y: Int
    let path: String

    var hashValue: Int {
        return x ^ y
    }

    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func neighbors(_ passcode: String) -> [Node] {
        var neighbors: [Node] = []

        let md5 = (passcode + path).md5()

        func isOpen(at index: Int) -> Bool {
            let character = String(md5.characters[md5.characters.index(md5.characters.startIndex, offsetBy: index)])
            return Int(character) == nil && character != "a"
        }

        if y - 1 >= 0 && isOpen(at: 0) {
            neighbors.append(Node(x: x, y: y - 1, path: path + "U"))
        }

        if y + 1 < 4 && isOpen(at: 1) {
            neighbors.append(Node(x: x, y: y + 1, path: path + "D"))
        }

        if x - 1 >= 0 && isOpen(at: 2) {
            neighbors.append(Node(x: x - 1, y: y, path: path + "L"))
        }

        if x + 1 < 4 && isOpen(at: 3) {
            neighbors.append(Node(x: x + 1, y: y, path: path + "R"))
        }

        return neighbors
    }
}

public class Day17 {
    let input: String

    public init(input: String = "njfxhljp") {
        self.input = input
    }

    public func solve() -> (String, String) {
        let passcode = input
        let startingNode = Node(x: 0, y: 0, path: "")
        let endNode = Node(x: 3, y: 3, path: "")
        var pendingNodes = [startingNode]
        var shortestPath: String? = nil
        var longestPath: String? = nil

        while !pendingNodes.isEmpty {
            pendingNodes.removeFirst().neighbors(passcode).forEach { node in
                if node == endNode {
                    if shortestPath == nil {
                        shortestPath = node.path
                    }
                    longestPath = node.path
                    print(node.path.characters.count)
                } else {
                    pendingNodes.append(node)
                }
            }
        }

        return (shortestPath ?? "error", String(longestPath?.characters.count ?? -1))
    }
}
