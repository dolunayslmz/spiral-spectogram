import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

float r = 350;
float theta = 0;
float speed = 0.037; 
float shrink = 0.0115; 

void setup() {
  size(1000, 1000);
  background(10);
  minim = new Minim(this);
  song = minim.loadFile("osuperman.mp3", 1024);
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.logAverages(22, 3); 
  noFill();
  smooth();
}
void draw() {
  if (!song.isPlaying() || r <= 0) {
    saveFrame("osuperman_optimized.png");
    noLoop();
    return;
  }
  translate(width/2, height/2);
  fft.forward(song.mix);
  // i=0: Bas,i=1: Vokal, i=2: Ha!, i=3: high freq
  for (int i = 0; i < 4; i++) {
    float amp;
    color dotColor;
    if (i == 0) { //
      amp = fft.calcAvg(20,   140);
      dotColor = color(3, 76, 166); // blue
    } else if (i == 1) { // Vokal
      amp = fft.calcAvg(141,  230);
      dotColor = color(204, 2, 2); // red
    } else if (i == 2) { // Vokal  Ha!
      amp = fft.calcAvg(231,  315);
      dotColor = color(161, 219, 0); // green
    } else { // Tiz 
      amp = fft.calcAvg(316 , 8000);
      dotColor = color(255, 159, 28); // pink
    }
    // draw
    float alpha = map(amp, 0, 15, 10, 255);
    float size = map(amp, 0, 15, 1.25, 3);
    stroke(dotColor, alpha);
    strokeWeight(size);
    // the angle is changing accoridng the freq bands
    float x = r * cos(theta + i * 0.05);
    float y = r * sin(theta + i * 0.05);
    point(x, y);
  }
  // Spiral movement
  theta += speed;
  r -= shrink;
}
void stop() {
  song.close();
  minim.stop();
  super.stop();
}
