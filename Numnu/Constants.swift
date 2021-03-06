//
//  Constants.swift
//  Numnu
//
//  Created by CZ Ltd on 9/18/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import Foundation


class Constants {
    
    static let POST = "PostList";
    
    // Storyboards name
    
    static let Tab   = "Tab"
    static let Auth  = "Auth"
    static let Main  = "Main"
    static let Event = "Event"
    static let EventDetail = "EventDetailTab"
    static let PostDetail  = "PostDetail"
    static let BusinessDetail    = "BussinessDetail"
    static let BusinessDetailTab = "BussinessDetailTab"
    static let ItemDetail        = "ItemDetails"
    static let LocationDetail    = "LocationDetail"
    
    // Storyboards id
    
    static let TabStoryId   = "tabcontrollerid"
    static let ProfileId    = "profileid"
    static let EventStoryId = "eventstoryid"
    static let LoginStoryId = "loginStoryId"
    static let PostDetailId = "postdetailid"
    static let BusinessDetailId   = "businessDetailId"
    static let BusinessCompleteId = "businessCompleteid"
    static let ItemDetailId       = "itemCompleteid"
    static let ItemCompleteId     = "itemDetailId"
    static let LocationDetailId   = "locationDetailid"
    static let MenuItemId         = "menuItemstory"
    static let Profile_PostViewController = "Profile_PostViewController"
    static let Profile_LinkViewController = "Profile_LinkViewController"
    
    // Event story id
    
    static let WebViewStoryId = "webstroyId"
    static let MapStoryId     = "mapstoryboardid"
    
    // Home Tab name
    
    static let Tab1  = "Events"
    static let Tab2  = "Businesses"
    static let Tab3  = "Items"
    static let Tab4  = "Posts"
    static let Tab5  = "Users"
    static let Tab6  = "Lists"
    static let Tab7  = "Locations"
    static let Tab8  = "Dummy1"
    static let Tab9  = "Dummy2"
    
    // Home Tab id
    static let Tabid1  = "EventTab"
    static let Tabid2  = "BusinessesTab"
    static let Tabid3  = "MenuTab"
    static let Tabid4  = "PostTab"
    static let Tabid5     = "UserTab"
    static let Tabid6     = "ListTab"
    static let Tabid7     = "LocationTab"
    static let DefaultTab = "DefaultTab"
    
    // Event Detail Tab name
    
    static let EventTab1  = "Businesses"
    static let EventTab2  = "Items"
    static let EventTab3  = "Posts"
    
    // Event Detail Tab id
    static let EventTabid1  = "BusinessesTab"
    static let EventTabid2  = "MenuTab"
    static let EventTabid3  = "ReviewTab"
    
    // Menu Detail Tab name
    
    static let BusinessTab1 = "Items"
    static let BusinessTab2 = "Posts"
    static let BusinessTab3 = "Events"
    
    // Menu Detail Tab id
    
    static let BusinessTabid1 = "MenuTab"
    static let BusinessTabid2 = "ReviewTab"
    static let BusinessTabid3 = "EventTab"
    
    
    // Prferences
    
    static let loginstatus   = "loginstatus"
    static let appopenstatus = "appopenstatus"


    static let startsat      = "startsat"
    static let endsat        = "endsat"
    static let eventLinkList = "eventLinkList"

    static let id           = "id"
    static let useremail    = "useremail"
    static let userName     = "userName"
    static let name         = "name"
    static let firebaseUID  = "firebaseUID"
    static let imageURLs    = "imageURLs"
    static let dateOfBirth  = "dateOfBirth"
    static let gender       = "gender"
    static let userCity     = "userCity"
    static let userCityId   = "userCityId"
    static let description  = "description"
    static let lastlocation = "lastlocation"
    static let lastlocationlat  = "lastlocationlat"
    static let lastlocationlong = "lastlocationlong"
    static let taglist      = "taglist"


    static let dummy   = "This much-talked-about festival brings all your favorite Food Network personalities and celebrity chefs to Miami for five days of events, from intimate dinners cooked by Sean Brock to a late-night Tacos After Dark session with Aarón Sanchez. If you've always dreamed of drinking tiki cocktails with Guy Fieri or having a rosé brunch with Martha Stewart, the South Beach Wine & Food Festival can make your wishes come true."
    
    // Authentication Label
    
    static let Emailpasserror = "Enter email address and password."
//    static let Passworderror  = "Enter valid password with 8 characters & a special character."
    static let Passworderror  = "Please check password."

    static let Emailerror     = "Enter valid email address."
    
    // Map Api key
    
    static let MapApiKey      = "AIzaSyAuKzAZP8SLYJf_jfVUsxdcjChIU00FmDQ"
    
    // Web Api key
    
    static let PlaceApiUrl      = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    static let PlaceDetailApi   = "https://maps.googleapis.com/maps/api/place/details/json"
    static let PlaceGeoCodeApi = "https://maps.googleapis.com/maps/api/geocode/json"
    
    /*********Api **********/
    
//    static let LoginApiUrl         = "https://numnu-server-dev.appspot.com/users/signin"
//    static let TagApiUrl           = "https://numnu-server-dev.appspot.com/tags"
//    static let EventApiUrl         = "https://numnu-server-dev.appspot.com/events"
//    static let ItemsApiUrl         = "https://numnu-server-dev.appspot.com/items"
//    static let EventTypeApiUrl     = "https://numnu-server-dev.appspot.com/eventtypes"
//    static let PostsByEventId      = "https://numnu-server-dev.appspot.com/events/34/posts"
//    static let BusinessDetailApi   = "https://numnu-server-dev.appspot.com/businesses"
//    static let PostsByItemId       = "https://numnu-server-dev.appspot.com/items"
    static let LoginApiUrl        = "https://numnu-server-dev.appspot.com/signinuser"
    static let TagApiUrl          = "https://numnu-server-dev.appspot.com/tags"
    static let EventApiUrl        = "https://numnu-server-dev.appspot.com/events"
    static let ItemsApiUrl        = "https://numnu-server-dev.appspot.com/items"
    static let EventTypeApiUrl    = "https://numnu-server-dev.appspot.com/eventtypes"
    static let PostsByEventId     = "https://numnu-server-dev.appspot.com/events/34/posts"
    static let BusinessDetailApi  = "https://numnu-server-dev.appspot.com/businesses"
    static let PostsByItemId      = "https://numnu-server-dev.appspot.com/items"
    static let Bookmarkpost       = "https://numnu-server-dev.appspot.com/users"
    static let LocationApiUrl     = "https://numnu-server-dev.appspot.com/locations"
    static let bookMarkApi        = "https://numnu-server-dev.appspot.com/bookmarks"
    
    
    
    static let CheckUserName = "https://numnu-server-dev.appspot.com/users"
    
   static let completeSignup =  "https://numnu-server-dev.appspot.com/users"
   static let homeSearchApi  =  "https://numnu-server-dev.appspot.com/homeSearch"
   static let homeListApi    =  "https://numnu-server-dev.appspot.com/homeLists"
    
   static let clientApp = "iOS"
    
    
}
