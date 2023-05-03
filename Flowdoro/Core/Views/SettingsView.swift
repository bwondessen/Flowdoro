//
//  SettingsView.swift
//  Flexodoro
//
//  Created by Bruke on 5/2/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.dismiss) var dismiss
    //@State var alternativeTheme: Bool
    
    @State private var showLogOutAlert: Bool = false
    
    @AppStorage("faceIDEnabled") private var faceIDEnabled: Bool = false
    @AppStorage("passcodeRequired") var passcodeRequired: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    infoSection
                }
                
                Section {
                    accountSection
                }
                
//                Section {
//                    securitySection
//                }
                
                Section {
                    logOutSection
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.black)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Confirm log out", isPresented: $showLogOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log out", role: .destructive) {
                vm.logOut()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    private var infoSection: some View {
        NavigationLink {
            InfoView()
        } label: {
            HStack {
                Image(systemName: "info.circle")
                VStack(alignment: .leading) {
                    Text("Info")
                        .font(.headline)
                    Text("About, contact, terms of service")
                        .font(.footnote.italic())
                }
            }
        }
    }
    
    private var accountSection: some View {
        NavigationLink {
            EditAccountView()
        } label: {
            HStack {
                Image(systemName: "person.crop.circle")
                VStack(alignment: .leading) {
                    Text("Account")
                        .font(.headline)
                    Text("Change password & username")
                        .font(.footnote.italic())
                }
            }
        }
    }
        
//    private var themeSection: some View {
//        Toggle("Alternative Theme", isOn: $vm.alternativeTheme)
//            .accentColor(Color.theme.accentMain)
//    }
    
    private var logOutSection: some View {
        Button {
            showLogOutAlert = true
        } label: {
            Text("Log out")
                .font(.headline.bold())
                .foregroundColor(Color.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.blue, lineWidth: 0.55)
                )
        }
    }
}
