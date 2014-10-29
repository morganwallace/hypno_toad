/*
 * Arduino Ball Paint
 * (Arduino Ball, modified 2008)
 * ---------------------- 
 *
 * Draw balls randomly on the screen, size controlled by a device
 * on a serial port.  Press space bar to clear screen, or any 
 * other key to generate fixed-size random balls.
 *
 * Receives an ASCII number over the serial port, 
 * terminated with a carriage return (ascii 13) then newline (10).
 * 
 * This matches what Arduino's " Serial.println(val)" function
 * puts out.
 *
 * Created 25 October 2006
 * copyleft 2006 Tod E. Kurt <tod@todbot.com
 * http://todbot.com/ 
 */
import processing.serial.*;
// Change this to the portname your Arduino board
Serial port;
String buf="";
int cr = 13;  // ASCII return   == 13
int lf = 10;  // ASCII linefeed == 10
void setup() {
  size(500,500);
  frameRate(10);
  smooth();
  background(40,40,40);
  noStroke();

/*
  Run the code once with this print statement to see a list of available serial ports. 
  Make a note of the number next to the port you'd like to use
*/

  println(Serial.list()); 

/*  Once you know the number of the port you want to use Replace the "0" in the code below 
  with the port number. For instance, if you wanted to use port number 4 in the list, then 
  the code should say:   port = new Serial(this, Serial.list()[4], 9600); 
*/


  port = new Serial(this, "/dev/tty.usbmodem1411", 9600); 




}
void draw() {
}
// Initialized the color of circles
int red = int(random(0,255));
int green = int(random(0,255));
int blue = int(random(0,255));

void keyPressed() {
  if(key == ' ') {
    background(40,40,40);  // erase screen
  }
}

//Function that plots the cicrles on predefined spots for eyes and the mouth
//returns the x and y coordinates for the drawballs function
int[] smiley(){
 //define the range of x and y that defines a smiley face
 
 //randomly pick and eye or the smile to draw
 int which=int(random(0,3));
 
 //initialize local versions of x and y as xx and yy
 int xx = 0;
 int yy = 0;
  if (which ==0){//left eye
     xx=width/3;
     yy=height/3;
  } 
  if (which ==1){//right eye
     xx=(2*width)/3;
     yy=height/3;
  }
  if (which ==2){//smile
//    println("smile");
     xx=int(random(width/3,(2*width)/3));
     float q=-(0.002)*pow(float(xx)-(float(width)/2),2)+300;
//     println(q);
     yy=int(q);//((2*height)/3)
//     println(yy);
  }
  int[] coordinates = {xx,yy};
  return coordinates; 
}  
// draw balls
//modified from the original version:
//  - added color variation being passed in
//  - x and y are returned by the smiley function
void drawball(int r, int red, int green, int blue) {
  for (int i=0; i<100; i++ ) {
    fill(red,green,blue);
    int[] smiley_coordinates=smiley();
    int x=smiley_coordinates[0];
    int y=smiley_coordinates[1];
    ellipse(x,y,r,r);
  }

}
// called whenever serial data arrives
void serialEvent(Serial p) {
  int c = port.read();

  if (c != lf && c != cr) {
    buf += char(c);
    
    //Change to a new random color when you stop pressing the FSR
    if (int(buf) == 0) {
        red = int(random(0,255));
        green = int(random(0,255));
        blue = int(random(0,255)); 
    }
  }
  if (c == lf) {
    int val = int(buf);
    if (val!=0){
        println("val="+val);
    }
     
    drawball(val, red, green, blue);

//    
//    println(x);
//    println(y);
//    println(val);
    buf = "";
//    background(40,40,40);  // erase screen
  }
}
