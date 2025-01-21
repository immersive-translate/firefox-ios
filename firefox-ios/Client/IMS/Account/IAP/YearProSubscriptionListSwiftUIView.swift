// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct YearProSubscriptionListSwiftUIView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 0) {
                HStack {
                    Text("Pro专属全球顶尖AI翻译服务")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Image("iap_year_info_icon")
                        .resizable()
                      .frame(width: 16, height: 16)
                    Spacer()
                    
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("DeepL 翻译")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Spacer()
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("OpenAI 翻译")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Spacer()
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("Claude 翻译")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Spacer()
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("Gemini 翻译")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Spacer()
                }
                Spacer()
                    .frame(height: 24)
                HStack {
                    Text("Pro专属高级功能")
                        .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Spacer()
                    
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("PDF Pro")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Image("iap_year_info_icon")
                        .resizable()
                      .frame(width: 16, height: 16)
                    Spacer()
                    
                }
                
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("漫画翻译")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Image("iap_year_info_icon")
                        .resizable()
                      .frame(width: 16, height: 16)
                    Spacer()
                    
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("Youtube 双语字幕下载")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Spacer()
                    
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("多设备同步配置")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Spacer()
                    
                }
                Spacer()
                    .frame(height: 16)
                HStack{
                
                    Image("iap_year_info_icongou")
                        .resizable()
                      .frame(width: 18, height: 18)
                   
                    Text("优先的电子邮件支持")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    Image("iap_year_info_icon")
                        .resizable()
                      .frame(width: 16, height: 16)
                    Spacer()
                    
                }
                
                
            }
            .padding(.top, 30)
            .padding(.leading, 24)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    YearProSubscriptionListSwiftUIView()
}
