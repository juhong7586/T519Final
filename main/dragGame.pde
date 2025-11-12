

Bag [] bags = new Bag[3];

int selectedBag = -1;

// Drag-and-drop state for words
boolean dragging = false;
String draggingWord = null;
float dragX = 0, dragY = 0;

int draggingIndex = -1; // store original index so we can restore if not dropped in bag

boolean putInBag = false;
// Next button when wordsToShow is empty
int dragNextBtnX, dragNextBtnY, dragNextBtnW, dragNextBtnH;



void drawDragGame() {
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
  rect(150, 100, bagWidth*2+50, 100, 12);

  // Word list display
  fill(0);
  textAlign(LEFT, TOP);
  textSize(16);

  for (int i = 0; i < wordsToShow.size(); i++) {
    text(wordsToShow.get(i), 160 + (i % 5) * 100, 110 + (i / 5) * 20);
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

  // show Next button when the visible bank is empty
  if (wordsToShow == null || wordsToShow.size() == 0) {
    dragNextBtnW = 140;
    dragNextBtnH = 36;
    dragNextBtnX = width/2 - dragNextBtnW/2;
    dragNextBtnY = height - 70;
    fill(80, 120, 240);
    rect(dragNextBtnX, dragNextBtnY, dragNextBtnW, dragNextBtnH, 6);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("Next", dragNextBtnX + dragNextBtnW/2, dragNextBtnY + dragNextBtnH/2);
  }

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
    currentScene = 2;
    return;
  }

  // If the bank is empty, check the Next button to advance
  if (wordsToShow == null || wordsToShow.size() == 0) {
    if (mouseX > dragNextBtnX && mouseX < dragNextBtnX + dragNextBtnW &&
        mouseY > dragNextBtnY && mouseY < dragNextBtnY + dragNextBtnH) {
      currentScene = 4;
      return;
    }
  }


  // Check if clicked on a word in the word list (start dragging)
  for (int i = 0; i < wordsToShow.size(); i++) {
    float tx = 160 + (i % 5) * 100;
    float ty = 110 + (i / 5) * 20;
    float tw = textWidth(wordsToShow.get(i)) + 8;
    float th = 18;
    if (mouseX >= tx && mouseX <= tx + tw && mouseY >= ty && mouseY <= ty + th) {
      // begin dragging: take the word out of the visible bank so it disappears while dragged
      draggingWord = wordsToShow.get(i);
      draggingIndex = i;
      wordsToShow.remove(i);
      dragging = true;
      dragX = mouseX;
      dragY = mouseY;
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
      putInBag = true;
      return;
    }
  }
  // otherwise the word was released outside any bag — restore it to the word bank
  if (draggingWord != null) {
    // Reinsert at original position if possible, otherwise append
    StringList newList = new StringList();
    int insertPos = constrain(draggingIndex, 0, wordsToShow.size());
    for (int k = 0; k < insertPos; k++) newList.append(wordsToShow.get(k));
    newList.append(draggingWord);
    for (int k = insertPos; k < wordsToShow.size(); k++) newList.append(wordsToShow.get(k));
    wordsToShow = newList;
  }
  dragging = false;
  draggingWord = null;
  draggingIndex = -1;
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
    textSize(20);
    textAlign(RIGHT, TOP);
    text("(" + contents.size() + ")", x + w - 8, y + 6);

    // draw words inside the bag (top-left area)
    // simple layout: left-aligned lines, limited by available height
    noStroke();
    textSize(20);
    textAlign(LEFT, TOP);
    fill(255);
    int padding = 10;
    float tx = x + padding;
    float ty = y + padding + 6; // leave some space under flap/edge
    int lineHeight = 14;
    int availableHeight = h - padding * 2 - 24; // reserve space for label/count
    int maxLines = max(0, availableHeight / lineHeight);
    for (int i = 0; i < contents.size() && i < maxLines; i++) {
      String word = contents.get(i);
      text(word, tx, ty + i * lineHeight);
    }
    if (contents.size() > maxLines && maxLines > 0) {
      String more = "+" + (contents.size() - maxLines) + " more";
      textAlign(LEFT, TOP);
      textSize(12);
      text(more, tx, ty + maxLines * lineHeight);
    }
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