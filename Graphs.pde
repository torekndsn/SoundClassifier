

void drawTimeStamp() {

  // A lot of boring coe to create the interfaces graphs and layout
  //---------------------------------------------------------------------------------
  // Calculating the number of steps and marks we want on the graph
  int bins = 10; 
  int stepsXY = resolution * step / bins; 
  int y;

  //---------------------------------------------------------------------------------
  // Draw graph rulers for time (x-axes)
  stroke(100);
  strokeWeight(0.7);
  fill(100);

  y = graphStartY + resolution * step;
  for (int i = 0; i <= bins; i ++) {
    int x = round(((graphStartX) + i * stepsXY));
    line(x, y+10, x, y+15);

    //calculating the time it takes for one row of pixels to travel across the canvas
    float time_ = (((float)resolution/((float)frameRate_*speed)) / bins * i);
    String timer = nf(time_, 1, 2);
    text(timer, x, y+25);
  }

  fill(50, 50, 70);
  text("time (sec)", width/2, y + 50);

  //---------------------------------------------------------------------------------
  // Draw graph rulers for frequencies (y-axes)
  stroke(100);
  fill(100);
  for (int i = 0; i <= bins; i++) {

    y = round(( height - (height-(graphStartY+resolution*step)) - (i * stepsXY)));
    line(graphStartX-10, y, graphStartX-15, y);

    String freq = str(round(fft.indexToFreq(int((binSize/bins)*i))));
    text(freq, graphStartX-35, y);
  }

  fill(50, 50, 70);
  text("freq (hz)", margin*2-10, height/2);

  //---------------------------------------------------------------------------------
  // Draw graph for amplitude
  r=(50+norm(newValue, 0, maxValue)*255*2);
  g=(50+norm(newValue, 0, maxValue)*norm(newValue, 0, maxValue)*255);
  b=(70+norm(newValue, 0, maxValue)*(-255));
  w=(norm(newValue, 0, maxValue)*norm(newValue, 0, maxValue)*255*2);

  noStroke();
  float r_, g_, b_, w_;
  int ampX = (graphStartX+resolution*step) + 10;
  ;
  int ampY;
  for (int vLoc = 0; vLoc < resolution; vLoc++) {

    r_=(50+norm(vLoc, 0, resolution)*255*2);
    g_=(50+norm(vLoc, 0, resolution)*norm(vLoc, 0, resolution)*255);
    b_=(70+norm(vLoc, 0, resolution)*(-255));
    w_=(norm(vLoc, 0, resolution)*norm(vLoc, 0, resolution)*255*2);

    fill(constrain((r_+w_), 0, 255), constrain((g_+w_), 0, 255), constrain((b_+w_), 0, 255));
    ampY = round(( height - (height-(graphStartY+resolution*step-step)))- (vLoc * step));
    rect(ampX, ampY, margin, step);
  } 
  fill(50, 50, 70);
  text("Amplitude", width-margin*2, height/2);

  stroke(100);
  fill(100);
  //line(ampX + margin*2.1, graphStartY, ampX + margin*2.2, graphStartY);
  text(maxValue+" Amp", ampX + margin*2.2, graphStartY);
  text("0 Amp", ampX + margin*2.2, height - (height-(graphStartY+resolution*step)));
  text("inputs to wek: " + Pixels.length, graphStartX + margin*15, margin*1, 5);
}