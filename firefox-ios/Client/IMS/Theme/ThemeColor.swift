// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct ThemeColor {
    
}

extension ThemeColor {
    /// 中性颜色
    struct ZX {
        static let c222222 = UIColor(hexString: "222222").withDarkColor("D8D8D8")
        static let c333333 = UIColor(hexString: "222222").withDarkColor("D8D8D8")
        static let c666666 = UIColor(hexString: "666666").withDarkColor("B3B3B3")
        static let c999999 = UIColor(hexString: "999999").withDarkColor("777777")
        static let CCCCCC = UIColor(hexString: "CCCCCC").withDarkColor("5C5C5C")
        static let FFFFFF = UIColor(hexString: "FFFFFF").withDarkColor("111111")
    }
}

extension ThemeColor {
    /// 品牌颜色
    struct PP {
        static let EA4C89 = UIColor(hexString: "EA4C89").withDarkColor("E23C7C")
        static let F4A5C4 = UIColor(hexString: "F4A5C4").withDarkColor("7E2F4D")
        static let FDEDF3 = UIColor(hexString: "FDEDF3").withDarkColor("26171D")
    }
}

extension ThemeColor {
    /// 填充颜色
    struct TC {
        static let F3F5F6 = UIColor(hexString: "F3F5F6").withDarkColor("252626")
        static let FAFBFC = UIColor(hexString: "FAFBFC").withDarkColor("2B2D30")
        static let ECF0F7 = UIColor(hexString: "ECF0F7").withDarkColor("3E434B")
    }
}

extension ThemeColor {
    /// 语义颜色
    struct YY {
        static let c21BB45 = UIColor(hexString: "#21BB45").withDarkColor("20AA40")
        static let F53F3F = UIColor(hexString: "#F53F3F").withDarkColor("DF3B3B")
    }
}


extension ThemeColor {
    /// 其他颜色
    struct Other {
        static let c4181F0 = UIColor(hexString: "4181F0").withDarkColor("4181F0")
        static let A0C0F8 = UIColor(hexString: "A0C0F8").withDarkColor("204078")
    }
}

extension ThemeColor {
    /// 投影
    struct TY {
        static let c00000008 = UIColor(hexString: "000000").withDarkColor("FFFFFF").withAlphaComponent(0.08)
    }
}

