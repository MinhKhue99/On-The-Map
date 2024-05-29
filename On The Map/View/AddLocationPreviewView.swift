//
//  AddLocationPreviewView.swift
//  On The Map
//
//  Created by KhuePM on 28/05/2024.
//

import SwiftUI
import MapKit

struct AddLocationPreviewView: View {
    @State var place: CLPlacemark
    
    let onConfirm: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                SingleLocationMapView(place: place)
                
                VStack {
                    Spacer()
                    Button(action: {
                        self.onConfirm()
                        self.onDismiss()
                    }) {
                        Text("FINISH")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color(.bluecian))
                            .cornerRadius(5)
                    }.padding()
                }.frame(maxHeight: .infinity)
            }
            .navigationBarTitle("Location Preview", displayMode: .inline)
            .navigationBarItems(leading: Image("icon_back-arrow").onTapGesture {
                self.onDismiss()
            })
        }
    }
}
