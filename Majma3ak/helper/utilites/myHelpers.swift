//
//  myHelpers.swift
//  Majma3ak
//
//  Created by ezz on 30/06/2025.
//

import Foundation

func extractDateOnly(from dateTimeString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy-MM-dd"

    if let date = inputFormatter.date(from: dateTimeString) {
        return outputFormatter.string(from: date)
    }
    return nil
}

func extractDateOnlyForTicket(from dateTimeString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // ✅ هنا التعديل

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy-MM-dd"

    if let date = inputFormatter.date(from: dateTimeString) {
        return outputFormatter.string(from: date)
    }
    return nil
}


func isvalidateEmail(enteredEmail:String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
}

func isValidInternationalPhoneNumber(_ number: String) -> Bool {
    let pattern = #"^\+\d{1,3}\d{6,15}$"#
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: number.utf16.count)
    return regex?.firstMatch(in: number, options: [], range: range) != nil
}
