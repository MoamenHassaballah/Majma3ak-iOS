//
//  Request.swift
//  Majma3ak
//
//  Created by ezz on 20/06/2025.
//


//
//  Request.swift
//  Cars
//
//  Created by macbook on 6/2/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation

struct Request {
    
    //    {{LOCAL}}/api/user/register
    static let baseUrl = "http://api.mojamaak.com"
    static let url = "http://api.mojamaak.com/api/user/"
    static let register = url + "register"
    static let login = url + "login"
    static let verifyPhone = url + "verify-phone"
    static let resendVerificationOtp = url + "resend-verification-otp"
    static let forgotPassword = url + "forgot-password"
    static let verifyResetOtp = url + "verify-reset-otp"
    static let resetPassword = url + "reset-password"
    static let logout = url + "logout"
    static let slider = url + "slider"
    static let maintenanceRequests = url + "maintenance-requests?"
    static let maintenanceRequests2 = url + "maintenance-requests"
    static let maintenanceDepartments = url + "maintenance-departments"
    static let apartments = url + "apartments"
    static let visitRequests  = url + "visit-requests?"
    static let AddvisitRequests = url + "visit-requests"
    static let getProfileData = url + "profile"
    static let contacts = url + "contacts"
    static let notifications = url + "notifications?"
    static let complextNotifications = url + "complex-notifications?"
    static let complexes = url + "residential-complexes"
    static let payments = url + "payments"

    
    
    
//    static let companies = url + "companies"
//    stic let Alladvertisements = url + "advertisements"
    //    static let update = url + "user/update"
    //    static let profile = url + "user/profile"
    //    static let stor = url + "advertisements"
    //    static let Showcompany = url + "companies/"
    //    static let Addfavorites = url + "user/favorites/"
    //    static let home = url + "home"
    //    static let Dedails = url + "advertisements/"
    //    static let comment = url + "advertisements/"
    //    static let reset_password = url + "auth/reset_password"
    //    static let register = url + "auth/register"
    //    static let delete = url + "user/favorites/"
    //    static let favorites = url + "user/favorites"
    //    static let logout = url + "auth/logout"
    //    static let activate = url + "auth/activate"
    //    static let commercial_categories = url + "commercial_categories"
    //    static let forget_password = url + "auth/forget_password"
    //    static let configs = url + "configs"
    //    static let update_password = url + "user/update_password"
    //    static let deleteMyadvertisements = url + "advertisements/"
    //    static let login = url + "auth/login"
    //    static let updateAdvertising = url + "advertisements/"atic let categories = url + "categories"
//    stat


    

}
struct token {
    static let ud = UserDefaults.standard
    static let value = ud.value(forKey: "token_key") as? String ?? ""
}
