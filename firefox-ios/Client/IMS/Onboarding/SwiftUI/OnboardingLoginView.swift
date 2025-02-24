// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

enum OnboardingLoginButtonType {
    case google
    case email
    case apple
    case facebook
    case other
}

struct OnboardingLoginView: View {
    var onButtonTap: ((OnboardingLoginButtonType) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Text("注册并登录")
                .font(
                    Font.custom("PingFang SC", size: 20)
                        .weight(.semibold)
                )
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

            Spacer().frame(height: 16)

            Text("登录后立即享有沉浸式翻译全部免费功能～")
                .font(Font.custom("PingFang SC", size: 14))
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

            Spacer().frame(height: 40)

            Button {
                onButtonTap?(.google)

            } label: {
                HStack(spacing: 0) {
                    Image("google-icon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        

                    Spacer().frame(width: 10)

                    Text("使用谷歌登录")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 0.5)
                    .stroke(
                        Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 1)

            )
            .padding(.horizontal, 26)

            Spacer().frame(height: 24)

            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                Spacer().frame(width: 8)

                Text("或")
                    .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                    .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                Spacer().frame(width: 8)

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            }
            .padding(.horizontal, 26)

            Spacer().frame(height: 24)

            Button {
                onButtonTap?(.email)

            } label: {
                HStack(spacing: 0) {
                    Image("email-icom")
                        .resizable()
                        .frame(width: 24, height: 24)
                       

                    Spacer().frame(width: 10)

                    Text("使用电子邮箱登录")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    

                }
                .frame(maxWidth: .infinity)

            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(
                        Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 1)

            )
            .padding(.horizontal, 26)

            Spacer().frame(height: 16)

            Button {
                onButtonTap?(.apple)
            } label: {
                HStack(spacing: 0) {
                    Image("apple-icom")
                        .resizable()
                        .frame(width: 24, height: 24)
                       

                    Spacer().frame(width: 10)

                    Text("使用苹果账号登录")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                }
                .frame(maxWidth: .infinity)

            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(
                        Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 1)

            )
            .padding(.horizontal, 26)

            Spacer().frame(height: 16)

            Button {
                onButtonTap?(.facebook)

            } label: {
                HStack(spacing: 0) {
                    Image("facebook-icom")
                        .resizable()
                        .frame(width: 24, height: 24)
                        

                    Spacer().frame(width: 10)

                    Text("使用FaceBook登录")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                }
                .frame(maxWidth: .infinity)

            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(
                        Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 1)

            )
            .padding(.horizontal, 26)

            Spacer().frame(height: 16)

            Button {
                onButtonTap?(.other)

            } label: {
                HStack(spacing: 0) {
                    
                  

                    Text("稍后再登录")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))

                }
                .frame(maxWidth: .infinity)

            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            .padding(.horizontal, 26)

            Spacer()
            
        }
        .background(Color.white)

    }
}

#Preview {
    OnboardingLoginView()
}
