# moneybox
Technical iOS task submission

## Summary

The goal of this task according to [the brief](https://github.com/MoneyBox/ios-technical-task) was *"To create a 'light' version of the Moneybox app that will allow existing users to login and check their account balance as well as viewing their moneybox savings."*

## Running the project

Clone the project and open the main project file in Xcode. You can run the unit tests and compile and run the project as normal, either to device or simulator. 

### Login Screen

The login screen allows the user to login against the Moneybox test server using the valid credentials provided in the brief. You will not be able to log in with an invalid email, unauthorised login details or with one of or both fields missing. However, the name field is optional and will not corrupt the view if left empty.

If the login callback doesn't execute fully (including retrieving data for the next page) within the 5 minute timeout the user will remain on the login page. The user can return to this page from any other page by logging out, and they will need to log back in successfully. 

### User Accounts

The user accounts screen displays the available user accounts dynamically and updates before the page is retrieved from any other page. This includes the user's chosen name and the total plan value. 

### Individual Account

The individual account page will retrieve and display the information associated with the touched cell on the User Accounts page. If the one-off payment button is pressed, the server will be updated with the new value before the UI is also updated so that if the user navigates back to the User Accounts page, they will see the new value without delay or error. 
