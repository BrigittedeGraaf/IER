Project Title: Correlation between female independence and violence used against children - a data analysis

### README for dataset
#### 1. Introductory information
Dataset: IER_research_data.xlsx (Format: Microsoft Excel Worksheet)

This file contains data on crude marriage rate (CMR), crude divorce rate (CDR), the gender wage gap in %, the amount of children that experienced violence in (%), the countries this data related to, how many people live in that country, in which continents these countries are located and in which UN Statistical subregion they are located. The links to the sources are also added to this document. More detailed sources are given in the paper. Column H contains the sources on the data of the gender wage gap, when the cell says nothing the source is visible in N8, if it says N9 etc.. Column J contains the sources on the data on the amount of children that experienced violence, when the cell says nothing the source is visible in N12, if it says N13 etc.

For questions about the dataset, contact j.m.degraaf@student.tudelft.nl

#### 2. Methodological information
Dataset:
The data was collected by searching online whilst keeping into account the validity of the source. This had to be either governments or recognized (large) international organizations.


#### 3. Data specific information
The dataset includes:

- A: country name
- B: population amount (2018 data, measured per in how many persons)
- C: continent
- D: UN Statistical subregion
- E: CMR (crude marriage rate, amount of people to get married per 1000 people in one year)
- F: CDR (crude marriage rate, amount of people to get married per 1000 people in one year)
- G: The gender wage gap (%)
- H: Sources used for the gender wage gap data
- I: Children that experienced violence (%)
- J: Sources used for the children that experienced violence dataset
- M, N: Further elaboration on the sources

Missing data results in empty columns, in MATLAB this becomes 'NaN' and is filtered out.

UN is an abbreviation for United Nations. No further abbreviations used.

#### 4. Sharing and Access information
No restrictions are placed on this data. All data used can be found for free on the internet.

##########################################################################
### README for software/code

## 1. Introductory information
analysis_IER.m
This file contains the mathematical analysis performed on the data in IER_research_data.xlsx
In the document comments further explain the code.

## 2. Methodological information - Running the test and deployment
Installation instructions:
1. Install MATLAB.
2. Download the code.
3. Download the Excel file.
4. Make sure the code and the Excel file are located in the same folder on your computer.
5. Uncomment the plots that you want to become visible.
6. Run the code.


## 3. Goal of the project - Sample Test
First the data is pre-processed to filter out incomplete data-sets. After this it is processed to show correlation between the various categories. Various figures are commented to make running the code faster. Various comments within the code further elaborate on what the variables entail and what specific operations are performed. The code is used to determine correlations between three main variables, give a visual representation of this data and to determine whether the sample size is large enough to draw conclusions for a population.

## Style test
Example of coding style:
```
%find correlation between the various variables
%x:the ratio CDR/CMR
%y:the gender wage gap (%)
%z:children that experienced violence (%)
r_xy=corrcoef(Matrix_w(:,1), Matrix_w(:,2));    %Correlation between x and y
r_yz=corrcoef(Matrix_w(:,2), Matrix_w(:,3));    %Correlation between y and z   
r_xz=corrcoef(Matrix_w(:,3), Matrix_w(:,1));    %Correlation between x and z
```

## Built with and acknowledgements
The helps of MathWorks MATLAB forum and the Help Center.

## Authors
- Brigitte de Graaf

## License
MATLAB R2021a was used for this Project
