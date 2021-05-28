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
        "Creating a custom Recipe tailored to your preference is as easy as 1... 2... 3...",
        "Preview the generated Recipe as a graph.",
        "Following the Recipe is easy when using the Timer.",
        "New in v2.0, save Notes and rate your brew."
    ]

    let footerStrings: [String] = [
        "1. Set the amount of coffee.\n2. Choose your flavor balance.\n3. Choose your strength.",
        "See how each pour is broken down and learn how your choices change your recipe.",
        "Know exactly when to start pouring and how much water to pour.",
        "Automatically records stats on your session. Add extra details like grind size, water temperature, coffee choice, and more."
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
