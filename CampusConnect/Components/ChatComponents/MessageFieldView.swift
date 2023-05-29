//
//  MessageFieldView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

struct MessageFieldView: View {
    @State private var message = ""
    @State private var time: String = ""
    @Binding var showNameAndTime:Bool
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Message..."), text: $message)
            
            Button {
                // display name and time  only when the time differs for messages sent
                if(time == String(Date().formatted(.dateTime.hour().minute()))) {
                    showNameAndTime = false
                }
                else {
                    showNameAndTime = true
                }
                
                // time when message is sent
                time = Date().formatted(.dateTime.hour().minute())
                
                print("Message sent!: \(message)")
                
                // reset message
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color("LumGreen"))
                    .cornerRadius(15)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("LavenderGray"))
        .cornerRadius(20)
        .padding()
    }
}

struct MessageFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MessageFieldView(showNameAndTime: .constant(true))
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
