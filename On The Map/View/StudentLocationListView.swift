//
//  StudentLocationListView.swift
//  On The Map
//
//  Created by KhuePM on 26/05/2024.
//

import SwiftUI

struct StudentLocationListView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        List(userViewModel.studentLocations, id: \.objectId) { location in
            StudentLocationRowView(studentLocation: location)
                .onTapGesture {
                    self.userViewModel.openURL(urlString: location.mediaURL)
                }
        }
    }
}

#Preview {
    StudentLocationListView()
}
