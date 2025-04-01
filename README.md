# OCDResolver

![Static Badge](https://img.shields.io/badge/Swift%20Student%20Challenge%202025-Winner-brightgreen)

> **OCDResolver** is designed to help people with Obsessive Compulsory Disorder (OCD). You can record your mental state and feelings here when compulsive behavior occurs. The app gathers and shows your records to help you understand OCD and alleviate your symptoms over time.

## Aim of the Project
Obsessive Compulsory Disorder (OCD) – a mental health condition where a person has obsessive thoughts and compulsive behaviours [NHS-UK], can cause people to remain in a state of anxiety for a long time and affecting their lives. It's difficult for individuals with OCD to escape from it.

According to [Goodman, 2014], in the United States, OCD 'affects up to 2.3% of the population over the course of a lifetime and can be disabling'. And in China, the number is 2.4% [Huang et al., 2019]. These are incredibly large numbers. If we can make some changes for them, it would be really meaningful.

Based on this, I have designed this app, OCD Resolver. The goal of this app is clear — to help alleviate the symptoms of OCD. While individuals with OCD may still pursue the perfect or take compulsory behaviors, they will not be distressed if things don’t go as their expectations.

The app is easy to use — whenever you experience obsessive thoughts or compulsive behaviors, regardless of whether they make you feel anxious or not, you record them here. On the homepage, you can add a record with just one click. Of course, you can also choose to add some notes.

In addition, this app introduces a wealth of reliable documentations designed to enhance or even treat OCD. While these are not medical advices, they can help individuals with OCD ease their psychological burden on a mental level. 

## Designing
The aim of this app is to allow people with OCD to record their mental state and feelings when compulsive behaviors or compulsive thoughts occur, and the app will present their records in a way that will eventually help alleviate their OCD. 

I want the user experience to be incredibly smooth. The app should allow users to conveniently record their mental states and feelings [whenever] compulsive behaviors or compulsive thoughts occur, as only in this way can users truly understand their OCD condition. Moreover, I want users to feel like it’s a native iOS app, just like Health, Weather, or Notes. 

So, in this case, we don’t need a very complex framework. And since currently we don’t require multiplatform support, there’s no need to use cross-language libraries. When choosing between UIKit and SwiftUI, UIKit requires me to manually manage every object, which can add unnecessary complexity to this simple app. Therefore, I chose SwiftUI. 

SwiftUI allows me to achieve a look and performance close to a native iOS app, even without a deep understanding of iOS UI management. This is because SwiftUI’s components are very simple and intuitive (such as `NavigationStack`, `List`, or basic elements like `Button` and `Text`). Customizations are also straightforward (for example, `.foregroundColor(.red)`). 

What I’m most proud of is using Swift’s `Charts` library. It provides a wide range of simple and easy-to-use charting interfaces. I used charts to show users how many times they engaged in compulsive behaviors recently and how their mental states were during those times. This makes the app highly user-friendly – not just for recording, but also for presenting and analyzing. 

This app involves a database to store users’ records, requiring interfaces between the frontend and backend. I used many SwiftUI wrappers, including `@ObservedObject` and `@State`. Wrappers allow me to avoid worrying too much about how the UI refreshes, so I can focus on Human-Computer Interaction (HCI) design principles to make the app more user-friendly.
