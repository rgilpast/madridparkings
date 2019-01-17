# Madrid Parkings

An example practice to populate parkings and vehicle deposits from open API of Madrid council. 
This sample uses MVP pattern, and persists data to show the information when networking connection fails.
The project uses Carthage as dependency manager for third party libraries.

By now the app only show a list of public parkings. Next it will show resident parkings and vehicle deposits.

To install and compile: 

- download the project and before build and run, download the Carthage dependencies, executing the next command in a terminal:

carthage update --platform iOS

TODO: 

- Show a side bar menu with options about the kind of list to show, and update the main list with right results.
- Add a "pull to refresh" control in the list.
- Show message to user when there is no networking connection available. Add localization in English and Spanish for the necessary messages.
- Add a Splash Screen.
- Add some unit tests.
- Add future features like show detail info for eaach parkinbg or deposit, show map locations, with routing service from current location,...
