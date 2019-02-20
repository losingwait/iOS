//
//  NotificationBanner.swift
//  LosingWait
//
//  Created by Mike Choi on 2/18/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import NotificationBannerSwift

struct BannerNotification {
    
    static func fatalError(msg: String) -> NotificationBanner {
        let banner = NotificationBanner(title: "Try again", subtitle: msg, style: .danger)
        banner.haptic = .medium
        banner.duration = 0.8
        return banner
    }
    
    static func error(msg: String) -> NotificationBanner {
        let banner = NotificationBanner(title: "oops", subtitle: msg, style: .warning)
        banner.haptic = .light
        banner.duration = 0.8
        return banner
    }
    
    static func success(msg: String) -> NotificationBanner {
        let banner = NotificationBanner(title: "Success!", subtitle: msg, style: .success)
        banner.haptic = .light
        banner.duration = 1.0
        return banner
    }
}
