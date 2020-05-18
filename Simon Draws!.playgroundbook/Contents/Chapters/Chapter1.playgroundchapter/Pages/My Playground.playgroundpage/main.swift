/*:

# Simon Draws

Created By [Alexandru Turcanu](https://github.com/Pondorasti)

*/

import PlaygroundSupport

/*:
 ## Welcome to Simon Draws!

 ![Simon Poster](Poster.png)

 - callout(Alex):
    Hey WWDC 🛠! Shortly you will be introduced to Simon, but before you go and start having fun, there's a couple of things I need to tell you.



 - callout(WWDC):
    *impatiently waiting 🙄*



 - callout(Alex):
    Don't worry, it won't take long, here's the gist of the game:




 "Simon Draws" is a game of memory 🧠 combined with drawing ✍️.

 First of all, you will have to tell Simon which theme of symbols you prefer and then draw each icon a couple of times, so that Simon can familiarize with your drawing style.

 Afterward you will be shown a sequence of icons and your task is to draw them in the same order as they are presented to you.

 Play. Repeat. Play 😝

 **Drawing Tips:**
 * Try to keep your drawings simple and consistent
 * Do not make similar drawings for different icons
 * Feel free to use an Apple Pencil if you've got one nearby
*/
/*:
 - Important:
    For a better experience, make sure to disable **Results** , close all source-code files if any open, and set your volume around 50%.
*/
/*:
- Important:
   If Simon is having trouble recognizing your sketches or you don't have much drawing experience, try to create figure-stick style drawings and keep them as simple as possible.
*/
PlaygroundPage.current.setLiveView(MainView())
/*:
## Simon being inclusive

### Dialogs duration
 Simon likes to be friendly and talk to you, but he will show each sentence for a limited amount of time. You can modify `Simon.dialogDuration` to your desired reading speed.

 - Example:
    `Simon.dialogDuration = 5.0, (unitOfMeasure: seconds, defaultValue: 2.5)`
*/
/*:
 - Note:
    If you already played the game and want to skip all the dialog sequences set `dialogDuration` to `0.0`
*/
//Simon.dialogDuration
/*:
### Drawing Buffer
 When using the Drawing Canvas to create your own sketches, you can lift your finger or stylus off the screen and continue the drawing from a different point. The `drawingBuffer` determines the time allocated for this action.

 - Example:
 `Simon.drawingBuffer = 1.0, (unitOfMeasure: seconds, defaultValue: 0.75)`
*/
/*:
 - Note:
    There's no error handling implemented for these properties, please use reasonable values. Looking at you negative numbers 👀.
*/
//Simon.drawingBuffer

