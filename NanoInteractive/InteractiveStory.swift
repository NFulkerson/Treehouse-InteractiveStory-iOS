//
//  InteractiveStory.swift
//  NanoInteractive
//
//  Created by Nathan Fulkerson on 11/5/16.
//  Copyright © 2016 Nathan Fulkerson. All rights reserved.
//

import Foundation
import UIKit

enum Story: String {
    case ReturnTrip
    case TouchDown
    case Homeward
    case Rover
    case Cave
    case Crate
    case Monster
    case Droid
    case Home
}

extension Story {
    var artwork: UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    var text: String {
        switch self {
        case .ReturnTrip:
            return "On your return trip from studying Saturn's rings, you hear a distress signal that seems to be coming from the surface of Mars. It's strange because there hasn't been a colony there in years. \"Help me, you're my only hope.\""
        case .TouchDown:
            return "You deftly land your ship near where the distress signal originated. You didn't notice anything strange on your fly-by, behind you is an abandoned rover from the early 21st century and a small crate."
        case .Homeward:
            return "You continue your course to Earth. Two days later, you receive a transmission from HQ saing that they have detected some sort of anomaly on the surface of Mars near an abandoned rover. They ask you to investigate, but ultimately the decision is yours because your mission has already run much longer than planned and supplies are low."
        case .Rover:
            return "The rover is covered in dust and most of the solar panels are broken. But you are quite surprised to see the on-board system booted up and running. In fact, there is a message on the screen. \"Come to 28.2342, -81.08273\". These coordinates aren't far but you don't know if your oxygen will last there and back."
        case .Cave:
            return "Your EVA suit is equipped with a headlamp which you use to navigate to a cave. After searching for a while your oxygen levels are starting to get pretty low. You know you should go refill your tank, but there's a faint light up ahead."
        case .Crate:
            return "Unlike everything else around you the crate seems new and...alien. As you examine the create you notice something glinting on the ground beside it. Aha, a key! It must be for the crate..."
        case .Monster:
            return "You pick up the key and try to unlock the crate, but the key breaks off in the keyhole.You scream out in frustration! Your scream alerts a creature that captures you and takes you away..."
        case .Droid:
            return "After a long walk slightly uphill, you end up at the top of a small crater. You look around and are overjoyed to see your robot friend, Droid-S1124. It had been lost on a previous mission to Mars. You take it back to your ship and fly back to Earth."
        case .Home:
            return "You arrive home on Earth. While your mission was a success, you forever wonder what was sending that signal. Perhaps a future mission will be able to investigate."
        }
    }
}
// We could use a struct, but unfortunately because our Page contains a Page, it causes some 
// crazy recursion issues. So let's do this instead.
class Page {
    let story: Story
    // Tuples are actually anonymous structs.
    // We don't have to clutter our model layer, and keep it in appropriate scope
    // But still get a convenient and readable alias to refer to
    
    typealias Choice = (title: String, page: Page)
    
    var firstChoice: Choice?
    var secondChoice: Choice?
    
    init(story: Story) {
        self.story = story
    }
    
}
// Ugly way
//extension Page {
//    func addChoice(title: String, page: Page) -> Page {
//        if firstChoice == nil && secondChoice == nil {
//            if firstChoice == nil {
//                firstChoice = (title, page)
//            } else {
//                secondChoice = (title, page)
//            }
//        }
//        return page
//    }
//}

extension Page {
    
    func addChoice(title: String, story: Story) -> Page {
        let page = Page(story: story)
        return addChoice(title: title, page: page)
    }
    
    func addChoice(title: String, page: Page) -> Page {
        switch (firstChoice, secondChoice) {
        case (.some, .some): break
        case (.none, .none),
             (.none, .some):
            firstChoice = (title,page)
        case (.some, .none):
            secondChoice = (title,page)
            
        }
        return page
    }
}
// linked list structure or tree structure
struct Adventure {
    // Earlier, we learned containing reference-types inside of value-types can lead to
    // problematic behavior. Here, it's ok because we have a static, computed value. It
    // cannot be mutated.
    static var story: Page {
        let returnTrip = Page(story: .ReturnTrip)
        let touchdown = returnTrip.addChoice(title: "Stop and Investigate", story: .TouchDown)
        let homeward = returnTrip.addChoice(title: "Continue Home to Earth", story: .Homeward)
        let rover = touchdown.addChoice(title: "Explore the Rover", story: .Rover)
        let crate = touchdown.addChoice(title: "Open the Crate", story: .Crate)
        
        homeward.addChoice(title: "Head back to Mars", page: touchdown)
        let home = homeward.addChoice(title: "Continue Home to Earth", story: .Home)
        
        let cave = rover.addChoice(title: "Explore the Coordinates", story: .Cave)
        rover.addChoice(title: "Return to Earth", page: home)
        
        cave.addChoice(title: "Continue towards faint light", story: .Droid)
        cave.addChoice(title: "Refill the ship and explore the rover", page: rover)
        
        crate.addChoice(title: "Explore the Rover", page: rover)
        crate.addChoice(title: "Use the key", story: .Monster)
        
        return returnTrip
    }
}
