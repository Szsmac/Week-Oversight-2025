import Foundation

struct TransportStats: Codable, Hashable {
    var boxes: Int = 0
    var rollies: Int = 0
    var missingBoxes: Int = 0
} 