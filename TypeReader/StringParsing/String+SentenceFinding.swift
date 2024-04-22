import Foundation

extension String {
    func sentence(containing range: NSRange) -> String {
        var currentSentence = ""
        if let rangeOfCurrentSentence = rangeOfCurrentSentence(from: range) {
            currentSentence = String(self[rangeOfCurrentSentence])
        }
        return currentSentence
    }
    
    func rangeOfCurrentSentence(from range: NSRange) -> Range<String.Index>? {
        let start = index(startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: min(range.length, count - range.location))

        let rangeOfSentenceEnd = self.range(of: ".", options: [], range: start ..< end)?.upperBound
        
        var rangeStart = self.range(of: ".", options: .backwards, range: startIndex ..< start)?.upperBound ?? startIndex
        var rangeEnd = rangeOfSentenceEnd ?? self.range(of: ".", options: [], range: end ..< endIndex)?.upperBound ?? endIndex
        
        if rangeEnd < endIndex, let spaceAfterDot = self.range(of: " ", options: [], range: rangeEnd ..< endIndex) {
            rangeEnd = spaceAfterDot.lowerBound
        }
        
        if rangeStart > startIndex, rangeStart < endIndex, let spaceAfterDot = self.range(of: " ", options: [], range: rangeStart ..< endIndex) {
            rangeStart = spaceAfterDot.upperBound
        }

        return rangeStart ..< rangeEnd
    }
}
