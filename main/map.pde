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
    cam = new Capture(this, 200, 140, "pipeline:avfvideosrc device-index=1", 30);
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
