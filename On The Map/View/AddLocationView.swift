//
//  AddLocationView.swift
//  On The Map
//
//  Created by KhuePM on 28/05/2024.
//

import SwiftUI
import MapKit

struct AddLocationView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State var alert: AlertContent?
    
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Image("icon_world")
                        .frame(minHeight: 150)

                    VStack {
                        TextField("Your Location", text: $userViewModel.mapString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        
                        TextField("Your URL", text: $userViewModel.mediaURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        Button(action: {
                            self.userViewModel.findLocation()
                        }) {
                            Text("Find Location")
                                .foregroundColor(.white)
                                .frame( maxWidth: .infinity, minHeight: 40)
                                .background(Color(.bluecian))
                                .cornerRadius(5)
                        }
                        .opacity(self.userViewModel.mapString.isEmpty || self.userViewModel.mediaURL.isEmpty ? 0.5 : 1)
                        .disabled(self.userViewModel.mapString.isEmpty || self.userViewModel.mediaURL.isEmpty)
                    }
                    .padding(20)
            
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .alert(item: $alert) { alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: .default(Text("OK")) {
                            self.alert = nil
                        }
                    )
                }
                .navigationBarTitle("Add Location", displayMode: .inline)
                .navigationBarItems(leading:
                    Text("CANCEL")
                        .foregroundColor(Color(.bluecian))
                        .font(.caption)
                        .onTapGesture {
                            self.onDismiss()
                        }
                )
            }
            
            if userViewModel.showPreview {
                AddLocationPreviewView(
                    place: userViewModel.place!,
                    onConfirm: {
                        userViewModel.saveLocation()
                        self.onDismiss()
                    },
                    onDismiss: {
                        userViewModel.showPreview = false
                    })
                .transition(.move(edge: .bottom))
                .animation(Animation.easeOut(duration: 0.4), value: UUID())
            }
            
            if userViewModel.isLoading {
                LoadingView()
            }
        }
    }
}
