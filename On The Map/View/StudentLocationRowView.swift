//
//  StudentLocationRowView.swift
//  On The Map
//
//  Created by KhuePM on 26/05/2024.
//

import SwiftUI

struct StudentLocationRowView: View {
    var studentLocation: StudentLocation
    
    var body: some View {
        HStack {
            Image(.iconPin)
                .resizable()
                .frame(maxWidth: 30, maxHeight: 30)
            VStack(alignment: .leading) {
                Text(studentLocation.fullName)
                Text(studentLocation.mediaURL)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}
