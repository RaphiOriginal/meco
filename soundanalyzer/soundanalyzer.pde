/**
  * This sketch demonstrates how to use an FFT to analyze
  * the audio being generated by an AudioPlayer.
  * <p>
  * FFT stands for Fast Fourier Transform, which is a 
  * method of analyzing audio that allows you to visualize 
  * the frequency content of a signal. You've seen 
  * visualizations like this before in music players 
  * and car stereos.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer jingle;
FFT         fft;
RBG rbg;
RBG rbg2;
RBG rbg3;
RBG rbg4;

void setup()
{
  size(512, 512, P3D);
  background(155);
  
  minim = new Minim(this);
  rbg = new RBG(0,0,225);
  rbg2 = new RBG(0, 255, 255);
  rbg3 = new RBG(122, 255, 122);
  rbg4 = new RBG(255, 255, 0);
  
  
  // specify that we want the audio buffers of the AudioPlayer
  // to be 1024 samples long because our FFT needs to have 
  // a power-of-two buffer size and this is a good size.
  jingle = minim.loadFile("jingle.mp3", 1024);
  
  // loop the file indefinitely
  jingle.loop();
  
  // create an FFT object that has a time-domain buffer 
  // the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be half as large.
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  
}

void draw()
{
  background(155);
  strokeWeight(8);
  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( jingle.mix );
  int size = fft.specSize();
  float highest = 0;
  
  for(int i = 0; i < size; i++){
    float band = fft.getBand(i)*8;
    if(band > highest) highest = band;
  }
  
  strokeWeight(highest * 2);
  stroke(rbg2.r, rbg2.g, rbg2.b);
  line(width, height, width, 0);
  
  strokeWeight(4);
  stroke(rbg3.r, rbg3.g, rbg3.b);
  noFill();
  beginShape();
  curveVertex(0, width);
  int varianceW;
  if(size > width){
    varianceW = size / width;
  } else {
    varianceW = width/size;
  }
  int varianceH;
  if(size > height) {
    varianceH = size/ height;
  } else {
    varianceH = height / size;
  }
  for(int i = 0; i < size; i = i + 15)
  {
    curveVertex(i*varianceW, height - fft.getBand(i)*32 * varianceH);
  }
  curveVertex(width, height);
  endShape();
  for(int i = 0; i < size; i++){
    float band = fft.getBand(i)*8;
    strokeWeight(8);
    stroke(rbg.r, rbg.g, rbg.b);
    ellipse(mouseX,mouseY, band, band);
    if(band > highest) highest = band;
  }
}

class RBG{
  int r;
  int g;
  int b;
  public RBG(int r, int g, int b){
    this.r = r;
    this.g = g;
    this.b = b;
  }
  void swap(){
    int temp = r;
    r = g;
    g = b;
    b = temp;
  }
}

void mouseClicked(){
  rbg.swap();
  rbg2.swap();
  rbg3.swap();
  rbg4.swap();
}