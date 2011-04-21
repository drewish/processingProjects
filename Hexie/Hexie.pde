import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.effects.*;
import processing.opengl.*;

Minim minim;
AudioOutput out;
Hex hexes[];
float SQRT_3_2 = sqrt(3) / 2;
int sideLength = 50;
int active[] = new int[3];


void setup() {
  colorMode(HSB, 12);
  size(1024, 768, OPENGL);
  hint(ENABLE_OPENGL_4X_SMOOTH);
  hint(ENABLE_NATIVE_FONTS);
  
  minim = new Minim(this);
  out = minim.getLineOut(Minim.MONO);

  PFont font = createFont("Helvetica", 14);
  textFont(font);
  textAlign(CENTER);

  int[][] coords = new int[][] {
    {0, 0, 0}, 
    {2, -1, -1},
    {1, 1, -2},
    {-1, 0, 1},
    {1, -1, 0},
    {0, 1, -1},
    {2, 0, -2},
    {0, -1, 1},
    {-1, 1, 0},
    {1, 0, -1},
    {3, -1, -2},
    {-2, 1, 1},
  }; 
  hexes = new Hex[coords.length];
  for (int i = 0, len = coords.length; i < len; i++) {
    hexes[i] = new Hex(coords[i][0], coords[i][1], coords[i][2], i);
  }

  noStroke();
}

void draw() {
  background(51);


  textAlign(LEFT);
  float rgb[] = rgb_from_xy(mouseX - width/2, mouseY - height/2);
  fill(0, 1, 12);
  int rr = round(rgb[0]),
      rg = round(rgb[1]),
      rb = round(rgb[2]);
  text("x: " + mouseX
    + "\ny: " + mouseY
    + "\n\nr: " + rr
    + "\ng:" + rg
    + "\nb:" + rb
    + "\n\nr: " + rgb[0]
    + "\ng:" + rgb[1]
    + "\nb:" + rgb[2]
    , -300, -300);
  
   
  if (rr + rg + rb == 0) {
    active[0] = rr;
    active[1] = rg;
    active[2] = rb;
  }
  
  // Change the origin to be the center of the screen and the y axis so it points up.
  translate(width / 2, height / 2);

  textAlign(CENTER);
  for (int i = 0, len = hexes.length; i < len; i++) {
    Hex h = hexes[i];
    h.hover = active[0] == h.r && active[1] == h.g && active[2] == h.b;
    if (h.hover && mousePressed && (mouseButton == LEFT)) {
      h.setActive(!h.isActive());
    }
    h.draw();
  }
}

void stop() {
  out.mute();
  out.close();
  minim.stop();
  super.stop();
}

float[] rgb_from_xy(int x, int y) {
  float r = x / (sideLength * 1.5);
  float g = -(x/3 - sqrt(3)/3*y) / sideLength;
  float b = -(x/3 + sqrt(3)/3*y) / sideLength;
  //float b = - r - g;
  
//println("y:" + y); println("b: " + b);
  return new float[] {r, g, b};
}

// Convert between our RGB coordinate system and XY.
float[] xy_from_rgb(float r, float g, float b) {
  if (abs(r + g + b) > 0.1) {
    throw new IllegalArgumentException();
  }
//    raise ArgumentError, "r + g + b != 0" unless r + b + g == 0
/*
  // Figure out the slope of 210 and 330 degree lines. On the unit circle that
  // equals: (-sqrt(3)/2, -1/2) and (sqrt(3)/2, -1/2).
  float rx = r * SQRT_3_2;
  float ry = r * -0.5;
  float gx = g * -SQRT_3_2;
  float gy = g * -0.5;
  float bx = b * 0;
  float by = b * 1;
*/
  // Figure out the slope of 120 and 240 degree lines. On the unit circle that
  // equals: (-1/2, sqrt(3)/2) and (-1/2, -sqrt(3)/2).
  float rx = r * 1;
  float ry = r * 0;
  float gx = g * -0.5;
  float gy = g * SQRT_3_2;
  float bx = b * -0.5;
  float by = b * -SQRT_3_2;

  return new float[] {sideLength * (rx + gx + bx), sideLength * (ry + gy + by)};
}


