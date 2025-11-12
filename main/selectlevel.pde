void drawSelectLevel() {
    background(100, 150, 200);
    
    fill(255);
    textSize(32);
    textAlign(CENTER);
    text("Select Level", width/2, 50);
    
    // Level options
    String[] levels = {"Easy", "Medium", "Hard"};
    
    for (int i = 0; i < levels.length; i++) {
        int x = width/2;
        int y = 150 + i * 100;
        
        // Highlight selected level
        if (i == selectedLevel) {
        fill(255, 200, 0);
        stroke(255);
        strokeWeight(3);
        } else {
        fill(200);
        stroke(0);
        strokeWeight(1);
        }
        
        rect(x - 100, y - 30, 200, 60);
        
        // Draw level text
        fill(0);
        textSize(24);
        textAlign(CENTER, CENTER);
        text(levels[i], x, y);
    }
    
    // Confirm button
    fill(50, 200, 50);
    stroke(0);
    strokeWeight(1);
    rect(width/2 - 75, 450, 150, 60);
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("START LEVEL", width/2, 480);
}

void selectLevelMousePressed() {
    // Check level selection
    for (int i = 0; i < 3; i++) {
        int x = width/2;
        int y = 150 + i * 100;
        
        if (mouseX > x - 100 && mouseX < x + 100 &&
            mouseY > y - 30 && mouseY < y + 30) {
            selectedLevel = i;
        }
    }
    // Ensure the active words list is initialized and cleared before appending
    
    wordsToShow = new StringList();
    if (selectedLevel == 0) {
        for (int i = 0; i < wordsToShowEasy.size(); i++) {
        wordsToShow.append(wordsToShowEasy.get(i));
        }
    } else if (selectedLevel == 1) {
        for (int i = 0; i < wordsToShowMedium.size(); i++) {
        wordsToShow.append(wordsToShowMedium.get(i));
        }
    } else if (selectedLevel == 2) {
        for (int i = 0; i < wordsToShowHard.size(); i++) {
        wordsToShow.append(wordsToShowHard.get(i));
        }
    }
    wordsToFind = wordsToShow;
    // Check if Start Level button clicked
    if (mouseX > width/2 - 75 && mouseX < width/2 + 75 &&
        mouseY > 450 && mouseY < 510) {
        currentScene = 3;
    }
   
}