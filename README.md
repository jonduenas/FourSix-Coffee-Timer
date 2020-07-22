# FourSix Coffee Timer

FourSix is a coffee timer and calculator for iOS built using Swift and UIKit for iOS 13 and up.

[App Store Link](https://apps.apple.com/us/app/id1519905670)

![iPhone Screenshot 1](https://github.com/jonduenas/FourSix-Coffee-Timer/raw/main/Screenshots/iPhone-6.5-inch-Screenshot-1.png) ![iPhone Screenshot 2](https://github.com/jonduenas/FourSix-Coffee-Timer/raw/main/Screenshots/iPhone-6.5-inch-Screenshot-2.png) ![iPhone Screenshot 3](https://github.com/jonduenas/FourSix-Coffee-Timer/raw/main/Screenshots/iPhone-6.5-inch-Screenshot-3.png) ![iPhone Screenshot 4](https://github.com/jonduenas/FourSix-Coffee-Timer/raw/main/Screenshots/iPhone-6.5-inch-Screenshot-4.png)

FourSix makes brewing pour over coffee easy.

There are countless ways to brew coffee. For coffee enthusiasts, sometimes these methods can get... complicated. And following a more complex recipe can be difficult, especially in the morning when you haven't had your coffee yet.

Part calculator, part timer, FourSix is designed to take a complicated method for pour over and make it simple and easy, even if you're still not completely awake. Named after the 4:6 method invented by Tetsu Kasuya, FourSix will create a custom pulse pour recipe based on 2 simple questions - Do you like your coffee sweeter or brighter? And how strong do you like your coffee? Instantly, you'll see how each pulse-pour will break down, and how they affect your final cup. When you're ready to start, simply follow along with the Timer telling you exactly how much to pour and when. Not only will you get a great cup of coffee, but you'll be able to do it again the next morning.

To use FourSix, you'll need a Hario V60 and a scale that measures in grams. Additional helpful tools include a pouring kettle with a narrow spout and a thermometer to test water temperature.

If you like FourSix, but want even more control over the recipe, you'll want FourSix Pro. A one-time, in-app purchase gives you extra settings so you can dial in your perfect brew exactly how you like. Plus, you'll be supporting future development and more new features to come.

## Why I Built FourSix

I built FourSix as my first ever app because I love coffee. As a coffee enthusiast, I've done a lot of experimenting with new equipment and recipes. And although coffee timers are not in short supply in the App Store, I couldn't find an app that worked how I wanted. Plus, many are outdated or poorly designed. The few that looked and worked well were usually "recipe" type apps. They had collections of a few specific, general recipes for certain types of brews and equipment, or they allowed you to create your own. But they all had this style of just having some stored recipes to choose from. There's nothing wrong with this, until I learned about the 4:6 method by Tetsu Kasuya.

The 4:6 method is exactly that - a method. It's not a recipe, like so many others, where you have a set amount of water, coffee, and techniques to get a specific kind of cup. Its premise is to allow experimentation by giving the user the knowledge of how certain adjustments can change the resulting cup, and with this knowledge, allow them to decide how to make their own ideal cup. Instead of picking from a set of recipes without knowing how one differs from another, the user can decide what specific flavor profile they want, and their own custom recipe is generated based on that.

My app, FourSix, is based on utilizing this method, and allow any user to quickly and easily generate a recipe for themselves. The hardest part of customizing the 4:6 method is the math involved. Your total water is split into 40% and 60% - the 40% affecting sweetness and acidity, and the 60% affecting strength and extraction. The 40% is split into 2 separate pours, with the amounts of each pour resulting in the spectrum of different flavor you can produce. The 60% can be split evenly into 2, 3, or 4 separate pours - the more pours, the stronger the extraction. So if you have 300g of water, your 40% is then 120g, and the 60% is 180g. The 120g can be split evenly or pushed one way or the other. The 180g can be split into 2 pours of 90g each, 3 pours of 60g each, or 4 pours of 45g each.

Already, you can see how the complexity can be a bit much to handle in the morning when you haven't even had your coffee yet. FourSix was designed to take all that complexity and put it behind a simple 2 questions - Do you want a sweet or bright flavor? And how strong do you want it?

## Technologies

* Swift 5
* UIKit
* CocoaPods
* RevenueCat for In-App purchases
