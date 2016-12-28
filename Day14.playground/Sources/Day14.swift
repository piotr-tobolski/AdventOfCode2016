import Foundation
import CryptoSwift

extension String {
    func hasThreeInARow() -> UTF8.CodeUnit? {
        var counter = 1
        var previousCharacter = UInt8(0)
        for containingCharacter in self.utf8 {
            if containingCharacter == previousCharacter {
                counter += 1
            } else {
                counter = 1
                previousCharacter = containingCharacter
            }
            if counter == 3 {
                return containingCharacter
            }
        }
        return nil
    }

    func hasFiveInARow(_ character: UTF8.CodeUnit) -> Bool {
        var counter = 0
        for containingCharacter in self.utf8 {
            if containingCharacter == character {
                counter += 1
            } else {
                counter = 0
            }

            if counter == 5 {
                return true
            }
        }
        return false
    }
}

public class Day14 {
    let input: String

    public init(input: String = "ngcjuoqr") {
        self.input = input
    }

    public func solve() -> (String, String) {

        let foundIndexes1 = findHashIndexes(64)
        print(foundIndexes1.sorted())

        let foundIndexes2 = findHashIndexes(64, additionalHashings: 2016)
        print(foundIndexes2.sorted())

        return (String(foundIndexes1.sorted()[63]), String(foundIndexes2.sorted()[63]))
    }

    private func findHashIndexes(_ count: Int = 64, additionalHashings: Int = 0) -> [Int] {
        var foundIndexes: [Int] = []
        var analyzedIndexes: [Int: UTF8.CodeUnit] = [:]
        var index = 0

        while true {
            var key = (input + String(index)).md5()

            for _ in 0..<additionalHashings {
                key = key.md5()
            }

            for (analyzedIndex, character) in analyzedIndexes {
                if index - analyzedIndex <= 1000 {
                    if key.hasFiveInARow(character) {
                        foundIndexes.append(analyzedIndex)
                        print("foundKey: \(analyzedIndex) (total \(foundIndexes.count))")
                        analyzedIndexes.removeValue(forKey: analyzedIndex)
                    }
                } else {
                    analyzedIndexes.removeValue(forKey: analyzedIndex)
                }
            }

            if let character = key.hasThreeInARow() {
                analyzedIndexes[index] = character
                print("analyzing key: ", index)
            }

            if foundIndexes.count >= 64 {
                if analyzedIndexes.isEmpty {
                    break
                }

                if let maxFound = foundIndexes.max(), let minAnalyzed = analyzedIndexes.keys.min(), maxFound < minAnalyzed {
                    break
                }
            }
            
            index += 1
        }

        return foundIndexes
    }
}
