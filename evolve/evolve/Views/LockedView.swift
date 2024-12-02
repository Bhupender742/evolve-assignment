//
//  LockedView.swift
//  evolve
//
//  Created by Lucifer on 01/12/24.
//

import SwiftUI

struct LockedView: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack(alignment: .bottom) {
                Image(systemName: "lock.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding([.leading, .bottom], 8)
                
                Spacer()
            }
        }
    }
}
