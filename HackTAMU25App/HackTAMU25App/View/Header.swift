//
//  Header.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftUI

struct Header: View {
    let tab: TabType
    @State var showProfile: Bool = false
    
    init(_ tab: TabType) {
        self.tab = tab
    }
    
    var body: some View {
        HStack {
            Text(tab.rawValue)
            
            Spacer()
            
            Button {
                showProfile.toggle()
            } label: {
                Image(systemName: "person.crop.circle.fill")
            }
        }
        .font(.largeTitle.bold())
    }
}

#Preview {
    Header(.home)
}
