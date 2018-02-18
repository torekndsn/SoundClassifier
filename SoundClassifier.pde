import ddf.minim.analysis.*;
import ddf.minim.*;
import oscP5.*;
import netP5.*;
import controlP5.*;

PWindow win;
ControlP5 cp5;

Minim minim;
AudioInput in;
FFT fft, fftLin, fftLog; // not all are used at ones,
//but I've tried out different fft techniques provided by minim

OscP5 oscP5;
NetAddress dest;

///////////////////////////////////////////////////////////////////////////
//                    I N I T    V A R I A B L E S                       //

//--------------------------------------------------------------------------------
//FFT variables
int value;
int newValue = 1;
int maxValue = 1; 
int vLoc = 0;
int binSize; 

//--------------------------------------------------------------------------------
//cutoff's and interface controls
int freqCut = 0;
int cutOff=400;
int speed = 5; 
float gain = 1.0;

//--------------------------------------------------------------------------------
//Set the number of inputs to wekinator here. 
//This also controls to resolution of the plotter by keeping a 1x1 ratio
// So, 900 inputs returns a resolutin of sqrt(900) = 30 * 30 px. 2500 inputs = resolution of 50 * 50 px
int inputsToWek = 900; 

//--------------------------------------------------------------------------------
//layout properties
float r, g, b, w;
int step;
int resolution = round(sqrt(inputsToWek)); 
PFont f;
int margin, graphStartX, graphStartY;

//--------------------------------------------------------------------------------
//Pixel array
color[] Pixels = new int[resolution*resolution];

//--------------------------------------------------------------------------------
// FrameRate also controls the speed, and the variable is used to calculate the time graph. 
// sp change frameRate here
int frameRate_ = 20;

//--------------------------------------------------------------------------------
//Smoothing variables for reducing wrong classification peaks.
int output;
int sampleSize = 4;
int[] classSample = new int [sampleSize];  
int index = 0; 
int realOutput, oldOutput = 0;

//                  E N D   O F   V A R I A B L E S                      //
///////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////
//                     S T A R T   O F   S E T U P                       //

public void settings() {
  size(700, 600);
}

void setup() {
  // size(700, 600);
  win = new PWindow();
  background (180);
  frameRate(frameRate_);

  //Setup OSC connection to wekinator
  //--------------------------------------------------------------------------------
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);

  //Minim setup for audio
  //--------------------------------------------------------------------------------
  minim = new Minim(this);                   
  in = minim.getLineIn(Minim.STEREO, 2048);  //uncomment to use Line In, live audio

  //start FFTing in three modes: full spectrum, linear avrage and logical avrage
  // But only one is activitly used at a time. See the FFT tab to select which one.
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.HAMMING);

  fftLin = new FFT(in.bufferSize(), in.sampleRate());
  fftLin.window(FFT.HAMMING);
  fftLin.linAverages( 300 );

  fftLog = new FFT(in.bufferSize(), in.sampleRate());
  fftLog.window(FFT.HAMMING);
  fftLog.logAverages( 22, 60 );

  //Layout properties
  //--------------------------------------------------------------------------------
  margin = width / 24;  
  step = round((width-margin*10) / resolution);
  graphStartX = margin * 5;
  graphStartY = margin * 4;

  f = createFont("helvetica", 12);
  textFont(f);
  textAlign(CENTER, CENTER);

  //CP5 Controls
  //--------------------------------------------------------------------------------
  cp5 = new ControlP5(this);
  sliderSetup();
}

//                       E N D   O F   S E T U P                         //
///////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////
//                      S T A R T   O F   D R A W                        //
void draw()
{
  background (180);

  //--------------------------------------------------------------------------------
  //Start the sound analyse
  soundAnalyse();

  //--------------------------------------------------------------------------------
  //Move the pixel array one step, to evolve the "movie".

  for (int r = 0; r < resolution; r++) {
    for (int p = 0; p < speed; p++) {  //change p to make it go faster
      arrayCopy(Pixels, resolution * r + 1, Pixels, resolution * r, resolution-1);
    }
  }

  //--------------------------------------------------------------------------------
  //Draw the graphics and graphs
  fill(180);
  noStroke();
  drawTimeStamp();

  //--------------------------------------------------------------------------------
  //Draw the spectrogram onto the screen, scaled by the calculated step size (scaling factor)

  for (int x = 0; x < resolution; x++) {
    for (int y = 0; y < resolution; y++) {
      int loc = x + (y * resolution);
      color col = Pixels[loc];
      fill(col);
      noStroke();
      rect(graphStartX+(step*x), graphStartY+(step*y), step, step);
    }
  }

  //--------------------------------------------------------------------------------
  //Send pixels to wekinator
  if (frameCount % 2 == 0) {
    sendOsc(Pixels);
  }
}
//                       E N D   O F   D R A W                           //
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
//                S T A R T   O F   F U N C T I O N S                    //


//--------------------------------------------------------------------------------
//Just a way to stop minim properly on sketch end
void stop()
{
  in.close();
  minim.stop();
  super.stop();
}

//--------------------------------------------------------------------------------
//Send the spectogram array as a msg to wekinator
void sendOsc(color[] px) {
  OscMessage msg = new OscMessage("/wek/inputs");
  // msg.add(px);
  for (int i = 0; i < px.length; i++) {
    msg.add(float(px[i]));
  }
  oscP5.send(msg, dest);
}

//--------------------------------------------------------------------------------
//Receive inputs from wekinator
void oscEvent(OscMessage theOscMessage) {
  println("print something");
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    output = int(theOscMessage.get(0).floatValue());
    
    //smooth incoming inputs from wekinator. if response time is to slow, increase frameRate,
    //or lower the sampleSize variable
    output = avrOutput(output);
  }
}


//--------------------------------------------------------------------------------
//Smoothing algortigm to smooth incoming wek values.
int avrOutput(int output_) {
  boolean match = true;
  classSample = splice(classSample, output_, 0);
  classSample = subset(classSample, 0, sampleSize); 
  println(classSample);

  int first = classSample[0];
  for (int i = 1; i < classSample.length; i++) {
    if (classSample[i] != first) match = false;
  }

  if (match) {
    realOutput = output_; 
    oldOutput = output_;
  } else realOutput = oldOutput;

  return realOutput;
}

//--------------------------------------------------------------------------------
//SEND OUTPUT NAMES BACK TO WEKINATOR
void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutPutNames");
  msg.add("gesture");
  oscP5.send(msg, dest);
}