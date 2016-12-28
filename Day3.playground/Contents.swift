import Foundation
import AdventOfCodeHelpers

/*
 --- Day 3: Squares With Three Sides ---

 Now that you can think clearly, you move deeper into the labyrinth of hallways and office furniture that makes up this part of Easter Bunny HQ. This must be a graphic design department; the walls are covered in specifications for triangles.

 Or are they?

 The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You can't help but mark the impossible ones.

 In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above is impossible, because 5 + 10 is not larger than 25.

 In your puzzle input, how many of the listed triangles are possible?

 Your puzzle answer was 982.

 --- Part Two ---

 Now that you've helpfully marked up their design documents, it occurs to you that triangles are specified in groups of three vertically. Each set of three numbers in a column specifies a triangle. Rows are unrelated.

 For example, given the following specification, numbers with the same hundreds digit would be part of the same triangle:

 101 301 501
 102 302 502
 103 303 503
 201 401 601
 202 402 602
 203 403 603
 In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?

 Your puzzle answer was 1826.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.

 You can also [Share] this puzzle.
 */

fileprivate struct Triangle {
    let sides: [UInt]

    func isPossible() -> Bool {
        let sortedSides = sides.sorted()
        return sortedSides[2] < sortedSides[1] + sortedSides[0]
    }
}

public class Day3 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let parsedInput: [[UInt]] = input.components(separatedBy: "\n").filter { !$0.isEmpty }.map {
            let scanner = Scanner(string: $0)

            var int: Int = 0
            var sides: [UInt] = []
            while scanner.scanInt(&int) {
                sides.append(UInt(int))
            }
            assert(sides.count == 3)
            return sides
        }
        let triangles = parsedInput.map(Triangle.init(sides:))
        var mixedTriangles: [Triangle] = []
        for i in stride(from: 0, to: triangles.count, by: 3) {
            for j in 0..<3 {
                mixedTriangles.append(Triangle(sides:[parsedInput[i][j]] + [parsedInput[i+1][j]] + [parsedInput[i+2][j]]))
            }
        }

        let possibleTriangles = String(triangles.filter { $0.isPossible() }.count)
        let possibleMixedTriangles = String(mixedTriangles.filter { $0.isPossible() }.count)
        return (possibleTriangles, possibleMixedTriangles)
    }
}

printTime {
    print(Day3().solve()) //success: 982, 1826
}
