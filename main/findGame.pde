
import java.util.ArrayList;
import java.util.List;

int currentDrawing = 0;
List<Integer> stageWordsIndexes = new ArrayList<Integer>();
StringList stageWords;
boolean stageGenerated = false;


// Button layout for generating the stage
int genBtnX, genBtnY, genBtnW, genBtnH;

void drawFindGame() {
    background(30, 40, 50);
    fill(255);
    textSize(20);
    text("Find Game", width/2, 40);
    rect(0, 100, width, height/2);

    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);

        // draw a button to generate the stage words (only generate when clicked)
        genBtnW = 220;
        genBtnH = 40;
        genBtnX = width/2 - genBtnW/2;
        genBtnY = height/2 + 40;

        if (!stageGenerated) {
            // visible button
            fill(50, 200, 50);
            rect(genBtnX, genBtnY, genBtnW, genBtnH, 6);
            fill(255);
            textSize(16);
            textAlign(CENTER, CENTER);
            text("Generate Stage Words", width/2, genBtnY + genBtnH/2);
        } else {
            // show the generated words
            fill(0);
            textSize(16);
            textAlign(LEFT, TOP);
            if (stageWords == null || stageWords.size() == 0) {
                text("No words generated (empty list).", 20, 120);
            } else {
                for (int i = 0; i < stageWords.size(); i++) {
                    text(stageWords.get(i), 20 + (i % 5) * 120, 120 + (i / 5) * 30);
                }
            }
        }
}

// Call this from the global mousePressed dispatch when the find-game scene is active
void findGameMousePressed() {
    // If already generated, clicking does nothing for now
    if (stageGenerated) return;
    // check if click is inside the generate button
    if (mouseX > genBtnX && mouseX < genBtnX + genBtnW &&
            mouseY > genBtnY && mouseY < genBtnY + genBtnH) {
        prepareStageWords();
    }
}

void prepareStageWords() {
    // guard: ensure source words exist
    if (wordsToFind == null || wordsToFind.size() == 0) {
        stageWords = new StringList();
        stageGenerated = true;
        return;
    }

    stageWordsIndexes = new ArrayList<Integer>();
    stageWords = new StringList();

    while (stageWordsIndexes.size() < 5 && stageWordsIndexes.size() < wordsToFind.size()) {
        int randomIndex = int(random(wordsToFind.size()));
        boolean contains = stageWordsIndexes.contains(randomIndex);
        if (!contains) {
            stageWordsIndexes.add(randomIndex);
        }
    }

    for (int i = 0; i < stageWordsIndexes.size(); i++) {
        int wordIndex = stageWordsIndexes.get(i);
        stageWords.append(wordsToFind.get(wordIndex));
    }

    stageGenerated = true;
}