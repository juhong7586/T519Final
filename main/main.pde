import processing.data.StringList;

int currentScene = 0; // 0 = intro, 1 = register, 2 = game
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
  
  size(800, 600);

  // Initialize word lists
  wordsDirection = new WordPair[]{
    new WordPair("top", "the highest part"),
    new WordPair("bottom", "the lowest part"),
    new WordPair("right", "the side opposite to left"),
    new WordPair("left", "the side opposite to right")
  };
  wordsToUse = new StringList();

  for (int j = 0; j < wordsDirection.length; j++) {
    String word = wordsDirection[j].word;
    wordsToUse.append(word);
  }
  wordPairs = new WordPair[wordsToUse.size()];
}

void draw () {
  if (currentScene == 0) {
    drawIntro();
  } else if (currentScene == 1) {
    nameBox = new NameBox(100, 140, 300, 40, "");
    drawRegister();
  } else if (currentScene == 2) {
    
    drawLearnWords(wordsDirection);
  } else if (currentScene == 3) {
    // Map scene drawing function (if any)
    initMapCamera();
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
  }
}

void keyPressed() {
  if (currentScene == 1) {
    registerKeyPressed();
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
  String imagePath;

  WordPair(String word, String imagePath) {
    this.word = word;
    this.imagePath = imagePath;
  }
  
}