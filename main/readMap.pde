import processing.video.*;
import java.awt.*;
import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.*;


float camW = 0;
float camH = 0;

// Rectangle size constraints
int minWidth = 500;
int maxWidth = 1000;
int minHeight = 500;
int maxHeight = 700;

PImage capturedPhoto = null;

Capture cam;
OpenCV opencv;

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
    cam = new Capture(this, 1000, 600, "pipeline:avfvideosrc device-index=0");
    
    
    opencv = new OpenCV(this, 1000, 600);
    //opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    cam.start();
 
  }
}

void drawMap() {
  if (cam.available()){
   //opencv.loadImage(cam);
   cam.read();
  }
  //image(cam, 0, 0);
  opencv.loadImage(cam);
  opencv.gray();
  opencv.threshold(127);
  
  ArrayList<Contour> contours = opencv.findContours();
  
  image(cam, 0, 0);
  
  stroke(0, 255, 0);
  strokeWeight(2);
  noFill();
  for (Contour contour : contours) {
    // Get bounding rectangle
    Rectangle rect = contour.getBoundingBox();
    
    // Check if size matches constraints
    if (rect.width >= minWidth && rect.width <= maxWidth &&
        rect.height >= minHeight && rect.height <= maxHeight) {
      
      // Draw detected rectangle
      stroke(0, 255, 0);
      strokeWeight(3);
      rect(width/2, height/2, rect.width, rect.height);
      
      // Draw text with dimensions
      fill(0, 255, 0);
      textSize(12);
      text("W: " + rect.width + " H: " + rect.height, 
           rect.x, rect.y - 5);
      noFill();
    }
    
 }
  
  // Display constraints info
  fill(255);
  textSize(14);
  text("Size constraints: " + minWidth + "-" + maxWidth + "x" + minHeight + "-" + maxHeight, 10, 20);
 
  //button 
  rect(width-150, height-80, 100, 50);
  fill(0);
  text("Capture", width-150, height-80);
 
}

void mapKeyPressed() {
  if (key == '+') {
    minWidth += 10;
    minHeight += 10;
  }
  if (key == '-') {
    minWidth = max(10, minWidth - 10);
    minHeight = max(10, minHeight - 10);
  }
}


void mapMousePressed() {
  if (mouseX > width-200 && mouseX < width -50 &&
      mouseY > height-105 && mouseY < -55) {
      }
      capturePhoto();
}

void capturePhoto() {
  PImage fullPhoto = cam.get();
  
  // Resize to desired size (e.g., 640x480)
  int captureWidth = 640;
  int captureHeight = 480;
  capturedPhoto = createImage(captureWidth, captureHeight, RGB);
  capturedPhoto.copy(fullPhoto, 0, 0, fullPhoto.width, fullPhoto.height,
                     0, 0, captureWidth, captureHeight);
  
  println("Photo captured at size: " + captureWidth + "x" + captureHeight);
  currentScene = 4; 
}
