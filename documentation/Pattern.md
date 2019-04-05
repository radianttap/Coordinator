[Coordinator](../README.md) : the **Pattern** · the [Library](Library.md) · the [Class](Class.md) · recommended [Implementation](Implement.md)

## Coordinator: the pattern 
(and why you need to use it)

[`UIViewController`](https://developer.apple.com/documentation/uikit/uiviewcontroller), in essence, is very straight-forward implementation of MVC pattern: it is mediator between data model / data source of any kind and one `UIView`. It has two roles:

- receives the _data_ and configure / deliver it to the `view`
- respond to actions and events that occurred in the view
- route that response back into data storage or into some other UIViewController instance

No, I did not make off-by-one error. The 3rd item should not be there but it is in the form of [show](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621377-show), [showDetailViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621432-showdetailviewcontroller), [performSegue](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621413-performsegue), [present](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-present) & [dismiss](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss), [navigationController](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621860-navigationcontroller), [tabBarController](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621169-tabbarcontroller) etc. Those methods and properties should never be found inside your UIViewController code.

> UIViewController instance should *not care* nor it should *know* about any other instance of UIVC or anything else.

It should only care about its input (data) and output (events and actions). 
It does not care who/what sent that input. It does not care who/what handles its output.

**Coordinator** is an object which 

* instantiates UIVCs
* feeds the input into them
* receives the output from them

It order to do so, it also:

* keeps references to any data sources in the app
* implements data and UI _flows_ it is responsible for
* manages UI screens related to those flows (one screen == one UIVC)

#### Example

Login flow that some `AccountCoordinator` may implement:

1. create an instance of `LoginViewController` and display it
2. receive username/password from `LoginViewController`
3. send them to `AccountManager`
4. If `AccountManager` returns an error, deliver that error back to `LoginViewController`
5. If `AccountManager` returns a `User` instance, replace `LoginViewController` with `UserProfileViewController`

In this scenario, `LoginViewController` does not know that `AccountManager` exists nor it ever references it. It also does not know that `AccountCoordinator` nor `UserProfileViewController` exist.

