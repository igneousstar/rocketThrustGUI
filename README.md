# rocketThrustGUI
This is a gui built with processing to see live data from an arduino. I created it for testing the amount of thrust from our rocket engines. You will need to have an arduino and hook up the a load cell to it. I used the HX711. Here is the link to the load cell that I purchased from SparkFun:  https://www.sparkfun.com/products/13332?_ga=2.187020970.361818836.1496541420-428885631.1496541420  

You will also need a load cell amplifier. I used the HX711. I used the arduino library from Spark Fun as well. If you use a different library, you may need to adjust the firmware. 

After opening the GUI, you need to select a com port. Click on one of the squares, and it will say "Waiting to test....." After that, you can start the rocket thrust test and will plot live data. When the testing is done, it will save the results if you click on the save data button. You will be able to find the text file it saved to in the same directory as rocketThrustGUI.exe 
