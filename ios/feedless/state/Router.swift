//
//  Router.swift
//  feedless
//
//  Created by Rogerio Chaves on 25/05/20.
//  Copyright © 2020 Rogerio Chaves. All rights reserved.
//

import SwiftUI

enum Route {
    case profile
    case friends
    case secrets
    case communities
    case search
    case debug
    case pubs
    case index
    case editProfile
}

class Router: ObservableObject {
    let profileScreen = (Route.profile, AnyView(ProfileScreen(id: nil)))
    let friendsScreen = (Route.friends, AnyView(FriendsScreen()))
    let secretsScreen = (Route.secrets, AnyView(SecretsScreen()))
    let communitiesList = (Route.communities, AnyView(CommunitiesList()))
    let searchScreen = (Route.search, AnyView(SearchScreen()))
    let debugScreen = (Route.debug, AnyView(Debug()))
    let pubsScreen = (Route.pubs, AnyView(PubsScreen()))
    let editProfileScreen = (Route.editProfile, AnyView(EditProfileScreen()))

    @Published var currentRoute: (Route, AnyView)
    @Published var navigationBarBackgroundColor: UIColor = Styles.uiBlue
    @Published var navigationBarTextColor: UIColor = Styles.uiBlue
    @Published var root:UIViewController? = nil

    init() {
        self.currentRoute = self.profileScreen
    }

    func changeRoute(to: (Route, AnyView)) {
        self.changeNavigationBarColor(route: to.0)
        DispatchQueue.main.async {
            self.currentRoute = to
            DispatchQueue.main.async {
                self.updateNavbar()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.updateNavbar()
        }
    }

    func changeNavigationBarColor(route: Route) {
        switch route {
        case .profile:
            self.navigationBarBackgroundColor = Styles.uiBlue
            self.navigationBarTextColor = Styles.uiDarkBlue
        case .secrets:
            self.navigationBarBackgroundColor = Styles.uiYellow
            self.navigationBarTextColor = Styles.uiDarkYellow
        case .friends:
            self.navigationBarBackgroundColor = Styles.uiPink
            self.navigationBarTextColor = Styles.uiDarkPink
        case .communities:
            self.navigationBarBackgroundColor = Styles.uiPink
            self.navigationBarTextColor = Styles.uiDarkPink
        case .index:
            self.navigationBarBackgroundColor = Styles.uiLightBlue
            self.navigationBarTextColor = Styles.uiDarkBlue
        default:
            self.navigationBarBackgroundColor = Styles.uiWhite
            self.navigationBarTextColor = Styles.uiBlack
        }
    }

    // From https://stackoverflow.com/questions/56505528/swiftui-update-navigation-bar-title-color
    func findNavbar(_ root: UIView?) -> UINavigationBar? {
        guard root != nil else { return nil }

        var navbar: UINavigationBar? = nil
        for v in root!.subviews {
            if type(of: v) == UINavigationBar.self { navbar = (v as! UINavigationBar); break }
            else { navbar = findNavbar(v); if navbar != nil { break } }
        }

        return navbar
    }


    func updateNavbar() {
        if let navbar = self.findNavbar(self.root?.viewIfLoaded) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [.foregroundColor: self.navigationBarTextColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: self.navigationBarTextColor]
            navBarAppearance.backgroundColor = self.navigationBarBackgroundColor

            if let hairline = findHairlineImageViewUnder(navbar) {
                hairline.isHidden = self.navigationBarBackgroundColor == Styles.uiWhite || self.navigationBarBackgroundColor == Styles.uiLightBlue
            }

            navbar.standardAppearance = navBarAppearance
            navbar.scrollEdgeAppearance = navBarAppearance
            navbar.compactAppearance = navBarAppearance
            navbar.tintColor = self.navigationBarTextColor
            navbar.barTintColor = self.navigationBarBackgroundColor
        }
    }

    func updateNavigationBarColor(route: Route) {
        self.changeNavigationBarColor(route: route)
        self.updateNavbar()
    }

    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}
