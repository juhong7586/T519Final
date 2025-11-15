void drawLearnWords(WordPair[] wordList){
    background(100, 150, 200);
    fill(255);
    textSize(28);
    textAlign(CENTER);
    text("Learning Words", width/2, 50);
    textSize(20);
    textAlign(LEFT);
    text("Use the following words to interact:", 50, 150);
    for (int i = 0; i < wordList.length; i++) {
        text(wordList[i].word, 50, 200 + i * 30);
    }

    // add a button to go to map scene
    fill(0, 200, 0);
    rect(width - 100, height - 50, 150, 50);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Go to Map", width - 100, height - 50);      

}

void learnWordsMousePressed() {
    // Placeholder for mouse interaction in learn words scene
    if (mouseX > width - 100 && mouseX < width + 50 && mouseY > height - 50 && mouseY < height) {
        currentScene = 3; // Switch to map scene
    }
}