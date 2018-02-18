void soundAnalyse() {

  //--------------------------------------------------------------------------------
  //Perform a forward FFT on the samples in the input buffer. One for each type
  fft.forward(in.mix);
  fftLin.forward(in.mix);
  fftLog.forward(in.mix);

  //--------------------------------------------------------------------------------
  //freqCut makes it possible to select a hz range to analyze in the sketch
  //Uncomment the type of fft analyse you want to use (raw, linea avrage, Logical avrage) see the minim documentation
  // binSize = fftLin.avgSize() - freqCut;
  // binSize = fftLog.avgSize() - freqCut;
  binSize = fft.specSize() - freqCut; // raw signal / full spectrum

  //--------------------------------------------------------------------------------
  //Go through all the bands in the fft analyse. 
  for (int i = 0; i < binSize; i++)
  {

    //--------------------------------------------------------------------------------
    //VLoc is controlling where on the Y-axe the reading sould be placed. 
    vLoc = i*resolution/(binSize);

    //--------------------------------------------------------------------------------
    //Find the amplitude of the index band
    value = (int)Math.round(Math.max(0, 4*20* Math.log10(1000*fft.getBand(int(i/gain)))));

    //--------------------------------------------------------------------------------
    //Uncomment to enable auto tuning/calibrating of the amplitude 
    //store self tuning value
    /*   if (maxValue < value) {
     maxValue = value;
     //  println("max amplitude: " + maxValue);
     }
     */

    //--------------------------------------------------------------------------------
    //create a newvalue for the amplite, which lets the cutOff value decide
    //how much of the background noise we want
    newValue = (int)Math.max(0, (value - map(value, 0, maxValue, cutOff, 0)));

    //--------------------------------------------------------------------------------
    //lots of confusing math that acts as a gradient and then set the color
    r=(50+norm(newValue, 0, maxValue)*255*2);
    g=(50+norm(newValue, 0, maxValue)*norm(newValue, 0, maxValue)*255);
    b=(70+norm(newValue, 0, maxValue)*(-255));
    w=(norm(newValue, 0, maxValue)*norm(newValue, 0, maxValue)*255*2);

    //--------------------------------------------------------------------------------
    //set the last row of pixels in the pixel array to the new reading.
    color col = color(constrain((r+w), 0, 255), constrain((g+w), 0, 255), constrain((b+w), 0, 255)); 
    Pixels[resolution + (((resolution-1)-vLoc)*resolution-1)] = col;
  }
}