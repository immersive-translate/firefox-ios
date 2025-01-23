// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct YearProSubscriptionListSwiftUIView: View {
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0) {
                    HStack {
                        Text("\(String.IMS.IAP.proExclusiveAITranslation)")
                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        ProSubscriptionPopverTipIcon(tipMessage: "\(String.IMS.IAP.proExclusiveAITranslation)")
                            .frame(width: 16, height: 16)
                        
                        Spacer()
                        
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack{
                        
                        Image("iap_year_info_icongou")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(String.IMS.IAP.deeplTranslation)")
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
                        
                        Text("\(String.IMS.IAP.openAITranslation)")
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
                        
                        Text("\(String.IMS.IAP.claudeTranslation)")
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
                        
                        Text("\(String.IMS.IAP.geminiTranslation)")
                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 24)
                    HStack {
                        Text("\(String.IMS.IAP.proExclusiveFeatures)")
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
                        
                        Text("\(String.IMS.IAP.pdfPro)")
                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                           
                        ProSubscriptionPopverTipIcon(tipMessage: "\(String.IMS.IAP.pdfPro)")
                            .frame(width: 16, height: 16)
                        Spacer()
                        
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    HStack{
                        
                        Image("iap_year_info_icongou")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(String.IMS.IAP.mangaTranslation)")
                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                       
                        ProSubscriptionPopverTipIcon(tipMessage: "\(String.IMS.IAP.mangaTranslation)")
                            .frame(width: 16, height: 16)
                        Spacer()
                        
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack{
                        
                        Image("iap_year_info_icongou")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(String.IMS.IAP.youtubeBilingualSubtitle)")
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
                        
                        Text("\(String.IMS.IAP.multiDeviceSync)")
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
                        
                        Text("\(String.IMS.IAP.priorityEmailSupport)")
                            .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                     
                          
                        ProSubscriptionPopverTipIcon(tipMessage: "\(String.IMS.IAP.priorityEmailSupport)")
                            .frame(width: 16, height: 16)
                        Spacer()
                        
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                }
                .padding(.top, 30)
                .padding(.leading, 24)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    YearProSubscriptionListSwiftUIView()
}
