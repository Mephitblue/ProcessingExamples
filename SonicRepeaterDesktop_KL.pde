//The MIT License (MIT) - See Licence.txt for details
// Sonic repeat - Keith Lamond 2015
// Based off of SonicPainter by:
//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies
 
 
Maxim maxim;
AudioPlayer player;
AudioPlayer player2;

// for drum loops
AudioPlayer playerLoop1;
AudioPlayer playerLoop2;
AudioPlayer playerLoop3;
AudioPlayer playerLoop4;

//for bass notes
AudioPlayer bassA1;
AudioPlayer bassB1;
AudioPlayer bassC1;
AudioPlayer bassD1;
AudioPlayer bassE1;
AudioPlayer bassF1;
AudioPlayer bassG1;
AudioPlayer bassA2;
 
 
//global variables for settings
int gutter = 30;
int margin = 15;
int buttonWidth = 80;
int buttonHeight = 40;
int center = width/2;
int botConsoleHeight = 72;
 
//Loop button placement
float kickButtonX = 0;
float hiHatButtonX = 0;
float snareButtonX = 0;
float tomButtonX = 0;
float loopButtonY = 0;
 
//loop on toggle setting;
boolean kickOn = false;
boolean hiHatOn = false;
boolean snareOn = false;
boolean tomOn = false;
 
int [] zone = new int[8];
int selectedZone = 0;

//variables to set repeat after 120 frames
float [] lastX = new float[120];
float [] lastY = new float[120];
float [] lastPX = new float[120];
float [] lastPY = new float[120];
float [] lastLineWidth = new float[120];
float [] lastZone = new float[120];
int frameCounter = 0;

 
void setup()
{
  size(640, 960);
  maxim = new Maxim(this);
  player = maxim.loadFile("looperman-l-0671112-0087166-danke-rain-city.wav");
  player.setLooping(true);

  //loading drum loops
  playerLoop1 = maxim.loadFile("loop1.wav");
  playerLoop1.setLooping(true);
  playerLoop1.volume(1.0);
  playerLoop2 = maxim.loadFile("loop2.wav");
  playerLoop2.volume(1.0);
  playerLoop2.setLooping(true);
  playerLoop3 = maxim.loadFile("kick.wav");
  playerLoop3.setLooping(true);
  playerLoop3.volume(1.0);
  playerLoop4 = maxim.loadFile("loop4.wav");
  playerLoop4.setLooping(true);
  playerLoop4.volume(1.0);
  
 // load bass notes
  bassA1 = maxim.loadFile("95662__corsica-s__cleared-for-takeoff.wav");
  bassA1.setLooping(false);
  bassB1 = maxim.loadFile("95678__corsica-s__position-and-hold.wav");
  bassB1.setLooping(false);
  bassC1 = maxim.loadFile("95674__corsica-s__ident.wav");
  bassC1.setLooping(false);
  bassD1 = maxim.loadFile("95672__corsica-s__frequency-change-approved.wav");
  bassD1.setLooping(false);
  bassE1 = maxim.loadFile("95670__corsica-s__expedite.wav");
  bassE1.setLooping(false);
  bassF1 = maxim.loadFile("95679__corsica-s__proceed-direct.wav");
  bassF1.setLooping(false);
  bassG1 = maxim.loadFile("95681__corsica-s__watch-for-traffic.wav");
  bassG1.setLooping(false);
  bassA2 = maxim.loadFile("95668__corsica-s__cleared-touch-and-go.wav");
  bassA2.setLooping(false);  
  
  background(0);
  rectMode(CENTER);
  ellipseMode(CENTER);
  frameRate(120);
  player.play();
  //noStroke();
 
  LoopButtons();
  setZones();
 
}
 
void draw()
{
  if(lastX[frameCounter] != 0) {  player.play(); }

  noStroke();
  fill(0, 2);
  rect(width/2, height/2 - botConsoleHeight/2, width - gutter * 2, height - botConsoleHeight);
  drawZoneLines();
  float red = map(lastX[frameCounter], 0, width, 0, 255);
  float blue = map(lastY[frameCounter], 0, width, 0, 255);
  float green = dist(lastX[frameCounter],lastY[frameCounter],width/2,height/2);
  stroke(red, green, blue, 255);
  strokeWeight(lastLineWidth[frameCounter]);
  
  brush7(lastPX[frameCounter], lastPY[frameCounter], lastX[frameCounter], lastY[frameCounter], lastLineWidth[frameCounter]);
 
  player.setFilter((float) lastY[frameCounter]/height*5000,lastX[frameCounter] / width);

  //Set repeat frames to zero so they are not repeated again
 /* lastX[frameCounter] = 0;
  lastY[frameCounter] = 0;
  lastPX[frameCounter] = 0;
  lastPY[frameCounter] = 0;
  lastLineWidth[frameCounter] = 0; */
  frameCounter++;

  if (frameCounter >=120) { frameCounter = 0; }
}
 
void mouseDragged()
{
  if(mouseY < height - botConsoleHeight - 5) {  
    //player.play();
   //player2.play();
    float red = map(mouseX, 0, width, 0, 255);
    float blue = map(mouseY, 0, width, 0, 255);
    float green = dist(mouseX,mouseY,width/2,height/2);
   
    float speed = dist(pmouseX, pmouseY, mouseX, mouseY);
    float alpha = map(speed, 0, 20, 0, 10);
    //println(alpha);
    float lineWidth = map(speed, 0, 10, 10, 1);
    lineWidth = constrain(lineWidth, 0, 10);
    int posY = mouseY;
    int prevPosY = pmouseY;
    if (posY > height - botConsoleHeight - 5) { posY = posY - botConsoleHeight - 5; }
    if (prevPosY > height - botConsoleHeight - 5) { prevPosY = prevPosY - botConsoleHeight - 5; }
    
    //Record previous so it can be replayed
    lastPX[frameCounter] = pmouseX;
    lastPY[frameCounter] = prevPosY;
    lastX[frameCounter] = mouseX;
    lastY[frameCounter] = mouseY;
    lastLineWidth[frameCounter] = lineWidth;
    noStroke();
    //fill(0, alpha);
    rect(width/2, height/2 - botConsoleHeight/2, width - gutter * 2, height - botConsoleHeight);
    drawZoneLines();
    stroke(red, green, blue, 255);
    strokeWeight(lineWidth);
   
    //rect(mouseX, mouseY, speed, speed);
    //line(pmouseX, prevPosY,mouseX, posY);
    //brush1(mouseX, mouseY,speed, speed,lineWidth);
    //brush2(mouseX, mouseY,speed, speed,lineWidth);
    //brush3(mouseX, mouseY,speed, speed,lineWidth);
    //brush4(pmouseX, pmouseY,mouseX, mouseY,lineWidth);
   
    //brush5(pmouseX, pmouseY,mouseX, mouseY,lineWidth);
    //brush6(mouseX, mouseY,speed, speed,lineWidth);
    brush7(pmouseX, pmouseY,mouseX, mouseY,lineWidth);
   
    player.setFilter((float) mouseY/height*5000,mouseX / width);
    //player2.setFilter((float) mouseY/height*5000,mouseX / width);
   

   // player2.ramp(1.,1000);
    //player2.speed((float) mouseX/width/2);
  }
}


void mousePressed() {
  if(mouseY < height - botConsoleHeight) {
     int zoneSize = (height - botConsoleHeight) / 8;
   if (mouseY <= zoneSize) {
     selectedZone = 8;
     bassA2.play();
   } else if (mouseY <= zoneSize * 2) {
     selectedZone = 7;
     bassG1.play();     
   } else if (mouseY <= zoneSize * 3) {
     selectedZone = 6;
     bassF1.play();
   } else if (mouseY <= zoneSize * 4) {
     selectedZone = 5;
     bassE1.play();
   } else if (mouseY <= zoneSize * 5) {
     selectedZone = 4;
     bassD1.play();
   } else if (mouseY <= zoneSize * 6) {
     selectedZone = 3;
     bassC1.play();
   } else if (mouseY <= zoneSize * 7) {
     selectedZone = 2;
     bassB1.play();     
   } else {
     selectedZone = 1;
     bassA1.play();
   } 
  }
} 


void mouseReleased()
{
  //println("rel");
 // player2.ramp(0.,1000);
 
       
}
 
void LoopButtons() {
  //Set X and Y for loop buttons
  kickButtonX = width/2 - buttonWidth*2 - gutter*1.5 + buttonWidth/2;
  hiHatButtonX = kickButtonX + buttonWidth + gutter;
  snareButtonX = hiHatButtonX + buttonWidth + gutter;
  tomButtonX = snareButtonX + buttonWidth + gutter;
  loopButtonY = height - buttonHeight/2 - margin;
 
  fill(0,0,110);
  stroke(40);
  strokeWeight(2);
  strokeJoin(BEVEL);  
  rect(width/2, height - botConsoleHeight/2, width, botConsoleHeight);
 
  fill(120);
  stroke(40);
  strokeWeight(2);
  strokeJoin(BEVEL);
  float loopX = kickButtonX;
  for (int i = 0; i < 4; i++) {
    rect(loopX, loopButtonY, buttonWidth, buttonHeight);
    fill(255);
    textSize(16);
    switch(i) {
      case 0:
        text("Loop 1", loopX - 22, loopButtonY + 4); 
        break;
      case 1:
        text("Loop 2", loopX - 22, loopButtonY + 4 );      
        break;
      case 2:
         text("Loop 3", loopX - 22, loopButtonY + 4);
        break;
      case 3:
        text("Loop 4", loopX - 22, loopButtonY + 4);     
        break;
      default:
        break;   
    }
    fill(120);
    loopX = loopX + buttonWidth + gutter;
  }
 
}
 
void setZones() {
  //establish height of each zone
  int zoneSize = (height - botConsoleHeight) / 8;
  int zoneShade = 240;
  noStroke();
  for (int i = 0; i < 8; i++) {
    zone[i] = zoneSize * (i+1) - (zoneSize/2);
    fill(0,0,zoneShade - i * 30, 80);
    rect(gutter/2, zone[i], gutter, zoneSize);
    rect(width - gutter/2, zone[i], gutter, zoneSize);
  }
  drawZoneLines();
} 
 
void drawZoneLines(){
  stroke(40);
  strokeWeight(1);
  int zoneSize = (height - botConsoleHeight) / 8;
  for (int i = 0; i < 8; i++) {
    line(0, zone[i] + zoneSize/2, width, zone[i] + zoneSize/2);
  }
}
 
void mouseClicked() {
  stroke(40);
  strokeWeight(2);
  int cueSet = millis() % 200;
 strokeJoin(BEVEL);
  if (mouseY > loopButtonY - buttonHeight/2 && mouseY < loopButtonY + buttonHeight/2) {
    //Check if Kick loop triggered
    if (mouseX > kickButtonX - buttonWidth/2 && mouseX < kickButtonX + buttonWidth/2) {
       kickOn = !kickOn;
       if (kickOn) {
         fill(0, 0, 200, 200);
         playerLoop1.cue(cueSet);
         playerLoop1.play();
         toggleOffLoops(1);
       } else {
         fill(120);
         playerLoop1.stop();
       }
       rect(kickButtonX, loopButtonY, buttonWidth, buttonHeight);     
       fill(255);
       text("Loop 1", kickButtonX - 22, loopButtonY + 4);   
    }
    //check if hihat loop triggered
    if (mouseX > hiHatButtonX - buttonWidth/2 && mouseX < hiHatButtonX + buttonWidth/2) {
       hiHatOn = !hiHatOn;
       if (hiHatOn) {
         fill(0, 0, 200, 200);
         playerLoop2.cue(cueSet);
         playerLoop2.play();
       toggleOffLoops(2);         
       } else {
         fill(120);
         playerLoop2.stop();
       }
       rect(hiHatButtonX, loopButtonY, buttonWidth, buttonHeight);
       fill(255);
       text("Loop 2", hiHatButtonX - 22, loopButtonY + 4);         
     }
     //check if snare loop is triggered
     if (mouseX > snareButtonX - buttonWidth/2 && mouseX < snareButtonX + buttonWidth/2) {
       snareOn = !snareOn;
       if (snareOn) {
         fill(0, 0, 200, 200);
         playerLoop3.cue(cueSet);
         playerLoop3.play();
         toggleOffLoops(3);
       } else {
         fill(120);
         playerLoop3.stop();
       }
       rect(snareButtonX, loopButtonY, buttonWidth, buttonHeight);
       fill(255);
       text("Loop 3", snareButtonX - 22, loopButtonY + 4);       
     }
     //check if tom loop is triggered
     if (mouseX > tomButtonX - buttonWidth/2 && mouseX < tomButtonX + buttonWidth/2) {
       tomOn = !tomOn;
       if (tomOn) {
         fill(0, 0, 200, 200);
         playerLoop4.cue(cueSet);
         playerLoop4.play();
         toggleOffLoops(4);
       } else {
         fill(120);
         playerLoop4.stop();
       }
       rect(tomButtonX, loopButtonY, buttonWidth, buttonHeight); 
       fill(255);
       text("Loop 4", tomButtonX - 22, loopButtonY + 4 );    
     }
  }
}

void toggleOffLoops(int activeLoop) {
  stroke(40);
  strokeWeight(2);
 strokeJoin(BEVEL);

    if (activeLoop != 1) {
      kickOn = !kickOn;   
      fill(120);
      playerLoop1.stop();
       rect(kickButtonX, loopButtonY, buttonWidth, buttonHeight);     
       fill(255);
       text("Loop 1", kickButtonX - 22, loopButtonY + 4);   
    }

    if (activeLoop != 2) {
       hiHatOn = !hiHatOn;
       fill(120);
       playerLoop2.stop();
       rect(hiHatButtonX, loopButtonY, buttonWidth, buttonHeight);
       fill(255);
       text("Loop 2", hiHatButtonX - 22, loopButtonY + 4);         
     }

     if (activeLoop != 3) {
       snareOn = !snareOn;
       fill(120);
       playerLoop3.stop();
       rect(snareButtonX, loopButtonY, buttonWidth, buttonHeight);
       fill(255);
       text("Loop 3", snareButtonX - 22, loopButtonY + 4);       
     }

     if (activeLoop != 4) {
       tomOn = !tomOn;
       fill(120);
       playerLoop4.stop();

       rect(tomButtonX, loopButtonY, buttonWidth, buttonHeight); 
       fill(255);
       text("Loop 4", tomButtonX - 22, loopButtonY + 4 );    
     }
     fill(0, 0, 200, 200);
}
