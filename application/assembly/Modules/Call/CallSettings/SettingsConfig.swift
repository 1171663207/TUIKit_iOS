//
//  SettingsConfig.swift
//  AppAssembly
//

import Foundation
import TUICore
import AtomicXCore

#if canImport(TUICallKit_Swift)
import TUICallKit_Swift
#elseif canImport(TUICallKit)
import TUICallKit
#endif

class SettingsConfig {
    
    static let share = SettingsConfig()
    
    var userId = ""
    var avatar = ""
    var name = ""
    var ringUrl = ""
    
    var mute: Bool = false
    var floatWindow: Bool = true
    var enableVirtualBackground: Bool = true
    var enableIncomingBanner: Bool = true
    var enableAITranscriber: Bool = false
    var timeout: Int = 60
    var userData: String = ""
    var is1VN: Bool = true
    var screenOrientation: Int = 0
}
