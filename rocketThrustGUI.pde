import processing.serial.*;
import java.util.ArrayList;



PrintWriter output;
Serial myPort;
String result;
int xPosition;
int yPosition;
boolean comSelected = false;

ArrayList<Float> seconds;
ArrayList<Float> forces;



void setup(){
  seconds = new ArrayList();
  forces = new ArrayList();
  size(1400, 700);
  background(#044f6f);
  fill(#ffffff);

  

  textSize(32);
  text("Select COM port" , 550, 30); 
  textSize(14);
  stroke(204, 102, 0);
  fill(50);
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      rect(365 + i*65 , 55 + j*65, 55, 55);
    }
  }
  fill(255);
  text(1, 388, 85);
  
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      text("" +  j + i, 383 + i*65, 85 + j*65);
    }
  }
}


void draw(){
  if(result != null && comSelected){
    background(#044f6f);
    fill(#ffffff);
    text(result, 10, height-10);
    stroke(0);
    drawGraph();
  }
  if(result != null){
    if(result.length() > 1 && result.charAt(1) == 'o'){
      drawSaveButton();
    }
  }
}


void serialEvent(Serial myPort){
    result = myPort.readStringUntil('\n');
    result = trim(result);
    float[] numbers;
    numbers = float(split(result, ','));
    if(numbers.length == 2 && result.charAt(0) != 'W'){
      seconds.add(numbers[0]);
      forces.add(numbers[1]);
      //println(numbers);
    }
    
  
}

float findMax(ArrayList<Float> list){
  float max = 0;
  for(int i = 0; i < list.size(); i++){
    if(list.get(i) > max){
      max = list.get(i);
    }
  }
  return max;
}

float findMin(ArrayList<Float> list){
  float min = 0;
  for(int i = 0; i < list.size(); i++){
    if(list.get(i) < min){
      min = list.get(i);
    }
  }
  return min;
}

void drawGraph(){
  if(seconds.size() >= 2){
    float maxSecond = findMax(seconds);
    float maxForce = findMax(forces);
    float minSecond = findMin(seconds);
    float minForce = findMin(forces);
    for(int i = 0; i < seconds.size() - 1; i++){
      float x1 = map(seconds.get(i), minSecond, maxSecond, 0, width);
      float x2 = map(seconds.get((i+1)), minSecond, maxSecond, 0, width);
      float y1 = height - map(forces.get(i), minForce, maxForce, 0, height);
      float y2 = height - map(forces.get(i+1), minForce, maxForce, 0, height);
      line(x1, y1, x2, y2);
    }
  }
}

void drawSaveButton(){
  rect(width/2 - 60, 30, 120, 30);
  fill(0);
  text("Save Data", width/2 - 35, 50);
}


void saveAndExit(){
  output = createWriter("thrust" + findMax(forces) + ".txt");
  output.println(result);
  output.println("--------------------------");
  output.println();
  for(int i = 0; i < seconds.size(); i++){
    output.print(seconds.get(i));
    output.print("\t");
    output.println(forces.get(i));
  }
  output.flush();
  output.close();
  exit();
}

void mousePressed(){
  //println("mouse pressed");
  xPosition = mouseX;
  yPosition = mouseY;
  //println(xPosition);
  //println(yPosition);
  if(comSelected == false){
    for(int i = 0; i < 10; i++){
      for(int j = 0; j < 10; j++){
        if((xPosition >= (365 + i*65)) && (xPosition <= (420 + i*65)) &&
           (yPosition >= (55 + j*65)) && (yPosition <= (110 + j*65))){
               myPort = new Serial(this, "COM" + (j*10 + i), 9600);
               myPort.bufferUntil('\n');
               comSelected = true;
               //println("COM" + (j*10 + i));
           }
      }
    }
  }
  if(result != null){
    if(result.length() > 1 && result.charAt(1) == 'o'){
      if(xPosition >= (width/2 - 60) && xPosition <= (width/2 + 60) &&
         yPosition >= 30 && yPosition <= 60){
           saveAndExit();
         }
    }
    
  }
}