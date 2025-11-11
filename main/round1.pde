

Bag [] bags = new Bag[3];

int selectedBag = -1;

// Drag-and-drop state for words
boolean dragging = false;
String draggingWord = null;
float dragX = 0, dragY = 0;





void drawGame() {
  background(30, 40, 50);
  fill(255);
  textSize(20);
  textAlign(LEFT);
  text("Player:", 30, 40);
  textSize(24);
  text(playerName, 110, 40);

  textSize(20);
  text("Selected character:", 30, 80);
  // draw the selected character bigger at a fixed position
  drawSelectedCharacterAt(selectedCharacter, 80, 150);

  // Bags are decorative UI elements (simple stylized bag shapes)
  int bagCount = 3;
  int bagWidth = width/3 -30;
  int bagHeight = height/3;
  int spacing = 40; // space between bags
  int totalWidth = bagCount * bagWidth + (bagCount - 1) * spacing;
  int startX = (width - totalWidth) / 2;
  int y = height - bagHeight - 30; // 30 px above bottom edge
  
  

  // Initialize bag objects once using the computed layout
  if (bags[0] == null) {
    initBags(startX, y, bagWidth, bagHeight, spacing);
  }

  //word bank 
  fill(255);
  rect(150, 100, bagWidth*2, 100, 12);

  // Word list display
  fill(0);
  textAlign(LEFT, TOP);
  textSize(16);
  level = "easy";

  
  for (int i = 0; i < wordsToShowEasy.size(); i++) {
    text(wordsToShowEasy.get(i), 160 + (i % 5) * 100, 110 + (i / 5) * 20);
  }
  //bags

  for (int i = 0; i < bags.length; i++) {
    bags[i].draw(i == selectedBag);
  }

  // show selected bag id if any
  if (selectedBag >= 0 && selectedBag < bags.length) {
    fill(255);
    textAlign(CENTER);
    textSize(16);
    text("Selected: " + bags[selectedBag].id, width/2, y - 10);
  }

  // back to register button
  fill(200,50,50);
  rect(width - 150, height - 70, 120, 50, 8);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("BACK", width - 90, height - 45);

  // draw dragging word on top if any
  if (dragging && draggingWord != null) {
    fill(255, 220, 100);
    rect(dragX - 4, dragY - 14, textWidth(draggingWord) + 8, 20, 4);
    fill(0);
    textAlign(LEFT, TOP);
    text(draggingWord, dragX, dragY - 12);
  }
}

void gameMousePressed() {
  // Check if back button clicked
  if (mouseX > width - 150 && mouseX < width - 30 &&
      mouseY > height - 70 && mouseY < height - 20) {
    currentScene = 1;
    return;
  }


  // Check if clicked on a word in the word list (start dragging)
  for (int i = 0; i < wordsToShowEasy.size(); i++) {
    float tx = 160 + (i % 5) * 100;
    float ty = 110 + (i / 5) * 20;
    float tw = textWidth(wordsToShowEasy.get(i)) + 8;
    float th = 18;
    if (mouseX >= tx && mouseX <= tx + tw && mouseY >= ty && mouseY <= ty + th) {
      // remove the word from the word list and begin dragging it
      draggingWord = wordsToShowEasy.get(i);
      dragging = true;
      dragX = mouseX;
      dragY = mouseY;
      // remove from array
      wordsToShowEasy.remove(i);
      return;
    }
  }

  // Check if any bag clicked
  for (int i = 0; i < bags.length; i++) {
    Bag b = bags[i];
    if (mouseX > b.x && mouseX < b.x + b.w &&
        mouseY > b.y && mouseY < b.y + b.h) {
      selectedBag = i;
      return;
    }
  }
}

// Track dragging position while mouse is down
void mouseDragged() {
  if (dragging) {
    dragX = mouseX;
    dragY = mouseY;
  }
}

void mouseReleased() {
  if (!dragging) return;
  // If released over a bag, add the word to that bag
  for (int i = 0; i < bags.length; i++) {
    if (bags[i].contains(mouseX, mouseY)) {
      bags[i].addWord(draggingWord);
      dragging = false;
      draggingWord = null;
      return;
    }
  }
  // otherwise return it to the current word list (append to the end)
  String[] cur = wordListArray[selectedCharacter].easy;
  String[] appended = new String[cur.length + 1];
  for (int k = 0; k < cur.length; k++) appended[k] = cur[k];
  appended[cur.length] = draggingWord;
  wordListArray[selectedCharacter].easy = appended;
  dragging = false;
  draggingWord = null;
}

class Bag {
  int x; 
  int y;
  int w;
  int h;
  String id;
  ArrayList<String> contents = new ArrayList<String>();

  Bag(int x_, int y_, int w_, int h_, String id_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    id = id_;
  }

  void draw(boolean selected) {
    // draw bag body
    if (selected) {
      fill(220, 160, 60);
      strokeWeight(3);
    } else {
      fill(180, 120, 40);
      strokeWeight(2);
    }
    tint(255, 127);
    rect(x, y, w, h, 12);

    // flap
    fill(160, 90, 30);
    noStroke();
    triangle(x, y, x + w/2, y - 18, x + w, y);

    // handle
    stroke(100, 60, 20);
    strokeWeight(3);
    noFill();
    arc(x + w/2, y + 10, w/2, 28, PI, TWO_PI);

    // label
    noStroke();
    fill(60);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(id, x + w/2, y + h/2);

    // show number of words inside
    fill(255);
    textSize(12);
    textAlign(RIGHT, TOP);
    text("(" + contents.size() + ")", x + w - 8, y + 6);
  }

  boolean contains(int px, int py) {
    return px > x && px < x + w && py > y && py < y + h;
  }

  void addWord(String w) {
    if (w == null) return;
    contents.add(w);
  }
}

// Initialize bag objects using computed layout
void initBags(int startX, int y, int bagWidth, int bagHeight, int spacing) {
  for (int i = 0; i < bags.length; i++) {
    int bx = startX + i * (bagWidth + spacing);
    String bagId = "bag-" + (i + 1);
    bags[i] = new Bag(bx, y, bagWidth, bagHeight, bagId);
  }
}

// Utility: remove element at index from a String[] and return new array
String[] removeAt(String[] arr, int idx) {
  if (arr == null) return new String[0];
  if (idx < 0 || idx >= arr.length) return arr;
  String[] out = new String[arr.length - 1];
  int p = 0;
  for (int i = 0; i < arr.length; i++) {
    if (i == idx) continue;
    out[p++] = arr[i];
  }
  return out;
}

// Draw a character representation centered at (cx, cy).
// Call this with the desired center coordinates.
void drawSelectedCharacterAt(int sel, int cx, int cy) {
  pushMatrix();
  translate(cx, cy);
  fill(200);
  rect(-40, -40, 80, 80, 6);
  fill(0);
  noStroke();
  if (sel == 0) {
    circle(0, -20, 40);
    rect(-8, 0, 16, 40);
  } else if (sel == 1) {
    rect(-15, -30, 30, 30);
    circle(0, 10, 30);
  } else {
    circle(0, -15, 35);
    triangle(-10, 10, 10, 10, 0, 25);
  }
  popMatrix();
}