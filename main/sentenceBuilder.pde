class SentenceWord {
  String text;
  float x, y;
  float slotX, slotY;
  boolean inSlot;
  SentenceWord(String t, float xpos, float ypos, boolean slot) {
    text = t;
    x = xpos;
    y = ypos;
    inSlot = slot;
  }

  boolean isInside(float px, float py) {
    return px > x && px < x + 130 && py > y - 25 && py < y + 15;
  }

  boolean isInSlot(float px, float py) {
    return px > slotX && px < slotX + 90 && py > slotY - 25 && py < slotY + 15;
  }

  void display() {
    fill(100, 150, 255);
    rect(x, y - 25, 130, 40, 5);
    fill(255);
    textAlign(CENTER);
    textSize(16);
    text(text, x + 65, y - 3);
    textAlign(LEFT);
  }

  void displayDragging() {
    fill(150, 180, 255);
    rect(x, y - 25, 130, 40, 5);
    fill(0);
    textAlign(CENTER);
    textSize(16);
    text(text, x + 65, y - 3);
    textAlign(LEFT);
  }
}

ArrayList<SentenceWord> availableWords = new ArrayList<SentenceWord>();
ArrayList<SentenceWord> sentenceSlots = new ArrayList<SentenceWord>();
SentenceWord draggingWord = null;
int dragOffsetX = 0;
int dragOffsetY = 0;
boolean sentenceInit = false;
// Drag origin tracking
boolean draggingFromPalette = false;
int draggingFromSlotIndex = -1;

void drawSentenceBuilder() {
  // initialize once when entering the scene
  if (!sentenceInit) {
    sentenceInit = true;
    initSentenceBuilder();
  }

  background(capturedPhoto);
  // Title
  fill(0);
  textSize(32);
  textAlign(LEFT);
  text("Sentence Builder", 30, 40);

  // Instructions
  textSize(14);
  fill(50);
  text("Drag words into the blanks to create a sentence", 30, 310);

  // Draw available words label
  textSize(16);
  fill(0);
  text("Available Words:", 30, 65);

  // Draw available words
    for (SentenceWord w : availableWords) {
      w.display();
    }

  // Draw sentence section
  textSize(16);
  fill(0);
  text("Your Sentence:", 30, 350);

  textSize(24);
  textAlign(LEFT);
  int sentenceX = 50;
  int sentenceY = 400;
  // optional leading fixed word
  text("", sentenceX, sentenceY);
  sentenceX += 80;

  // Draw sentence slots and words
  for (int i = 0; i < sentenceSlots.size(); i++) {
    SentenceWord w = sentenceSlots.get(i);

    if (w != null) {
      // Draw word in slot
      fill(100, 150, 255);
      rect(sentenceX, sentenceY - 25, 90, 40, 5);
      fill(255);
      textAlign(CENTER);
      textSize(16);
      text(w.text, sentenceX + 45, sentenceY - 3);
      textAlign(LEFT);
      w.slotX = sentenceX;
      w.slotY = sentenceY;
    } else {
      // Draw empty slot
      fill(255);
      stroke(100);
      strokeWeight(2);
      rect(sentenceX, sentenceY - 25, 90, 40, 5);
      line(sentenceX, sentenceY + 12, sentenceX + 90, sentenceY + 12);
      noStroke();
    }

    sentenceX += 110;
  }

  // Draw question mark
  fill(0);
  textSize(24);
  text("?", sentenceX, sentenceY);

  // Draw dragging word
  if (draggingWord != null) {
    draggingWord.displayDragging();
  }

  // Draw reset button
  fill(200, 100, 100);
  rect(750, 480, 120, 50, 5);
  fill(255);
  textSize(16);
  textAlign(CENTER);
  text("Reset", 810, 510);
  textAlign(LEFT);
}

void initSentenceBuilder() {
  availableWords.clear();
  sentenceSlots.clear();

  int n = 5;
  if (wordsToUse != null && wordsToUse.size() > 0) {
    // create one slot per word or cap at 8
    n = min(max(1, wordsToUse.size()), 8);
    for (int i = 0; i < wordsToUse.size(); i++) {
      String s = wordsToUse.get(i);
      availableWords.add(new SentenceWord(s, 0, 0, false));
    }
  } else {
    // fallback sample words
    String[] words = {"doing", "am", "are", "now", "you"};
    for (String word : words) {
      availableWords.add(new SentenceWord(word, 0, 0, false));
    }
  }

  // create empty slots
  for (int i = 0; i < n; i++) {
    sentenceSlots.add(null);
  }

  layoutSentenceWords();
}

void layoutSentenceWords() {
  // Position available words at top
  int x = 50;
  int y = 150;
  for (int i = 0; i < availableWords.size(); i++) {
     SentenceWord w = availableWords.get(i);
    w.x = x;
    w.y = y;
    x += 140;
  }
}

void sentenceBuilderMousePressed() {
  // Check if reset button clicked
  if (mouseX > 750 && mouseX < 870 && mouseY > 480 && mouseY < 530) {
    resetSentenceBuilder();
    return;
  }

  // Check if clicking on available words (palette). Clone when dragged so palette remains intact.
  for (int i = 0; i < availableWords.size(); i++) {
    SentenceWord w = availableWords.get(i);
    if (w.isInside(mouseX, mouseY)) {
      // create a copy for placement so palette can be reused
      draggingWord = new SentenceWord(w.text, w.x, w.y, false);
      dragOffsetX = mouseX - int(w.x);
      dragOffsetY = mouseY - int(w.y);
      draggingFromPalette = true;
      draggingFromSlotIndex = -1;
      return;
    }
  }

  // Check if clicking on words in sentence (move existing placed word)
  for (int i = 0; i < sentenceSlots.size(); i++) {
    SentenceWord w = sentenceSlots.get(i);
    if (w != null && w.isInSlot(mouseX, mouseY)) {
      // pick up the placed instance (remove it from its slot until drop)
      draggingWord = w;
      dragOffsetX = mouseX - int(w.slotX);
      dragOffsetY = mouseY - int(w.slotY);
      sentenceSlots.set(i, null);
      draggingFromPalette = false;
      draggingFromSlotIndex = i;
      return;
    }
  }
}

void sentenceBuilderMouseDragged() {
  if (draggingWord != null) {
    draggingWord.x = mouseX - dragOffsetX;
    draggingWord.y = mouseY - dragOffsetY;
  }
}

void sentenceBuilderMouseReleased() {
  if (draggingWord == null) return;

  // Check if dropped on a sentence slot
  for (int i = 0; i < sentenceSlots.size(); i++) {
    int slotX = 50 + 80 + (i * 110);
    int slotY = 400;

    if (mouseX > slotX && mouseX < slotX + 90 && mouseY > slotY - 25 && mouseY < slotY + 15) {
      // If slot already has a placed word, move it back to palette as a copy
      SentenceWord old = sentenceSlots.get(i);
      if (old != null) {
        availableWords.add(new SentenceWord(old.text, 0, 0, false));
      }

      // Place dragged word into slot
      sentenceSlots.set(i, draggingWord);
      draggingWord = null;
      layoutSentenceWords();
      return;
    }
  }

  // If not dropped on a valid slot:
  if (draggingFromPalette) {
    // discard the clone and just reset layout
    layoutSentenceWords();
    draggingWord = null;
  } else {
    // it was moved from an existing slot — restore it to its original slot
    if (draggingFromSlotIndex >= 0 && draggingFromSlotIndex < sentenceSlots.size()) {
      sentenceSlots.set(draggingFromSlotIndex, draggingWord);
    }
    layoutSentenceWords();
    draggingWord = null;
  }
}

void resetSentenceBuilder() {
  availableWords.clear();
  if (wordsToUse != null && wordsToUse.size() > 0) {
    for (int i = 0; i < wordsToUse.size(); i++) {
      availableWords.add(new SentenceWord(wordsToUse.get(i), 0, 0, false));
    }
  } else {
    String[] words = {"doing", "am", "are", "now", "you"};
    for (String word : words) {
      availableWords.add(new SentenceWord(word, 0, 0, false));
    }
  }

  for (int i = 0; i < sentenceSlots.size(); i++) {
    sentenceSlots.set(i, null);
  }

  layoutSentenceWords();
  draggingWord = null;
}
