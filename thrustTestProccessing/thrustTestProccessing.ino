#include "HX711.h"

/*************************************  All of the veriables for the rocket  ***********************************************/

/**
 * Values we are looking for on the rocket
 */
double maxThrust = 0.0;
double footPound = 0.0;

 /**
  * Times
  */
  unsigned long startTime = 0;
  unsigned long currentTime = 0;
  double seconds; 
  unsigned long thrustTime = 0;
  unsigned long printTime = 0;
  unsigned long testTime = 0;

 /**
  * The last reading of the device
  */
  double lastRead = 0;

  /**
   * The current reading
   */
   double currentRead = 0;

   /******************************************** Setting up the scale  *************************************************/

// HX711.DOUT  - pin #A1
// HX711.PD_SCK - pin #A0

HX711 scale(A1, A0);    // parameter "gain" is ommited; the default value 128 is used by the library

/***********************************************  Max and Min functions   ************************************************/

double findMax(double val1, double val2){
  if(val1 > val2){
    return val1;
    }
  else{
    return val2;
  }
}

double findMin(double val1, double val2){
  if(val1 < val2){
    return val1;
  }
  else{
    return val2;
  }
}

/*****************************************************************************************************************************/

void setup() {
  Serial.begin(9600);

  //get rid of funky readings at the start
  scale.read();
  delay(500);
  
  Serial.println(scale.get_units(5), 1);  // print the average of 5 readings from the ADC minus tare weight (not set) divided 
            // by the SCALE parameter (not set yet)  
  scale.set_scale(7050.f);                      // this value is obtained by calibrating the scale with known weights; see the README for details
  scale.tare();               // reset the scale to 0


  //Tell the user we are waiting for the test to begin 
  Serial.println("Waiting for test......");
  thrustTime = millis();
}

void loop() {
    lastRead = scale.get_units();
    

    while(lastRead > 4.0){
      maxThrust = findMax(maxThrust, lastRead);
      startTime = millis();
      currentRead = scale.get_units();
      currentTime = millis();

      //Calculate the work done while the sensor was being read
      footPound += ((lastRead + currentRead) * ((currentTime - startTime))/1000)/2;
      lastRead = currentRead;
      if(millis() - printTime > 10){
        Serial.println(String(currentTime- thrustTime) + "," + String(currentRead));
      }
    }

      if(footPound > 1){
      Serial.println("Work done, waiting to save. Change in momentum: " + String(footPound) + "lbs*s " + "Max Thrust: " + String(maxThrust) + " lbs Time: " + String(currentTime - thrustTime));
//      footPound = 0.0;
//      maxThrust = 0.0;
    }
    else{
      thrustTime = millis();
    }

}
