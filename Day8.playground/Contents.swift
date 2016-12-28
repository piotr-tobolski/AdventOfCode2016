import Foundation
import AdventOfCodeHelpers

/*
 --- Day 8: Two-Factor Authentication ---

 You come across a door implementing what you can only assume is an implementation of two-factor authentication after a long game of requirements telephone.

 To get past the door, you first swipe a keycard (no problem; there was one on a nearby desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then, presumably, the door unlocks.

 Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart and figured out how it works. Now you just have to work out what the screen would have displayed.

 The magnetic strip on the card you swiped encodes a series of instructions for the screen; these instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which start off, and is capable of three somewhat peculiar operations:

 rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide and B tall.
 rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B pixels. Pixels that would fall off the right end appear at the left end of the row.
 rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B pixels. Pixels that would fall off the bottom appear at the top of the column.
 For example, here is a simple sequence on a smaller screen:

 rect 3x2 creates a small rectangle in the top-left corner:

 ###....
 ###....
 .......
 rotate column x=1 by 1 rotates the second column down by one pixel:

 #.#....
 ###....
 .#.....
 rotate row y=0 by 4 rotates the top row right by four pixels:

 ....#.#
 ###....
 .#.....
 rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top:

 .#..#.#
 #.#....
 .#.....
 As you can see, this display technology is extremely powerful, and will soon dominate the tiny-code-displaying-screen market. That's what the advertisement on the back of the display tries to convince you, anyway.

 There seems to be an intermediate check of the voltage used by the display: after you swipe your card, if the screen did work, how many pixels should be lit?

 Your puzzle answer was 123.

 --- Part Two ---

 You notice that the screen is only capable of displaying capital letters; in the font it uses, each letter is 5 pixels wide and 6 tall.

 After you swipe your card, what code is the screen trying to display?

 Your puzzle answer was AFBUPZBJPS.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.

 You can also [Share] this puzzle.
 */

fileprivate enum Command {
    case rect(width: UInt, height: UInt)
    case rotateRow(_: UInt, by: UInt)
    case rotateColumn(_: UInt, by: UInt)

    private static let rectCommand = "rect "
    private static let rotateRowCommand = "rotate row y="
    private static let rotateColumnCommand = "rotate column x="

    static func from(string: String) -> Command? {
        if let index = string.range(of: rectCommand)?.upperBound {
            let components = string.substring(from: index).components(separatedBy: "x")
            return Command.rect(width: UInt(components[0])!, height: UInt(components[1])!)
        } else if let index = string.range(of: rotateRowCommand)?.upperBound {
            let components = string.substring(from: index).components(separatedBy: " by ")
            return Command.rotateRow(UInt(components[0])!, by: UInt(components[1])!)
        } else if let index = string.range(of: rotateColumnCommand)?.upperBound {
            let components = string.substring(from: index).components(separatedBy: " by ")
            return Command.rotateColumn(UInt(components[0])!, by: UInt(components[1])!)
        }
        return nil
    }
}

fileprivate class Board {
    let width: UInt
    let height: UInt
    var board: [[Bool]]

    init(width: UInt = 50, height: UInt = 6) {
        self.width = width
        self.height = height
        board = Array(repeatElement(Array(repeatElement(false, count: Int(height))), count: Int(width)))
    }

    subscript(x: UInt, y: UInt) -> Bool {
        get {
            precondition(x < width && y < height)
            return board[Int(x)][Int(y)]
        }

        set(newValue) {
            precondition(x < width && y < height)
            board[Int(x)][Int(y)] = newValue
        }
    }

    func perform(command: Command) {
        switch command {
        case .rect(let width, let height):
            for i in 0..<width {
                for j in 0..<height {
                    self[i, j] = true
                }
            }
        case .rotateRow(let row, let by):
            var newRow:[Bool] = []
            for i in 0..<width {
                newRow.append(self[(width + i - by) % width, row])
            }
            for i in 0..<width {
                self[i, row] = newRow[Int(i)]
            }
        case .rotateColumn(let column, let by):
            var newColumn:[Bool] = []
            for i in 0..<height {
                newColumn.append(self[column, (height + i - by) % height])
            }
            for i in 0..<height {
                self[column, i] = newColumn[Int(i)]
            }
        }
    }

    func litCount() -> UInt {
        return board.reduce(UInt(0)) {
            $0 + $1.reduce(UInt(0)) {
                $1 ? $0 + 1 : $0
            }
        }
    }

    func boardString() -> String {
        var transposedBoard = Array(repeatElement(Array(repeatElement(false, count: Int(width))), count: Int(height)))

        for i in 0..<width {
            for j in 0..<height {
                transposedBoard[Int(j)][Int(i)] = self[i, j]
            }
        }

        return transposedBoard.map {
            $0.reduce("") {
                $0 + ($1 ? "#" : " ")
            }
            }.joined(separator: "\n")
    }
}

public class Day8 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let commands = input.components(separatedBy: "\n").flatMap(Command.from(string:))
        let board = Board()
        for command in commands {
            board.perform(command: command)
        }
        
        return (String(board.litCount()), board.boardString())
    }
}

printTime {
    let solution = Day8().solve() //success: 123, AFBUPZBJPS
    print(solution.0)
    print(solution.1)
}
