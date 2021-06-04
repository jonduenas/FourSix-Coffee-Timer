//
//  WalkthroughModel.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 5/21/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import Foundation

struct WalkthroughModel {
    let headerStrings: [String] = [
        "Creating a custom pour over recipe is easy.",
        "Preview the generated recipe as a graph.",
        "Following the recipe is simple when using the timer.",
        "New in v2.0, save notes and rate your brew."
    ]

    let footerStrings: [String] = [
        "Simply choose your flavor balance and strength. That's it! Purchase FourSix Pro and you can customize brew size, ratio, and more.",
        "See how each pour is broken down and learn how your choices change your recipe.",
        "Know exactly when to start pouring and how much water to pour.",
        "Automatically records stats on your session. Pro users can add extra details like grind size, water temp, coffee choice, and more."
    ]

    let imageNames: [String] = [
        "walkthrough-2",
        "walkthrough-3",
        "walkthrough-4",
        "walkthrough-5"
    ]

    let notificationHeaderString = "Enable notifications for when your coffee is the perfect temperature."
    let notificationFooterString = """
        Quickly return to the app, set your rating, and finalize your notes \
        now that the coffee's flavor is at its best.
        """
    let notificationImageName = "walkthrough-6"

    let lastPageListString = """
        • Coffee
        • Pour Over Brewer
        • Filter
        • Digital Scale
        • Pouring Kettle
        """
}
