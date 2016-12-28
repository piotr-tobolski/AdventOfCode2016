import Foundation
import AdventOfCodeHelpers

/*
 --- Day 6: Signals and Noise ---

 Something is jamming your communications with Santa. Fortunately, your signal is only partially jammed, and protocol in situations like this is to switch to a simple repetition code to get the message through.

 In this model, the same message is sent repeatedly. You've recorded the repeating message signal (your puzzle input), but the data seems quite corrupted - almost too badly to recover. Almost.

 All you need to do is figure out which character is most frequent for each position. For example, suppose you had recorded the following messages:

 eedadn
 drvtee
 eandsr
 raavrd
 atevrs
 tsrnev
 sdttsa
 rasrtv
 nssdts
 ntnada
 svetve
 tesnvt
 vntsnd
 vrdear
 dvrsen
 enarar
 The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter.

 Given the recording in your puzzle input, what is the error-corrected version of the message being sent?

 Your puzzle answer was tzstqsua.

 --- Part Two ---

 Of course, that would be the message - if you hadn't agreed to use a modified repetition code instead.

 In this modified code, the sender instead transmits what looks like random data, but for each character, the character they actually want to send is slightly less likely than the others. Even after signal-jamming noise, you can look at the letter distributions in each column and choose the least common letter to reconstruct the original message.

 In the above example, the least common character in the first column is a; in the second, d, and so on. Repeating this process for the remaining characters produces the original message, advent.

 Given the recording in your puzzle input and this new decoding methodology, what is the original message that Santa is trying to send?

 Your puzzle answer was myregdnr.

 Both parts of this puzzle are complete! They provide two gold stars: **

 At this point, you should return to your advent calendar and try another puzzle.

 If you still want to see it, you can get your puzzle input.

 You can also [Share] this puzzle.
 */

public class Day6 {
    private let input: String

    public init(input: String = resource(named: "input")) {
        self.input = input
    }

    public func solve() -> (String, String) {
        let messages = input.components(separatedBy: "\n").filter { !$0.isEmpty }
        let answerLength = messages[0].characters.count
        var mostFrequentCharacters: [Character] = []
        var leastFrequentCharacters: [Character] = []
        for i in 0..<answerLength {
            var charactersCount: [Character:UInt] = [:]
            for message in messages {
                let messageCharacters = message.characters
                let characterIndex = messageCharacters.index(messageCharacters.startIndex, offsetBy: i)
                let character = messageCharacters[characterIndex]
                charactersCount[character] = (charactersCount[character] ?? 0) + 1
            }

            let mostFrequentCharacter = charactersCount.reduce((key: " ", value: 0)) {
                $1.value > $0.value ? $1 : $0
                }.key
            mostFrequentCharacters.append(mostFrequentCharacter)

            let leastFrequentCharacter = charactersCount.reduce((key: " ", value: UInt.max)) {
                $1.value < $0.value ? $1 : $0
                }.key
            leastFrequentCharacters.append(leastFrequentCharacter)
        }

        return (mostFrequentCharacters.map { String($0) }.joined(),
                leastFrequentCharacters.map { String($0) }.joined())
    }
}

printTime {
    print(Day6().solve()) //success: tzstqsua, myregdnr
}
