//
//  LoginView.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 02.11.21.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        Form {
            Section {
                VStack(spacing: 4) {
                    Text("auth.form.title").font(.largeTitle).fontWeight(.black)
                    Text("auth.form.subtitle")
                        .font(.headline)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }.frame(maxWidth: .infinity)
            }.listRowBackground(Color.clear)
            
            Section {
                TextField("auth.form.username", text: $viewModel.username)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                SecureField("auth.form.password".localized(), text: $viewModel.password, prompt: nil)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            } footer: {
                if viewModel.error == nil {
                    Text("auth.form.hint").foregroundColor(Color(UIColor.secondaryLabel))
                } else {
                    Text("auth.form.error").foregroundColor(.red)
                }
            }
            
            Section {
                HStack {
                    Button("auth.form.login", action: {
                        Task {
                            await viewModel.login()
                        }
                    }).disabled(viewModel.isLoading)
                }.frame(maxWidth: .infinity)
            }
            
            Section {
                HStack {
                    Button("auth.form.confluenceLink", action: { viewModel.goToConfluence() })
                        .disabled(viewModel.isLoading)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }.frame(maxWidth: .infinity)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
