# Rock Paper Scissors Live Classification
Live machine learning classification of Rock Paper Scissors Game. Collected data from surface EMG, determined and trained an appropiate machine learning algorithm, and developed a live classification script.

## Purpose
This project was done as part of Neurotechnology, Brains, and Machines at Olin College of Engineering. This two week sprint expanded on work done during the first Sprint where I looked deeper into feature extraction and selection [Link to Sprint 1](https://github.com/sam-coleman/EMG_Classification) using sample data. 

## EMG Sensor Placement
Sensor 1 was placed on the right extensor digitorum which extends the four digits of the hand. Sensor 2 was placed to target the right abductor policis longus which abducts the thumb at the wrist. Sensor 3 was placed to target the right flexor digitorym superficialis which flexes the middle four digits of the hand.

## Final Algorithm
Feature Selection was carried out by adding one feature at a time. If adding a feature improved accuracy, it was kept. If it decreased accuracy, or reamiend the same, it was removed. After every feature was tested, the list of features was reversed (starting at the beginning) and they were removed. If removing it improved accuracy, it was removed, else, it was put back. This process is documented [here](https://docs.google.com/spreadsheets/d/1_M0wU93rq6NhsuKuyM3MYKQpqXO0I0K3_6vRxLUg01A/edit?usp=sharing). 

After going through this process, a basic SVM algorithm was used with average amplitude change (aac), 
difference absolute mean value (damv), difference absolute standard deviation value (dasdv), and maximum value (max) for each channel. On training data with 96 samples, this resulted in a validation accuracy of 86.46% using 5 fold cross validation.

## Live Classification
The live classification is carried out in [Live.m](https://github.com/sam-coleman/EMG_Data_Collection/blob/main/Live.m). After MATLAB is able to get data from the Arduino, you inititate a throw by pressing any key. You will be prompted with Rock, Paper, Scissors, SHOOT!!! and you play on shoot. The move is analayzed using the saved model, and the prediction is outputted to the MATLAB terminal. You can then repeat this process by pressing any key again.

## Next Steps
1. Determine optimal sensor placement by trying different locations and different combinations of locations to see what works best. Collecting more data would also be beneficial to have a greater training data size. 
2. Experiment with extracting different features, and go through a deeper feature selection and algorithm choice process.
3. Explore how to best maintain accuracy between trial days. Extensive documentation of sensor placement was done, however, the sensors being in slighly different places heavily impacts results. Additionally, as the sensors are on longer, they become less conductive and accuracy decreases. Ways to mitigate this could be explored.

## Acknowledgements
Sensor placement was adapted from Jadelin McLeod.   
The base code for data collection script was adapted from Professor Sam Michalka.
