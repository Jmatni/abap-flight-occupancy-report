# Flight Occupancy ALV Report

SAP ABAP report developed to analyze airline flight occupancy using ALV Grid Display.

This project was created as part of my SAP ABAP learning journey, focusing on practical development concepts commonly used in real SAP environments.

---

# Features

- Airline filtering
- Flight date selection
- Occupancy percentage calculation
- Flight status identification
- Occupancy range filtering
- ALV Grid visualization
- Authorization check
- Automatic column optimization
- Zebra layout for better readability

---

# Technologies Used

- ABAP
- Open SQL
- SAP GUI
- Eclipse ADT
- ALV Grid Display
- Function Modules

---

# SAP Concepts Applied

## Data Selection
- SELECT
- INNER JOIN
- WHERE conditions
- SELECT-OPTIONS
- PARAMETERS

## Internal Table Processing
- LOOP AT
- MODIFY
- CLEAR
- Internal Tables
- Work Areas

## ALV Reporting
- REUSE_ALV_GRID_DISPLAY
- Field Catalog
- Layout Configuration
- Zebra Pattern
- Automatic Column Width

## Security
- AUTHORITY-CHECK

---

# Business Logic

The report:

1. Reads flight data from:
   - SFLIGHT
   - SCARR

2. Calculates flight occupancy percentage:
```abap
occupancy = occupied seats * 100 / maximum seats
```

3. Determines flight status:
- FULL → occupancy >= 80%
- AVAILABLE → occupancy < 80%

4. Applies optional occupancy filtering based on user parameters.

5. Displays the final result using ALV Grid.

---

# Selection Screen

The report allows the user to:

- Select airline
- Select flight date range
- Filter occupancy ranges
- Display only flights within a defined occupancy percentage

---

# Example Output

The ALV report displays:

- Airline
- Airline Name
- Connection
- Flight Date
- Price
- Currency
- Maximum Seats
- Occupied Seats
- Occupancy Percentage
- Flight Status

---

# Learning Objectives

This project was developed to practice:

- ABAP report programming
- Open SQL queries
- Data processing logic
- ALV report generation
- SAP authorization concepts
- Eclipse ADT workflow
- Git/GitHub integration for SAP projects

---

# Author

José Henrique

SAP ABAP Developer in transition into the SAP ecosystem.
Currently focused on ABAP and Fiori development for SAP S/4HANA.