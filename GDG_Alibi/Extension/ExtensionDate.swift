//
//  ExtensionDate.swift
//  GDG_Alibi
//
//  Created by Lee on 2021/07/10.
//

import Foundation

extension Date {
    
    func monthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }
}
