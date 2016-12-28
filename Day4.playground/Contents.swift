import Foundation
import AdventOfCodeHelpers

/*
 --- Day 4: Security Through Obscurity ---

 Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.

 Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.

 A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:

 aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
 a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
 not-a-real-room-404[oarel] is a real room.
 totally-real-room-200[decoy] is not.
 Of the real rooms from the list above, the sum of their sector IDs is 1514.

 What is the sum of the sector IDs of the real rooms?

 Your puzzle answer was 185371.

 --- Part Two ---

 With all the decoy data out of the way, it's time to decrypt this list and get moving.

 The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software. However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like yourself.

 To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.

 For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.

 What is the sector ID of the room where North Pole objects are stored?

 Your puzzle answer was 984.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.

 You can also [Share] this puzzle.
 */

fileprivate struct Room {
    let nameComponents: [String]
    let sectorID: UInt
    let checksum: String

    init?(string: String) {
        let components = string.components(separatedBy: "-")
        nameComponents = Array(components[0..<(components.count-1)])

        let lastComponent = components.last!

        guard let openingBraceIndex = lastComponent.range(of: "[") else { return nil }
        guard let sectorID = UInt(lastComponent.substring(to: openingBraceIndex.lowerBound)) else { return nil }
        self.sectorID = sectorID

        guard let closingBraceIndex = lastComponent.range(of: "]") else { return nil }
        let checksumRange = Range(uncheckedBounds: (lower: openingBraceIndex.upperBound, upper: closingBraceIndex.lowerBound))
        checksum = lastComponent.substring(with: checksumRange)
    }

    func isValid() -> Bool {
        var charactersCount: [Character:UInt] = [:]
        let characters = nameComponents.joined().characters
        for character in characters {
            charactersCount[character] = (charactersCount[character] ?? 0) + 1
        }

        let sortedCharacters = charactersCount.sorted {
            $0.0.value == $0.1.value ? $0.0.key < $0.1.key : $0.0.value > $0.1.value
            }.reduce("") { $0 + String($1.key) }

        return sortedCharacters.hasPrefix(checksum)
    }

    func decryptedName() -> String {
        return nameComponents.flatMap { $0.decryptShiftCipher(offset: Int(sectorID)) }.joined(separator: " ")
    }
}

fileprivate extension String {
    func decryptShiftCipher(offset: Int) -> String? {
        let cipher = "abcdefghijklmnopqrstuvwxyz"

        var decryptedString = ""
        for character in self.characters {
            guard let range = cipher.range(of: String(character)) else { return nil }
            let position = cipher.substring(to: range.lowerBound).characters.count
            let cipherCharacters = cipher.characters
            let newPosition = (position + offset) % cipherCharacters.count
            let newPositionIndex = cipherCharacters.index(cipherCharacters.startIndex, offsetBy: newPosition)
            decryptedString.append(cipherCharacters[newPositionIndex])
        }
        return decryptedString
    }
}

public class Day4 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (sum: String, sectorID: String) {
        let rooms = input.components(separatedBy: "\n").flatMap(Room.init(string:))
        let validRooms = rooms.filter { $0.isValid() }
        let validChecksumSum = validRooms.reduce(UInt(0)) { $0 + $1.sectorID }
        let northPoleRooms = validRooms.filter { $0.decryptedName().contains("northpole") }
        assert(northPoleRooms.count == 1)

        return (sum: String(validChecksumSum), sectorID: String(northPoleRooms[0].sectorID))
    }
}

printTime {
    print(Day4().solve()) //success: 185371, 984
}
