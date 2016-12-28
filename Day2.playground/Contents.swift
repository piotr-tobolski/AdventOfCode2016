import Foundation
import AdventOfCodeHelpers

/*
 --- Day 2: Bathroom Security ---

 You arrive at Easter Bunny Headquarters under cover of darkness. However, you left in such a rush that you forgot to use the bathroom! Fancy office buildings like this one usually have keypad locks on their bathrooms, so you search the front desk for the code.

 "In order to improve security," the document you find says, "bathroom codes will no longer be written down. Instead, please memorize and follow the procedure below to access the bathrooms."

 The document goes on to explain that each button to be pressed can be found by starting on the previous button and moving to adjacent buttons on the keypad: U moves up, D moves down, L moves left, and R moves right. Each line of instructions corresponds to one button, starting at the previous button (or, for the first line, the "5" button); press whatever button you're on at the end of each line. If a move doesn't lead to a button, ignore it.

 You can't hold it much longer, so you decide to figure out the code as you walk to the bathroom. You picture a keypad like this:

 1 2 3
 4 5 6
 7 8 9
 Suppose your instructions are:

 ULL
 RRDDD
 LURDL
 UUUUD
 You start at "5" and move up (to "2"), left (to "1"), and left (you can't, and stay on "1"), so the first button is 1.
 Starting from the previous button ("1"), you move right twice (to "3") and then down three times (stopping at "9" after two moves and ignoring the third), ending up with 9.
 Continuing from "9", you move left, up, right, down, and left, ending with 8.
 Finally, you move up four times (stopping at "2"), then down once, ending with 5.
 So, in this example, the bathroom code is 1985.

 Your puzzle input is the instructions from the document you found at the front desk. What is the bathroom code?

 Your puzzle answer was 35749.

 --- Part Two ---

 You finally arrive at the bathroom (it's a several minute walk from the lobby so visitors can behold the many fancy conference rooms and water coolers on this floor) and go to punch in the code. Much to your bladder's dismay, the keypad is not at all like you imagined it. Instead, you are confronted with the result of hundreds of man-hours of bathroom-keypad-design meetings:

 1
 2 3 4
 5 6 7 8 9
 A B C
 D
 You still start at "5" and stop when you're at an edge, but given the same instructions as above, the outcome is very different:

 You start at "5" and don't move at all (up and left are both edges), ending at 5.
 Continuing from "5", you move right twice and down three times (through "6", "7", "B", "D", "D"), ending at D.
 Then, from "D", you move five more times (through "D", "B", "C", "C", "B"), ending at B.
 Finally, after five more moves, you end at 3.
 So, given the actual keypad layout, the code would be 5DB3.

 Using the same instructions in your puzzle input, what is the correct bathroom code?

 Your puzzle answer was 9365C.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.

 You can also [Share] this puzzle.
 */

fileprivate enum Direction: String {
    case U
    case D
    case L
    case R
}

fileprivate enum Key {
    case key1
    case key2
    case key3
    case key4
    case key5
    case key6
    case key7
    case key8
    case key9

    func moved(to direction: Direction) -> Key {
        switch self {
        case .key1:
            switch direction {
            case .D: return .key4
            case .R: return .key2
            default: break
            }
        case .key2:
            switch direction {
            case .D: return .key5
            case .L: return .key1
            case .R: return .key3
            default: break
            }
        case .key3:
            switch direction {
            case .D: return .key6
            case .L: return .key2
            default: break
            }
        case .key4:
            switch direction {
            case .U: return .key1
            case .D: return .key7
            case .R: return .key5
            default: break
            }
        case .key5:
            switch direction {
            case .U: return .key2
            case .D: return .key8
            case .L: return .key4
            case .R: return .key6
            }
        case .key6:
            switch direction {
            case .U: return .key3
            case .D: return .key9
            case .L: return .key5
            default: break
            }
        case .key7:
            switch direction {
            case .U: return .key4
            case .R: return .key8
            default: break
            }
        case .key8:
            switch direction {
            case .U: return .key5
            case .L: return .key7
            case .R: return .key9
            default: break
            }
        case .key9:
            switch direction {
            case .U: return .key6
            case .L: return .key8
            default: break
            }
        }
        return self
    }

    func text() -> String {
        switch self {
        case .key1: return "1"
        case .key2: return "2"
        case .key3: return "3"
        case .key4: return "4"
        case .key5: return "5"
        case .key6: return "6"
        case .key7: return "7"
        case .key8: return "8"
        case .key9: return "9"
        }
    }
}

fileprivate enum WeirdKey {
    case key1
    case key2
    case key3
    case key4
    case key5
    case key6
    case key7
    case key8
    case key9
    case keyA
    case keyB
    case keyC
    case keyD

    func moved(to direction: Direction) -> WeirdKey {
        switch self {
        case .key1:
            switch direction {
            case .D: return .key3
            default: break
            }
        case .key2:
            switch direction {
            case .D: return .key6
            case .R: return .key3
            default: break
            }
        case .key3:
            switch direction {
            case .U: return .key1
            case .D: return .key7
            case .L: return .key2
            case .R: return .key4
            }
        case .key4:
            switch direction {
            case .D: return .key8
            case .L: return .key3
            default: break
            }
        case .key5:
            switch direction {
            case .R: return .key6
            default: break
            }
        case .key6:
            switch direction {
            case .U: return .key2
            case .D: return .keyA
            case .L: return .key5
            case .R: return .key7
            }
        case .key7:
            switch direction {
            case .U: return .key3
            case .D: return .keyB
            case .L: return .key6
            case .R: return .key8
            }
        case .key8:
            switch direction {
            case .U: return .key4
            case .D: return .keyC
            case .L: return .key7
            case .R: return .key9
            }
        case .key9:
            switch direction {
            case .L: return .key8
            default: break
            }
        case .keyA:
            switch direction {
            case .U: return .key6
            case .R: return .keyB
            default: break
            }
        case .keyB:
            switch direction {
            case .U: return .key7
            case .D: return .keyD
            case .L: return .keyA
            case .R: return .keyC
            }
        case .keyC:
            switch direction {
            case .U: return .key8
            case .L: return .keyB
            default: break
            }
        case .keyD:
            switch direction {
            case .U: return .keyB
            default: break
            }
        }
        return self
    }

    func text() -> String {
        switch self {
        case .key1: return "1"
        case .key2: return "2"
        case .key3: return "3"
        case .key4: return "4"
        case .key5: return "5"
        case .key6: return "6"
        case .key7: return "7"
        case .key8: return "8"
        case .key9: return "9"
        case .keyA: return "A"
        case .keyB: return "B"
        case .keyC: return "C"
        case .keyD: return "D"
        }
    }
}

public class Day2 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let allDirections = input.components(separatedBy: "\n").filter { !$0.isEmpty }.map {
            $0.characters.reduce([Direction]()) { arr, char in
                if let direction = Direction(rawValue: String(char)) {
                    return arr + [direction]
                }
                return arr
            }
        }

        var lastKey = Key.key5
        let keys = allDirections.map { directions -> Key in
            for direction in directions {
                lastKey = lastKey.moved(to: direction)
            }

            return lastKey
        }

        var lastWeirdKey = WeirdKey.key5
        let weirdKeys = allDirections.map { directions -> WeirdKey in
            for direction in directions {
                lastWeirdKey = lastWeirdKey.moved(to: direction)
            }

            return lastWeirdKey
        }

        let keysString = keys.map { $0.text() }.reduce("", +)
        let weirdKeysString = weirdKeys.map { $0.text() }.reduce("", +)
        return (keysString, weirdKeysString)
    }
}

printTime {
    print(Day2().solve()) //success: 35749, 9365C
}
