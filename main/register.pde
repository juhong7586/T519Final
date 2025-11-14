void drawRegister() {
  background(150, 100, 150);
  
  fill(255);
  textSize(32);
  textAlign(CENTER);
  text("Create Your Character", width/2, 50);
  nameBox.text = "Name: " + playerName;
  nameBox.display();

  
  // Character selection
  textSize(20);
  fill(255);
  text("Choose Character:", 100, 240);
  
  // Three character options (simple shapes)
  for (int i = 0; i < 3; i++) {
    int x = 150 + i * 180;
    int y = 300;
    
    // Highlight selected character
    if (i == selectedCharacter) {
      fill(255, 200, 0);
      stroke(255);
      strokeWeight(3);
    } else {
      fill(200);
      stroke(0);
      strokeWeight(1);
    }
    
    rect(x - 40, y - 40, 80, 80);
    
    // Draw character representations
    fill(0);
    if (i == 0) {
      circle(x, y - 20, 30); // head
      rect(x - 8, y, 16, 30); // body
    } else if (i == 1) {
      rect(x - 15, y - 30, 30, 30); // square head
      circle(x, y + 10, 20); // round body
    } else {
      circle(x, y - 15, 25); // head
      triangle(x - 10, y + 10, x + 10, y + 10, x, y + 25); // body
    }
  }
  
  
  // Confirm button
  stroke(0);
  strokeWeight(1);
  fill(50, 200, 50);
  rect(width/2 - 75, 480, 150, 60);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("START GAME", width/2, 510);
}

void registerMousePressed() {
    if (mouseX > 100 && mouseX < 400 &&
      mouseY > 140 && mouseY < 180) {
    // Focus name input box (no actual text input box, just visual)
    nameBox.focused = true;
    // In a real application, you would handle text input differently
  }else{
    nameBox.focused = false;
  }
  // Character selection
  for (int i = 0; i < 3; i++) {
    int x = 150 + i * 180;
    if (mouseX > x - 40 && mouseX < x + 40 &&
        mouseY > 260 && mouseY < 340) {
      selectedCharacter = i;
    }
  }
  
  // Start game button
  if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
      mouseY > 480 && mouseY < 540) {
    if (playerName.length() > 0) {
      currentScene = 2;
    }
  }
}

void registerKeyPressed() {
  if (key == BACKSPACE) {
    if (playerName.length() > 0) {
      playerName = playerName.substring(0, playerName.length() - 1);
    }
  } else if (key != CODED && playerName.length() < 13) {
    playerName += key;
  }
}