

import processing.data.StringList;

int currentScene = 3; // 0 = intro, 1 = register, 2 = game
String playerName = "";
int selectedCharacter = 0; // 0, 1, or 2
NameBox nameBox;
StringList wordsToUse; 
WordPair [] wordPairs;
WordPair [] wordsDirection;
WordPair [] wordsBuilding;
WordPair [] wordsNavigation;
WordPair [] wordsToShow;
WordPair [] wordsToFind;
int selectedLevel = 0; // 0 = easy, 1 = medium, 2 = hard

void setup() {
  background(255);
  
  size(1000, 600);

  // Initialize word lists
  wordsDirection = new WordPair[]{
    new WordPair("forward", "forward.png"),
    new WordPair("right", "right.png"),
    new WordPair("left", "left.png")
  };

  wordsNavigation = new WordPair[]{
    new WordPair("go", "up.png"),
    new WordPair("turn", "down.png")
  };
  wordsToUse = new StringList();

  for (int j = 0; j < wordsDirection.length; j++) {
    String word = wordsDirection[j].word;
    wordsToUse.append(word);
  }

  for (int j = 0; j < wordsNavigation.length; j++) {
    String word = wordsNavigation[j].word;
    wordsToUse.append(word);
  } 
  wordPairs = new WordPair[wordsToUse.size()];
  initMapCamera();
}

void draw () {
  if (currentScene == 0) {
    drawIntro();
  } else if (currentScene == 1) {
    nameBox = new NameBox(100, 140, 300, 40, "");
    drawRegister();
  } else if (currentScene == 2) {
    
    drawLearnWords(wordsDirection);
  } else if (currentScene == 4) {
    drawSentenceBuilder();
  //  } else if (currentScene == 3 && showResults == true) {
  } else if (currentScene == 3) {
    // Map scene drawing function (if any)
    
    drawMap();
  }

}

void mousePressed() {
  if (currentScene == 0) {
    introMousePressed();
  } else if (currentScene == 1) {
    registerMousePressed();
  } else if (currentScene == 2) {
    learnWordsMousePressed(); 
  } else if (currentScene == 3) {
    // Map scene mouse pressed function (if any)
    mapMousePressed();
  } else if (currentScene == 4) {
    sentenceBuilderMousePressed();
}
}

void mouseDragged() {
  if (currentScene == 4) {
    sentenceBuilderMouseDragged();
  }
}

void mouseReleased() {
  if (currentScene == 4) {
    sentenceBuilderMouseReleased();
  }
}

void keyPressed() {
  if (currentScene == 1) {
    registerKeyPressed();
  } else if(currentScene == 3){
    mapKeyPressed();
  }
}

class NameBox {
    float x, y, w, h;
    String text; 
    boolean focused;

    NameBox(float x, float y, float w, float h, String text) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.text = text;
        this.focused = false;
    }

    void display() {
      if (this.focused == true) {
        stroke(255);
        strokeWeight(2);
      }else{
        stroke(0);
        strokeWeight(1);
      }
      fill(200);
      rect(x, y, w, h);
      fill(0);
      textAlign(LEFT);
      text(text, x + 10, y + 30);
    }
}


class WordPair {
  String word;
  PImage image;

  // Construct with a loaded PImage
  WordPair(String word, PImage img) {
    this.word = word;
    this.image = img;
  }

  // Convenience: construct with an image filename (loaded from data/)
  WordPair(String word, String imagePath) {
    this.word = word;
    if (imagePath != null && imagePath.length() > 0) {
      this.image = loadImage(imagePath);
    } else {
      this.image = null;
    }
  }

}
