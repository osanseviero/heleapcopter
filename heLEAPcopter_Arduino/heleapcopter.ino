int elevation,
      roll,
      pitch,
      yaw,
      serialValues[5],
      count;
const short elevationPin = 3, //Output Pins
            rollPin = 9,
            pitchPin = 10,
            yawPin = 11;


void setup() {
  Serial.begin(9600);
  pinMode(elevationPin, OUTPUT);
  pinMode(rollPin,OUTPUT);
  pinMode(pitchPin,OUTPUT);
  pinMode(yawPin, OUTPUT);
}


void loop() {
  
  //Checks the buffer until it finds a '@', because after it, comes the first value
  while(Serial.read() != '@') {}
  if (Serial.available() >= 0) { //Verify if there is something in the buffer
    count = 0;
    while(count < 5){ //Save at one time the 5 values sent by the Leap Motion
      if(Serial.peek() >= 0){ //Verify the incoming data
        serialValues[count++] = Serial.read();
      }
    }
  }
    
  //Default values if no hands detected by the Leap Motion
  if(serialValues[4] == 0) {
    analogWrite(rollPin, 128);
    analogWrite(pitchPin, 128);
    analogWrite(yawPin, 128);
    for(short i = serialValues[0]; i > 0; i--) {
      analogWrite(elevationPin, i);
    }
  }
  
  else {
    
    //Map every value read before to eliminate noise
    for(short i = 0; i < 4; i++) {
      serialValues[i] = mapValue(i);
    }
    
    //Sends the data to the controller
    sendValue(elevation,0,elevationPin);
    sendValue(roll,1,rollPin);
    sendValue(pitch,2,pitchPin);
    sendValue(yaw,3,yawPin);
    
  }
}


int mapValue(short index){
  int value = map(serialValues[index],0,255,0,10);
  return value;
}


void sendValue(int value, short index, short pin) {
  value = map(serialValues[index], 0, 10, 0, 255);
  if(value > 255) {value = 255;}
  if (value < 0) {value = 0;}
  
  analogWrite(pin, value);
}


