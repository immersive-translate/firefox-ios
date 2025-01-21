// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// 创建一个扩展来简化使用
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct ProSubscriptionSwiftUIView: View {
    var body: some View {
        VStack(spacing: 0) {
            YearProSubscriptionSwiftUIView()

            Spacer()
            // 底部固定的内容
            VStack(spacing: 0) {
                Divider()
                Spacer()
                    .frame(height: 17)

                GeometryReader { geo in
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: 4)

                        Button {

                        } label: {
                            Text("连续包年（节省30%）")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.clear)
                        .frame(width: geo.size.width * (216.0 / 335.0))
                        .frame(height: 40)
                        .background(Color(red: 0.92, green: 0.3, blue: 0.54))
                        .cornerRadius(28)

                        Button {

                        } label: {
                            Text("连续包月")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .foregroundColor(.clear)
                        .frame(width: geo.size.width * (111.0 / 335.0))
                        .frame(height: 40)
                        .background(.clear)
                        .cornerRadius(28)

                        Spacer()
                            .frame(width: 4)
                    }
                    .frame(maxHeight: .infinity)
                }
                .foregroundColor(.clear)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(.white)

                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .inset(by: -0.5)
                        .stroke(
                            Color(red: 0.93, green: 0.95, blue: 0.96),
                            lineWidth: 1)

                )
                .padding(.horizontal, 20)

                Spacer()
                    .frame(height: 20)

                Button {
                    print("click")
                } label: {
                    Text("立即订阅")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 1, green: 0.78, blue: 0.21))

                        .frame(width: 82.76471, alignment: .topLeading)
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(
                                color: Color(
                                    red: 0.13, green: 0.13, blue: 0.13),
                                location: 0.00),
                            Gradient.Stop(
                                color: Color(
                                    red: 0.41, green: 0.41, blue: 0.41),
                                location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.31, y: 1.08),
                        endPoint: UnitPoint(x: 0.92, y: 0)
                    )
                )
                .cornerRadius(12)
                .padding(.horizontal, 20)

            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ProSubscriptionSwiftUIView()
}


