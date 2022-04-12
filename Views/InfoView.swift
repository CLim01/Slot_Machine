//
//  InfoView.swift
//  Slot_Machine
//
//  Created by 임성빈 on 2022/04/05.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            LogoView()
            
            Spacer()
            
            Form(content: {
                Section(content: {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Lim seong bin")
                    FormRowView(firstItem: "Designer", secondItem: "Lim seong bin")
                    FormRowView(firstItem: "Music", secondItem: "Lim seong bin")
                    FormRowView(firstItem: "Website", secondItem: "ImVV.velog")
                    FormRowView(firstItem: "Copyright", secondItem: "© 2022 All rights reserved")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }, header: {
                    Text("About the application")
                }) // END: Section
            }) // END: Form
            .font(.system(.body, design: .rounded))
        }) // END: VStack
        .padding(.top, 40)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title2)
            })
            .padding(20)
            .tint(Color.secondary)
        })
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    var body: some View {
        HStack {
            Text(firstItem)
                .foregroundColor(Color.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
