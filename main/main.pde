
int currentScene = 0; // 0 = intro, 1 = register, 2 = game
String playerName = "";
int selectedCharacter = 0; // 0, 1, or 2
NameBox nameBox;
WordList[] wordListArray = new WordList[3]; 


void setup() {
  background(255);
  
  size(800, 600);

  // Initialize word lists
  wordListArray[0] = new WordList(new String[]{"apple", "banana", "cherry"});
  wordListArray[1] = new WordList(new String[]{"dog", "elephant", "frog"});
  wordListArray[2] = new WordList(new String[]{"grape", "honeydew", "kiwi"});
}

void draw () {
  if (currentScene == 0) {
    drawIntro();
  } else if (currentScene == 1) {
    nameBox = new NameBox(100, 140, 300, 40, "");
    drawRegister();
  } else if (currentScene == 2) {
    drawGame();
  }
}

void mousePressed() {
  if (currentScene == 0) {
    introMousePressed();
  } else if (currentScene == 1) {
    registerMousePressed();
  } else if (currentScene == 2) {
    gameMousePressed();
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
      if (nameBox.focused == true) {
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


class WordList {
  String[] words;

  WordList(String[] words_) {
    words = words_;
  }
}