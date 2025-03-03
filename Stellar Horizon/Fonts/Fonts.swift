//
//  Fonts.swift
//  Stellar Horizon
//
//  Created by Tayfun Ilker on 26.02.25.
//

import SwiftUI

extension Font {
    static func exo2(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular) -> Font {
        return Font.custom(CustomFont(weight: fontWeight).rawValue, size: fontStyle.size)
    }
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 30
        case .title2: return 22
        case .title3: return 20
        case .headline: return 18
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 8
        }
    }
}

enum CustomFont: String {
    case regular = "Exo2-Regular"
    case bold = "Exo2-Bold"
    case semiBold = "Exo2-SemiBold"
    case thin = "Exo2-Thin"
    
    init(weight: Font.Weight) {
        switch weight {
        case .regular:
            self = .regular
        case .bold:
            self = .bold
        case .semibold:
            self = .semiBold
        case .thin:
            self = .thin
        default:
            self = .regular
        }
    }
}
