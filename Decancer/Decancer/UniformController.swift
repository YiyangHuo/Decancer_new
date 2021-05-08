//
//  UniformController.swift
//  Decancer
//
//  Created by Yiyang Huo on 4/30/21.
//

import Foundation


class UniversalController: ObservableObject {
    @Published var display_login_page = false
    @Published var display_loading_main = false
    @Published var display_loading_sheet = false
    init(){}
}
