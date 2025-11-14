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
}

void learnWordsMousePressed() {
    // Placeholder for mouse interaction in learn words scene
    currentScene = 2; // Return to intro for simplicity
}