
void drawIntro() {
  background(100, 150, 200);
  
  fill(255);
  textSize(48);
  textAlign(CENTER);
  text("Welcome to the Game", width/2, 100);
  
  textSize(24);
  text("Click Start to begin", width/2, 200);
  
  // Start button
  fill(50, 200, 50);
  rect(width/2 - 75, 300, 150, 60);
  
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("START", width/2, 330);
}

void introMousePressed() {
  // Check if Start button clicked
  if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
      mouseY > 300 && mouseY < 360) {
    currentScene = 1;
  }
}



