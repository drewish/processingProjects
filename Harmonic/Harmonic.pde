/*
Trying out some music theory stuff I'd read about at:
  http://www.skytopia.com/project/scale.html
  
Generating a full chromatic scale for a range of notes and
testing out how harmoics sound.
*/

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;

int harmonics = 8;
int active = 0;
// Using the MIDI note numbering: http://tomscarff.110mb.com/midi_analyser/midi_note_frequency.htm
int min_note = 12;
int max_note = 96;
float hslice, wslice;
float lastFreq;

void setup() {
  size(512, 768);

  hslice = height / (float) (max_note - min_note);
  wslice = width / (float) harmonics;

  minim = new Minim(this);

  // get a stereo line out with a sample buffer of 512 samples
  out = minim.getLineOut(Minim.MONO);

  int freq = 0;
  float amp = 1;
  for (int i = 0; i < harmonics; i++) {
    out.addSignal(new SineWave(freq, amp, 44100));
    amp /= 2;
  }

  noStroke();
}

void draw() {
  background(51); 

  active = (int) map(mouseX/(float) width, 0, 1, 0, harmonics) + 1;
  for (int i = 0; i < active; i++) {
    out.enableSignal(i);
  }
  for (int i = active; i < harmonics; i++) {
    out.disableSignal(i);
  }

  // Based of MIDI's note number to frequency formula.
  int note = (int) map(mouseY/(float) height, 0, 1, min_note, max_note) + 1;
  float freq = 440 * pow(2, (note - 69) / 12.0);
  // Don't bother touching the frequency if it's inside a rounding error.
  if (abs(freq - lastFreq) > 0.1) {
    lastFreq = freq;
    for (int i = 0; i < harmonics; i++) {
      ((Oscillator) out.getSignal(i)).setFreq(freq * i);
    }
  }

  // Draw the harmonic and note feedback.
  rectMode(CORNER);
  fill(255, 40);
  rect(0, 0, active * wslice, height);
  rect(0, 0, width, (note - min_note) * hslice);

  // Draw some cool boxes taken from example code.
  rectMode(CENTER);
  fill(255, 204);
  rect(mouseX, height/2, mouseY/2+10, mouseY/2+10);
  int inverseX = width-mouseX;
  int inverseY = height-mouseY;
  rect(inverseX, height/2, (inverseY/2)+10, (inverseY/2)+10);
}

// here we provide a way to mute out
// because, let's face it, it's not a very pleasant sound
void keyPressed() {
  if ( key == 'm' ) {
    if ( out.isMuted() ) {
      out.unmute();
    }
    else {
      out.mute();
    }
  }
}

void stop() {
  out.mute();
  out.close();
  minim.stop();

  super.stop();
}

