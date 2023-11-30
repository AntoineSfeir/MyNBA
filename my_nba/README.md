
# my_nba

Our application user interface comes equipped with features such as adding, editing, and removing players, teams, and games from the the built-in database and pages dedicated to each of these categories. All of these operations can be executed with a click of a button. Along with that, our homepage is enabled to run multiple SQL test queries in order to find specific instances within the database. The database contains all relevant information regarding players, teams, and games as well as links between entities. The application was specifically designed to be simple to use with concise labels that make it accessible for just about any user.

To run the application in VSCode, one must first have Flutter downloaded as well as all other necessary components. The next step is to simply enter the command "cd my_nba" in the terminal panel, followed by the command "flutter pub get" to gather the dependencies, then finally "flutter run". After these commands you will be prompted to choose which device you are running the application on. Make sure you run on the LOCAL machine because the db requires it to be locally run because it can't be accessed on the web. After you run the app, the most important step is to click the botton right red button on the home page to reload the database.

If you are having problems running on Mac, you might need to run thus command from my_nba directory:
rm macos/Podfile.lock && cd macos && pod install && cd .. && flutter pub get

Then try running again.

Hopefully this works, the last resort if you are still having problems is it might have to be run from xcode on mac by right clicking the macos folder and clicking "Open in Xcode" with all target macos deployment targets set to 10.14 in general.

## TEST QUERIES: 
Located in my_nba/testQueries.session.sql also in the report.
The database in vscode is separate from the one in the app for some reason, so the steps are different.

To run the queries in the app:
- Open the app
- Click the red button on the bottom right of the homepage to reload the database!!
  
To run the queries in vscode:
- Install SQLTools and SQLlite necessary extensions
- Connect to the database at my_nba/lib/assets/my_nba.db
- Open my_nba/lib/assets/database_dump.sql
- At the top, click "run on active connection" to load the database

All other relevant information and documentation regarding how to set up the application given our code can be found in the links below. 

## Setup links

https://docs.flutter.dev/get-started/install

https://docs.flutter.dev/get-started/editor

https://docs.flutter.dev/tools/vs-code

https://www.geeksforgeeks.org/how-to-install-flutter-on-visual-studio-code/
 
