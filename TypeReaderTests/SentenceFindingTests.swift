@testable import TypeReader
import XCTest
import Nimble
import Foundation

final class SentenceFinderTests: XCTestCase {
    static let sentence = "This is the next \"sentence.\""
    let fullText = "First example. \(sentence) We will end with one last example"
    
    func test_SentenceFinder_whenInSentence_shouldReturnSentence() throws {
        let rangeOfWord = fullText.nsRange(of: "next")
        let result = fullText.sentence(containing: rangeOfWord)
        expect(result) == Self.sentence
    }
    
    func test_SentenceFinder_whenAtBeginningOfSentence_shouldReturnSentence() throws {
        let rangeOfWord = fullText.nsRange(of: "This")
        let result = fullText.sentence(containing: rangeOfWord)
        expect(result) == Self.sentence
    }
    
    func test_SentenceFinder_whenAtEndOfSentence_shouldReturnSentence() throws {
        let rangeOfWord = fullText.nsRange(of: "sentence.")
        let result = fullText.sentence(containing: rangeOfWord)
        expect(result) == Self.sentence
    }
    
    func test_SentenceFinder_whenInFirstSentence_shouldReturnSentence() throws {
        let rangeOfWord = fullText.nsRange(of: "First")
        let result = fullText.sentence(containing: rangeOfWord)
        expect(result) == "First example."
    }
    
    func test_SentenceFinder_whenInLastSentence_shouldReturnSentence() throws {
        let rangeOfWord = fullText.nsRange(of: "last")
        let result = fullText.sentence(containing: rangeOfWord)
        expect(result) == "We will end with one last example"
    }
}

extension String {
    func nsRange(of word: String) -> NSRange {
        NSString(string: self).range(of: word)
    }
}
