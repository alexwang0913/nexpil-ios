//
//  Notification.swift
//  Nexpil
//
//  Created by mac on 11/21/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

extension Notification.Name {
    public struct Action {
        //notification name
        static let UpdateTabBarItem = Notification.Name("UpdateTabBarItem")
        static let DoubleTapHomeTab = Notification.Name("DoubleTapHomeTab")
        static let FinishAddDrug = Notification.Name("FinishAddDrug")
    }
}
