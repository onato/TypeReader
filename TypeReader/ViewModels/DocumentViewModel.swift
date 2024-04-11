import Foundation

@Observable
class DocumentViewModel {
  var documentPages: [String] = []
  var currentPage = 0

  init() { }
}
