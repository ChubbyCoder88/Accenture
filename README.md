

 Project is built in storyboard using MVVM.
 Combine is used for API calls.
 App supports ipad/iphones and been tested on all sizes.
 Unit tests included.
 
 The two primary view controllers are AccountsVC & TransactionsVC.
 
 Each VC has a slightly different style just to demonstate diffferent approaches.
 
 AccountsVC       - Most things occur within the ViewController.
                            - inputIntoViewModel takes data from the api call and inputs it into the viewModel.
                            - cellForRowAt binds the data to the cell.
                      
TransactionsVC   - Most things occur outside the ViewController. *This  is my preference.
                            - refactorAndInsertIntoViewModel is within an external struct CleanData. 
                            - The function takes data from the api call and inputs it into the viewModel then passes it back using a completion or throwing if there is an error or incomplete data.
                            - didSet within the cell binds the data to the cell.
                            - the color of the amountLabel is red or blue depending whether it is a positive or negative amount. This 'color' value is placed within the ViewModel. 
                            - Add().getColor(color: color) takes the color from the viewModel as a string and returns it as a UIColor.
                            - newDate within the viewModel is a boolean being true if the date is different to the previous date, indicating that it should be the larger cell (TransactionsCell) instead of (TransactionsSmallCell). 
                            - Transactions are ordered by decending date and are grooped by date.
                            
HttpClient           - Contains Combine API calls.

DataModels        - Contains the models and viewModels.
                            
                            

