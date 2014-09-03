# StatefulViewController

A view controller subclass that presents placeholder views based on content, loading, error or empty states.

// TODO: Add .gifs

---

In a networked application a view controller typically has the following states that need to be communicated to the user:

* **Loading**: The content is currently loaded over the network.
* **Content**: The content is available and presented to the user.
* **Empty**: There is currently no content available to display.
* **Error**: An error occured whilst downloading content.

As trivial as this flow may sound, there are a lot of edge cases that result in a large tree of possible states.

/// TODO: Image of tree

StatefulViewController is a concrete implementation of this particular decision tree. (If you want to create your own modified version, you might be interested in the [state machine]("#viewstatemachine") that is used to show and hide views.)

## Usage

Configure the `loadingView`, `emptyView` and `errorView` properties of your subclass in `viewDidLoad`.

After that, simply tell the view controller if content is currently being loaded and it will take care of showing and hiding the correct loading, error and empty view for you.

```swift
func loadDeliciousWines() {
	startLoading()
	
	let url = NSURL(string: "http://example.com/api")
	let task = session.dataTaskWithURL(url) { (let data, let response, let error) in
		endLoading(error: error)
	}
}
```

<a href="#viewstatemachine"></a>
### View State Machine

> Note: The following section is only intended for those, who want to create a stateful controller that differs from the flow described above.

You can also use the underying view state machine to create a similar implementation for your custom flow of showing/hiding views.

```swift
// TODO: code sample
```

## Installation

<strike>pod "StatefulViewController", "~> 0.1"</strike>

For now, just drag and drop the two classes in the `StatefulViewController` folder into your project.

## Tests

Open the Xcode project and press `⌘-U` to run the tests.

Alternatively, all tests can be run in the terminal using [xctool](https://github.com/facebook/xctool) (once it is ready for Xcode 6).

```bash
xctool -scheme Tests -sdk iphonesimulator test
```

## Todo

* Default loading, error, empty views
* Protocol on views that notifies them of removal and add
* Views can provide delays in order to tell the state machine to show/remove them only after a specific delay (e.g. for hide and show animations)



## Contributing

* Create something awesome, make the code better, add some functionality,
  whatever (this is the hardest part).
* [Fork it](http://help.github.com/forking/)
* Create new branch to make your changes
* Commit all your changes to your branch
* Submit a [pull request](http://help.github.com/pull-requests/)


## Contact

Feel free to get in touch.

* Website: <http://schuch.me>
* Twitter: [@schuchalexander](http://twitter.com/schuchalexander)


## Licence

Copyright (c) 2014 Alexander Schuch (http://schuch.me)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
