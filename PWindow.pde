
//This Pwindow is dedicated to create sketches using the wekinator classification
//seperated from the spectrogram tool. 

class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  //---------------------------------------------------------------------------------
  // Set sketch variables 
  color red = color(255, 0, 0);
  color yellow = color(200, 200, 0);

  //---------------------------------------------------------------------------------
  // Set the window size here
  void settings() {
    size(500, 500);
  }

  //---------------------------------------------------------------------------------
  // Set seutp properties
  void setup() {
    background(150);
    textAlign(CENTER, CENTER);
  }

  //---------------------------------------------------------------------------------
  // Start of draw
  void draw() {

    switch(output) {
    case 1:
      background(150);
      break;

    case 2:
      background(red);
      break;

    case 3: 
      background(yellow);
      break;

    case 4: 
      break;

    case 5:
      break;
    }
    
    text("output " + output, width/2, height/2);
  }
}