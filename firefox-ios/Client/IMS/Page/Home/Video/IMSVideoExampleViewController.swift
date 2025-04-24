// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct IMSSelectedVideoModel {
    var image: String
    var title: String
    var url: String
}

class IMSVideoExampleViewController: BaseViewController {
    private let imsPopularSites: [IMSSelectedWebModel] = [
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/3PS00D-CO273v.png", title: "Powell Speaks After the Fed Cut Rates | The Fed Decides", url: "https://www.youtube.com/watch?v=MLN-Otn5omc"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/IhyLHK-Cy6xfp.png", title: "'Unelected President Musk': Elon posts 70 times trashing GOP bill, Trump caves", url: "https://www.youtube.com/watch?v=UXaVNyXV_CI"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/a3e27l-Qza5au.png", title: "Full interview: Donald Trump details his plans for Day 1 and beyond in the White House", url: "https://www.youtube.com/watch?v=b607aDHUu2I"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/RxP8Rm-ukjnR9.png", title: "Superman - Teaser Trailer Tomorrow", url: "https://www.youtube.com/watch?v=KbE8n146umc"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/TyWgfs-pcMwju.png", title: "KARATE KID: LEGENDS - Official Trailer (HD)", url: "https://www.youtube.com/watch?v=uPzOyzsnmio"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/DVBEYS-VcHUsS.png", title: "Where I've been for the past year...", url: "https://www.youtube.com/watch?v=bgrwYFuNib0"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/6Gkhr8-HjSaL8.png", title: "NL MVP! The BEST MOMENTS from Shohei Ohtani's 2024 season! | 大谷翔平ハイライト", url: "https://www.youtube.com/watch?v=3_gDAF2GzCs"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/ylHsvt-6culPB.png", title: "Real Madrid (ESP) vs Pachuca (MEX) | Intercontinental Cup Final | 12/18/2024 | beIN SPORTS USA", url: "https://www.youtube.com/watch?v=JestHTufnVU"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/37tKJG-CODXms.png", title: "How Employees Are Coffee Badging To Avoid Full Days At The Office", url: "https://www.youtube.com/watch?v=mJG4MdepNSA"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/G9oW2q-M7kB3D.png", title: "The Aston Martin Valkyrie Is a $4.5 Million Insane Hypercar", url: "https://www.youtube.com/watch?v=n68z7e8YGGs"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/DUjf5v-fivcDe.png", title: "Every Home Alone Is Worse Than The Last", url: "https://www.youtube.com/watch?v=oUcE_5Gv_YE"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/5SFrWM-nXG7KZ.png", title: "Stray Kids \"Walkin On Water\" M/V", url: "https://www.youtube.com/watch?v=ovHoY8UBIu8")
    ]
}
