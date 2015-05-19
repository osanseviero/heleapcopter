import processing.serial.*;
import de.voidplus.leapmotion.*;

Serial mySerial;
LeapMotion leap;
int elevation,
      roll,
      pitch,
      yaw,
      hand_inView;
float hand_height,
      hand_roll,
      hand_pitch,
      hand_yaw;
boolean hand_is_left, 
        hand_is_right;

void setup(){
  size(800, 500, P3D);
  background(255);
  hand_height = 400;
  
  //Initialize Serial
  println(Serial.list());
  mySerial = new Serial(this, Serial.list()[2], 9600);
  mySerial.bufferUntil('\n');
  
  //Initialize Leap
  leap = new LeapMotion(this);
}

void sendData(){
  mySerial.write('@');
  mySerial.write(elevation);
  mySerial.write(roll);
  mySerial.write(pitch);
  mySerial.write(yaw);
  mySerial.write(hand_inView);
  delay(5);
}

void getData(){
  for (Hand hand : leap.getHands ()) {
    hand_inView       = 1;
    hand_height      = hand.getPosition().y;
    hand_roll        = hand.getRoll();
    hand_pitch       = hand.getPitch();
    hand_yaw         = hand.getYaw();
    hand_is_left     = hand.isLeft();
    hand_is_right    = hand.isRight();
    
    if(hand_height > 400) {hand_height = 400;}
    if(hand_height < 0) {hand_height = 0;}
    if(hand_roll > 40) {hand_roll = 40;}
    if(hand_roll < -40) {hand_roll = -40;}
    if(hand_pitch > 40) {hand_pitch = 40;}
    if(hand_pitch < -40) {hand_pitch = -40;}
    if(hand_yaw > 40) {hand_yaw = 40;}
    if(hand_yaw < -40) {hand_yaw = -40;}
    
    //Valores variables
    elevation = (int)map(hand_height,  400, 0, 0,255);
    roll      = (int)map(hand_roll,    40,-40, 0,255);
    pitch     = (int)map(hand_pitch,  -40, 40, 0,255);
    yaw       = (int)map(hand_yaw,     40,-40, 255,0);
        
    println("Roll:   ", hand_roll);
    println("Pitch:  ", hand_pitch);
    println("Height: ", hand_height);
    println("Yaw:    ", hand_yaw);

    //hand.draw();
  }
  
  textSize(15);
  text("Elevation:  " + elevation, 10, 20);
  text("Roll:          " + roll, 10, 40);
  text("Pitch:        " + pitch, 10, 60);
  text("Yaw:          " + yaw, 10, 80);
}

void drawPlane(){
  fill(50,50,50,180);
  strokeWeight(2);
  stroke(0);
  translate(400,hand_height,0);
  rotateX(-(hand_roll/80)-PI/2);
  rotateY(-(hand_pitch/60)-PI);
  rotateZ(hand_yaw/50);
  
  rectMode(CENTER);
  rect(0,0,300,300);
}

void drawLines(float pitch){
  strokeWeight(3);
  translate(400,250,155);
  rotateZ((hand_pitch/60)-PI);
  line(40,0,0,10,0,0);
  line(10,0,0,0,10,0);
  line(0,10,0,-10,0,0);
  line(-10,0,0,-40,0,0);
  rotateZ(-((hand_pitch/60)-PI));
  translate(-400,-250,-155);
}

void draw(){
  background(255);
  int fps = leap.getFrameRate();
  
  hand_inView = 0;
  getData();
  sendData();

  if (hand_inView == 0){
    if(hand_height < 400) {hand_height+=2;}
    if(hand_roll <= 40 && hand_roll > 0) {--hand_roll;}
    if(hand_roll >= -40 && hand_roll < 0) {++hand_roll;}
    if(hand_pitch <= 40 && hand_pitch > 0) {--hand_pitch;}
    if(hand_pitch >= -40 && hand_pitch < 0) {++hand_pitch;}
    if(hand_yaw <= 40 && hand_yaw > 0) {--hand_yaw;}
    if(hand_yaw >= -40 && hand_yaw < 0) {++hand_yaw;}
    elevation = (int)map(hand_height,  400, 0, 0,255);
    roll = 128;
    pitch = 128;
    yaw = 128;
  }

  //height line
  stroke(0);
  strokeWeight(2);
  line(750,50,-1,750,450,-1);
  
  //height slider
  fill(255,0,0,150);
  strokeWeight(0);
  translate(750,(hand_height*.75)+70,0);
  rectMode(CENTER);
  rect(0,0,50,25);
  translate(-750,-((hand_height*.75)+70),0);

  //Horizontal Line
  stroke(180);
  strokeWeight(2);
  line(150,250,155,650,250,155);
  
  //Pitch line
  stroke(0);
  drawLines(hand_pitch);

  //Plane
  drawPlane();
}



















