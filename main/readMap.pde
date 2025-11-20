import processing.video.*;
import processing.core.PImage;

float camW = 0;
float camH = 0;

Capture cam;
boolean mapCameraInitialized = false;


// Initialize the map camera when the map scene becomes active.
void initMapCamera() {
  if (mapCameraInitialized) return;
  camW = width;
  camH = height;

  rectMode(CENTER);
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    // do not exit(); let the app continue without camera
    mapCameraInitialized = true;
    return;
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam = new Capture(this, width, height, "pipeline:avfvideosrc device-index=0", 30);
    cam.start();
    mapCameraInitialized = true;
  }
}

void drawMap() {
  background(0);
  if (mapCameraInitialized && cam != null) {
    if (cam.available() == true) {
      cam.read();
    }
    // Draw the camera feed
    pushMatrix();
    translate(width/2, height/2);
    scale(-1, 1); // Mirror the image for a more natural webcam effect
    imageMode(CENTER);
    image(cam, 0, 0, camW, camH);
    popMatrix();
  } else {
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Camera not available", width/2, height/2);
  }

  
}

void recognizeObjectsInMap() {
  // Recognize pond
  if (cam != null) {
    // Process the camera feed to recognize the pond
    // This is a placeholder for the actual recognition logic
    color pondColor = color(0, 0, 255); // Example: looking for blue color
    color parkColor = color(0, 255, 0); // Example: looking for green color
    color bridgeColor = color(139, 69, 19); // Example: looking for brown color
    color riverColor = color(0, 191, 255); // Example: looking for deep sky blue color
    color schoolColor = color(255, 255, 0); // Example: looking for yellow color
    color theaterColor = color(255, 74, 14); // Example: looking for magenta color


    cam.loadPixels();
    color currentPixel;
    for (int i = 0; i < cam.pixels.length; i++) {
      currentPixel = cam.pixels[i];
      // Dummy loop for processing pixels
      // Use a tolerance-based color comparison instead of exact equality
      float tol = 60; // Euclidean tolerance in RGB space (xax0-441)
      if (colorWithinRange(currentPixel, pondColor, tol)) {
        println("Pond recognized!");
      } else if (colorWithinRange(currentPixel, parkColor, tol)) {
        println("Park recognized!");
      } else if (colorWithinRange(currentPixel, bridgeColor, tol)) {
        println("Bridge recognized!");
      } else if (colorWithinRange(currentPixel, riverColor, tol)) {
        println("River recognized!");
      } else if (colorWithinRange(currentPixel, schoolColor, tol)) {
        println("School recognized!");
      } else if (colorWithinRange(currentPixel, theaterColor, tol)) {
        println("Theater recognized!");
      }
    }

  }
}

// Helper: return true if two colors are within `tol` distance in RGB space
boolean colorWithinRange(color a, color b, float tol) {
  float dr = red(a) - red(b);
  float dg = green(a) - green(b);
  float db = blue(a) - blue(b);
  float dist = sqrt(dr*dr + dg*dg + db*db);
  return dist <= tol;
}

// Alternative helper using HSB hue distance (useful when lighting varies)
boolean hueWithinRange(color a, color b, float hueTol) {
  // Save current mode and switch to HSB for reading hue
  colorMode(HSB, 360, 100, 100);
  float ha = hue(a);
  float hb = hue(b);
  float dh = abs(ha - hb);
  if (dh > 180) dh = 360 - dh; // wrap-around
  colorMode(RGB, 255);
  return dh <= hueTol;
}