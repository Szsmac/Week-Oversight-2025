import Foundation

struct Client: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var address: String
    var distributionCenter: String?
    
    init(id: UUID = UUID(), name: String, address: String, distributionCenter: String? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.distributionCenter = distributionCenter
    }
} 