//
//  Documentations.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

/// This file implements all related classes related to 'Documentations', including:
/// - `DocumentationsManager` - the singleton interface to SwiftUI
///
/// The term 'Documentation' includes:
/// - Documentations about the project / about the app
/// - Documentations about the OCD
/// - User Guides
///
/// In fact, the contents in this file should be integrated into an SQL database. However, since the amount of the documentations is not large, SQL was not adopted.

import Foundation
import SwiftUI

struct GuideItem: Identifiable {
    let id = UUID()
    
    let symbolName: String
    let symbolColor: Color
    let title: String
    let content: String
}


class DocumentationsManager {
    // The `documentations` dictionary stores all the documentations.
    // The value part of the dictionary is of type `AnyView`, which may not seem very reasonable, but it is actually a compromise, as some content needs to be bolded.
    static let documentations: [String: AnyView] = [
        "BRIEF_INTRODUCTION": AnyView(Text("OCDResolver").bold() + Text("""
                                             is designed to help people with Obsessive Compulsory Disorder (OCD). You can record your mental state and feelings here when compulsive behavior occurs. The app gathers and shows your records to help you understand OCD and alleviate your symptoms over time.
                                            """)),
        "AIM_OF_THE_PROJECT": AnyView(Text("""
                         Obsessive Compulsory Disorder (OCD) – a mental health condition where a person has obsessive thoughts and compulsive behaviours [NHS-UK], can cause people to remain in a state of anxiety for a long time and affecting their lives. It's difficult for individuals with OCD to escape from it.
                         
                         According to [Goodman, 2014], in the United States, OCD 'affects up to 2.3% of the population over the course of a lifetime and can be disabling'. And in China, the number is 2.4% [Huang et al., 2019]. These are incredibly large numbers. If we can make some changes for them, it would be really meaningful.
                         
                         Based on this, I have designed this app, OCD Resolver. The goal of this app is clear — to help alleviate the symptoms of OCD. While individuals with OCD may still pursue the perfect or take compulsory behaviors, they will not be distressed if things don’t go as their expectations.
                         
                         The app is easy to use — whenever you experience obsessive thoughts or compulsive behaviors, regardless of whether they make you feel anxious or not, you record them here. On the homepage, you can add a record with just one click. Of course, you can also choose to add some notes.
                         
                         In addition, this app introduces a wealth of reliable documentations designed to enhance or even treat OCD. While these are not medical advices, they can help individuals with OCD ease their psychological burden on a mental level. 
                         """)),
        "What is OCD?": AnyView(
            VStack {
                Text("There are many specific definitions of OCD, but the core is the same. Here we use the definition from [NHS-UK]. \n\n") +
                Text("Obsessive Compulsive Disorder (OCD) is a mental health condition where a person has ") + Text("obsessive thoughts and compulsive behaviours").bold() + Text(".\n\n") +
                
                Text("You might need to worry about OCD when situations like the following occur:\n\n").bold() +
                Text("""
                     - You wash your hands countless times every day, constantly feeling like they are dirty or have something unclean on them.
                     
                     - You only start doing things at specific times (for example, you can only start doing things at 9:00, and not at 8:55).
                     
                     - There are persistent thoughts in your mind and you cannot get rid of them. The more you try to ignore them, the more they stick, and it makes you distressed.\n
                     """)
                
                Link("Click to redirect to [NHS-UK]", destination: URL(string: String("https://www.nhs.uk/mental-health/conditions/obsessive-compulsive-disorder-ocd/overview/"))!)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        ),
        
        "Morita Therapy": AnyView(
            VStack {
                Text("""
                     Morita Therapy aims to have the patient accept life as it is and places an emphasis on letting nature take its course. Morita therapy views feeling emotions as part of the laws of nature. Researches show that Morita Therapy is effective in alleviating OCD.\n
                     """)
                
                Link("Click to redirect to [Wikipedia]", destination: URL(string: "https://en.wikipedia.org/wiki/Morita_therapy")!)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
    ]
    
    static let documentationsList = [
        "What is OCD?",
        "Morita Therapy"
    ]
    
    // Guide items in `GuideScreenView`
    // [(String, String, String)] = [(symbolName, title, content)]
    static let guideItems: [GuideItem] = [
        GuideItem(symbolName: "record.circle",
                  symbolColor: .red,
                  title: "Record Your Mental State",
                  content: "Whether you feel distressed or anxious because of OCD, or happy because you followed your OCD habits, please record it down."),
        GuideItem(symbolName: "note.text",
                  symbolColor: .blue,
                  title: "Take Notes",
                  content: "Take extra notes detailing your specific OCD behaviors and your mental condition at that moment, so you can review them later."),
        GuideItem(symbolName: "books.vertical",
                  symbolColor: .orange,
                  title: "Learn More About OCD",
                  content: "Refer to the attached OCD-related informational materials to enhance your understanding and awareness of OCD.")
    ]
    
    static let unavailableDocumentationView = AnyView(Text("Unavailable content."))
}
