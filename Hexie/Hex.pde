
class Hex { 
  String[] notes = new String[] {"c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"};
  
  int r, g, b, i;
  float x, y;
  boolean hover = false, active = false;
  int note;
  int harmonics = 6;
  float freq;

  Hex (int r, int g, int b, int i) {  
    this.r = r;
    this.g = g;
    this.b = b;
    this.i = i;
    float[] xy = xy_from_rgb(r, g, b);
    this.x = xy[0];
    this.y = xy[1];
//println("r:" + r + " g: " + g + " b: " + b);
//println("x:" + x + " y: " + y);

    this.note = i + 48;
    this.freq = 440 * pow(2, (note - 69) / 12.0);
    

    float amp = 1;
//    for (int j = 0; j < harmonics; j++) {
      out.addSignal(new SineWave(freq, amp, 44100));
      out.disableSignal(i);
//      amp /= 2;
//    }
  } 
  
  boolean isActive() {
    return active;
  }
  
  void setActive(boolean value) {
    active = value;
    
    if (active) { 
//      for (int i = 0; i < harmonics; i++) {
        out.enableSignal(i);
//      }
    }
    else {
//      for (int i = 0; i < harmonics; i++) {
        out.disableSignal(i);
//      }
    }
  }

  void draw() { 
    pushMatrix();
      translate(x, y);
      pushMatrix();
        scale(sideLength, sideLength);

        int s = 5;
        int l = 12;
        if (hover) {
          l = 8;
        }
        if (active) {
          s = 12;
        }
        fill(i, s, l);

        beginShape();
        vertex(0.5, SQRT_3_2);
        vertex(-0.5, SQRT_3_2);
        vertex(-1, 0);
        vertex(-0.5, -SQRT_3_2);
        vertex(0.5, -SQRT_3_2);
        vertex(1, 0);
        endShape(CLOSE);

      popMatrix();
   
//      fill(0, 12, 12);
//      ellipse(0, 0, 5,5);

      fill(i, 1, 1);
      text(i + " " + notes[i] + "\n" + r + ',' + g + ',' + b, 0, 0); 
    popMatrix();
  } 
}
