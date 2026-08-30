import Foundation

enum GeometryModule: String, CaseIterable, Identifiable {
    case lgs
    case yks

    var id: String { rawValue }

    var title: String {
        switch self {
        case .lgs: return "LGS Geometri"
        case .yks: return "YKS Geometri"
        }
    }

    var subtitle: String {
        switch self {
        case .lgs: return "8. Sınıf müfredatı"
        case .yks: return "TYT + AYT müfredatı"
        }
    }

    var systemImage: String {
        switch self {
        case .lgs: return "triangle"
        case .yks: return "square.on.circle"
        }
    }
}
