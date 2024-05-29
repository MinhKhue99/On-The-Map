//
//  ContentView.swift
//  On The Map
//
//  Created by KhuePM on 24/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    // MARK:  Property
    @EnvironmentObject var userViewModel: UserViewModel
    @State var isLoading: Bool = false
    @State var showAddLocation: Bool = false
    
    // MARK:  Body
    var body: some View {
        if !userViewModel.isLoggedIn {
            LoginView()
                .transition(.move(edge: .bottom))
                .animation(Animation.easeOut(duration: 0.4), value: UUID())
                .alert(item: $userViewModel.alert) { alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: .default(Text("OK")) {
                            userViewModel.alert = nil
                        }
                    )
                }
        } else {
            ZStack {
                NavigationView {
                    TabView {
                        VStack {
                            MapView(onTapItem: self.userViewModel.openURL(urlString:))
                        }.tabItem {
                            Image(.iconMapviewDeselected)
                                .renderingMode(.template)
                        }
                        
                        VStack {
                            StudentLocationListView()
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                        }.tabItem {
                            Image(.iconListviewDeselected)
                                .renderingMode(.template)
                        }
                    }
                    .accentColor(Color(.bluecian))
                    .navigationBarTitle("On the Map", displayMode: .inline)
                    .navigationBarItems(
                        leading: 
                            Image(systemName: "arrow.backward.square")
                            .renderingMode(.template)
                            .foregroundColor(Color(.bluecian))
                            .onTapGesture {
                                userViewModel.logout(sessionId: userViewModel.user?.sessionId ?? "")
                            },
                        trailing:
                            Image("icon_addpin")
                            .renderingMode(.template)
                            .foregroundColor(Color(.bluecian))
                            .onTapGesture {
                                self.showAddLocation = true
                            }
                    )
                }
                
                if showAddLocation {
                    AddLocationView(onDismiss: {
                        self.showAddLocation = false
                    })
                    .transition(.move(edge: .bottom))
                    .animation(Animation.easeOut(duration: 0.4), value: UUID())
                }
                
                
                if userViewModel.isLoading {
                    LoadingView()
                }
            }
            .onAppear {
                userViewModel.fetchStudentLocations()
            }
            .alert(item: $userViewModel.alert) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK")) {
                        userViewModel.alert = nil
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
