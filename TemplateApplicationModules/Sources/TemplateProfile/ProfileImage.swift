//
//  File.swift
//  
//
//  Created by Paul Shmiedmayer on 3/10/23.
//

import Account
import class FHIR.FHIR
import FirebaseAccount
import SwiftUI
import Views


struct ProfileImage: View {
    @EnvironmentObject private var firebaseAccount: FirebaseAccountConfiguration<FHIR>
    
    
    var body: some View {
        if let displayName = firebaseAccount.user?.displayName,
           let name = try? PersonNameComponents(displayName) {
            UserProfileView(name: name)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
        }
    }
}
