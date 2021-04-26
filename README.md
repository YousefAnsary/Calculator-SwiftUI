# Calculator
***iOS Calculator App with undo/redo functionality& EGP->USD Currency Converter*** <br/>
### Features
- [x] Written in Swift 5 using Xcode 12.1
- [x] Written using SwiftUI& Combine
- [x] Supports iOS 14
- [x] Does not use any 3rd parties
- [x] Full history undo& redo
- [x] Selective Undo for each operation
- [x] MVVM Architected
- [x] Unit Tested (Currency Converter Only)
- [x] Documented Code using Jazzy in /docs/index.html (Currency Converter Only)
- [x] Test Coverage Report using Slather in /html/index.html

<br/>

### Architecture
This app is MVVM architected since it is the preferred native way to use with SwiftUI& Combine and <br/>
to avoid putting it all together in the view layer which is not acceptable at all for a lot of reasons.

### Design Patterns
Mediator Design Pattern: To notify Currency Converter with new Calculations and vice versa. <br/>
