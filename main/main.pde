
int currentScene = 0; // 0 = intro, 1 = register, 2 = game
String playerName = "";
int selectedCharacter = 0; // 0, 1, or 2
NameBox nameBox;
WordList [] wordListArray = new WordList[3]; 
StringList wordsToShowEasy;
StringList wordsToShowMedium;
StringList wordsToShowHard;
StringList wordsToShow;
StringList wordsToFind;
int selectedLevel = 0; // 0 = easy, 1 = medium, 2 = hard

void setup() {
  background(255);
  
  size(800, 600);

  // Initialize word lists
  wordListArray[0] = new WordList();
  wordListArray[0].easy = new String[]{"cat", "bear", "fish", "bird"};
  wordListArray[0].medium = new String[]{"dolphin", "eagle", "turtle", "kangaroo"};
  wordListArray[0].hard = new String[]{"amphibian", "nocturnal", "camouflage", "habitat"};

  wordListArray[1] = new WordList();
  wordListArray[1].easy = new String[]{"red", "blue", "green", "yellow"};
  wordListArray[1].medium = new String[]{"purple", "orange", "indigo", "violet"};
  wordListArray[1].hard = new String[]{"turquoise", "magenta", "chartreuse", "cerulean"};

  wordListArray[2] = new WordList();
  wordListArray[2].easy = new String[]{"desk", "teacher", "homework", "pencil"};
  wordListArray[2].medium = new String[]{"cafeteria", "assignment"};
  wordListArray[2].hard = new String[]{"curriculum", "extracurricular"}; 


  wordsToShowEasy = new StringList();
  wordsToShowMedium = new StringList();
  wordsToShowHard = new StringList();

  for (int i = 0; i < wordListArray.length; i++) {
    for (int j = 0; j < wordListArray[i].easy.length; j++) {
      String word = wordListArray[i].easy[j];
      wordsToShowEasy.append(word);
    }
    for (int j = 0; j < wordListArray[i].medium.length; j++) {
      String word = wordListArray[i].medium[j];
      wordsToShowMedium.append(word);
    }
    for (int j = 0; j < wordListArray[i].hard.length; j++) {
      String word = wordListArray[i].hard[j];
      wordsToShowHard.append(word);
    }
  }
  wordsToShow = new StringList();
  stageWords = new StringList();

} 
void draw () {
  if (currentScene == 0) {
    drawIntro();
  } else if (currentScene == 1) {
    nameBox = new NameBox(100, 140, 300, 40, "");
    drawRegister();
  } else if (currentScene == 2) {
    drawSelectLevel();
  } else if (currentScene == 3) {  
    drawDragGame();
  } else if (currentScene == 4) {
    drawFindGame();
  }

}

void mousePressed() {
  if (currentScene == 0) {
    introMousePressed();
  } else if (currentScene == 1) {
    registerMousePressed();
  } else if (currentScene == 2) {
    selectLevelMousePressed();
  } else if (currentScene == 3) {
    gameMousePressed();
  } else if (currentScene == 4) {
    findGameMousePressed();
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
  String [] easy = new String[4];
  String [] medium = new String[4];
  String [] hard = new String[4];
}