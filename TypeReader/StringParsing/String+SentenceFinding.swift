import Foundation

extension String {
    func sentence(containing range: NSRange) -> String {
        var currentSentence = ""
        if let rangeOfCurrentSentence = rangeOfCurrentSentence(from: range) {
            currentSentence = String(self[rangeOfCurrentSentence]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return currentSentence
    }
    
    func rangeOfCurrentSentence(from range: NSRange) -> Range<String.Index>? {
        let start = index(startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: min(range.length, count - range.location))

        let rangeOfSentenceEnd = self.range(of: ".", options: [], range: start ..< end)?.upperBound
        
        var rangeStart = self.range(of: ".", options: .backwards, range: startIndex ..< start)?.upperBound ?? startIndex
        var rangeEnd = rangeOfSentenceEnd ?? self.range(of: ".", options: [], range: end ..< endIndex)?.upperBound ?? endIndex
        
        movePastPunctuation(&rangeEnd, &rangeStart)

        return rangeStart ..< rangeEnd
    }
    
    private func movePastPunctuation(_ rangeEnd: inout String.Index, _ rangeStart: inout String.Index) {
        while rangeEnd < endIndex, let scalar = self[rangeEnd].unicodeScalars.first, !CharacterSet.whitespacesAndNewlines.contains(scalar)  {
            rangeEnd = index(rangeEnd, offsetBy: 1)
        }
        
        while rangeStart > startIndex, rangeStart < endIndex, let scalar = self[rangeStart].unicodeScalars.first, !CharacterSet.whitespacesAndNewlines.contains(scalar) {
            rangeStart = index(rangeStart, offsetBy: 1)
        }
    }
}
