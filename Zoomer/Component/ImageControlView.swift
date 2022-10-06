//
//  ImageControlView.swift
//  Zoomer
//
//  Created by Muhammad Ahmad on 22/09/2022.
//

import SwiftUI

struct ImageControlView: View {
    var icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}
