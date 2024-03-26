# In-Class Assignment 1 (Black Box)

## Question

[3 marks]  Consider a web app that manages customers of a company.  Suppose the Index View of the Customers in the web app has a button labeled “Search” next to the “Create” button.  Pressing this button brings up a search page that allows the customers’ list to be filtered based on name, their date of birth and/or their location as follows:

- For keyword-based search, the user is expected to specify a keyword of up to 10 printable characters in a text box labeled “Name” on this search page.  Upon user specifying such a keyword and pressing the OK button on the search page, the application navigates user back to the Index view but lists only those customers whose first name or last name contains the specified keyword.  Assume that all printable characters are treated equally.

- To support the search based on the date of birth, the user is expected to specify a FromDate and a ToDate in the two text boxes labeled as such on this search page (with the help of date pickers).  Upon user specifying such date range and pressing the OK button on the search page,  the  application navigates the user back to the Index view but lists only those customers who were born during the specified period.

- For location-based search, the user is expected to specify a search area defined by {[TopLeft.Lat, TopLeft.Long] and [BottomRight.Lat, BottomRight.Long]} bounded by {[90, -180], [-90, 180]}.  If application can geocode the customer’s address into a [latitude, longitude] pair, upon user specifying the search area and pressing the OK button, the application navigates the user back to the Index view but then lists only those customers who live in the specified area.

Determine the equivalence partitions for the above keywords, time, and location area-based search.

## My Answer

### For keyword (name) based search

- We can consider different cases such as an empty input, minimum and maximum valid input, and inputs with special characters. Some people like Elon Musk’s child has numbers in their names.
- Valid Cases: “John”, “Doe”, “Alice”
- Invalid Cases: “”, “ThisisAnExampleThatIsTooLong”, “Name with spaces”,

### For date-of-birth based search

- We can consider partitions for dates before the system’s date and future dates.
- The date picker could let you pick from the oldest date in your database up to a fews days into the future.
- We can consider cases where FromDate is greater than ToDate, and vice versa.
- Valid Case: “FromDate: 01/01/19800, ToDate: 12/31/2030”
- Invalid Case: “FromDate: 01/01/2025, ToDate 12/31/2024”

### For location-based search

- We can consider partitions for different areas, such as top-left corner, bottom-right corner, center, boundaries, etc.
- We can consider cases where latitude or longitude values are at the minimum or maximum allowed values.
- Valid Case: “[30, -90], [40, -80]}”
- Invalid Case: “[50, -100], [60, -90, 70]}”
