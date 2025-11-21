import java.util.ArrayList;

ArrayList<String> leftItems = new ArrayList<String>();
ArrayList<String> rightItems = new ArrayList<String>();
ArrayList<Integer> connections = new ArrayList<Integer>(); // stores pairs of indices
ArrayList<PImage> rightImages = new ArrayList<PImage>();
ArrayList<Integer> rightOrig = new ArrayList<Integer>(); // original index for each right item
ArrayList<Boolean> connCorrect = new ArrayList<Boolean>(); // correctness per connection pair
boolean showResults = false;
int lastCorrect = 0;
boolean showTryAgain = false;
int selected = -1; // index of currently selected item
boolean isLeftSelected = false; // track if selection is from left or right
boolean matchInit = false;
// box sizes (adjust these to change visual scale)
int leftBoxW = 200;
int leftBoxH = 110;
int rightBoxW = 260;
int rightBoxH = 140;

boolean correctAll = false;

void drawLearnWords(WordPair[] wordList){
    background(100, 150, 200);
    fill(255);
    textSize(28);
    textAlign(CENTER);
    text("Match Words to Learn", width/2, 50);
    

    // initialize matching items once using the provided wordList
    if (!matchInit) {
        leftItems.clear();
        rightItems.clear();
        connections.clear();
        // left column uses the words in-order
        for (int i = 0; i < wordList.length; i++) {
            leftItems.add(wordList[i].word);
        }
        // right column uses the same words but shuffled so user must match
        ArrayList<Integer> idx = new ArrayList<Integer>();
        for (int i = 0; i < wordList.length; i++) idx.add(i);
        // simple Fisher-Yates shuffle
        for (int i = idx.size()-1; i > 0; i--) {
            int j = int(random(i+1));
            int tmp = idx.get(i);
            idx.set(i, idx.get(j));
            idx.set(j, tmp);
        }
        for (int k = 0; k < idx.size(); k++) {
            int orig = idx.get(k);
            rightItems.add(wordList[orig].word);
            // store corresponding image (may be null)
            rightImages.add(wordList[orig].image);
            // remember which original index this right position corresponds to
            rightOrig.add(orig);
        }
        matchInit = true;
    }

    // Draw matching area
    float leftX = width * 0.2;
    float rightX = width * 0.8;
    float startY = 120;
    float spacing = max(leftBoxH + 20, (height - 220) / max(1, leftItems.size()));

    // Draw existing connections (lines). If results were checked, color by correctness.
    strokeWeight(4);
    for (int i = 0; i < connections.size(); i += 2) {
        int pairIdx = i/2;
        int l = connections.get(i);
        int r = connections.get(i+1);
        float x1 = leftX;
        float y1 = startY + l * spacing;
        float x2 = rightX;
        float y2 = startY + r * spacing;
        if (showResults && pairIdx < connCorrect.size()) {
            if (connCorrect.get(pairIdx)) stroke(40, 200, 100); // green
            else stroke(220, 60, 60); // red
        } else {
            stroke(60, 120, 200); // default blue
        }
        line(x1, y1, x2, y2);
    }

    // Draw left items
    for (int i = 0; i < leftItems.size(); i++) {
        float x = leftX;
        float y = startY + i * spacing;
        if (isLeftSelected && selected == i) fill(200, 100, 100);
        else fill(120, 80, 180);
        noStroke();
        rect(x - leftBoxW/2, y - leftBoxH/2, leftBoxW, leftBoxH, 12);
        fill(255);
        textSize(20);
        textAlign(CENTER, CENTER);
        text(leftItems.get(i), x, y);
    }

    // Draw right items (image if available, otherwise text)
    for (int i = 0; i < rightItems.size(); i++) {
        float x = rightX;
        float y = startY + i * spacing;
        if (!isLeftSelected && selected == i) fill(200, 100, 100);
        else fill(50);
        noStroke();
        rect(x - rightBoxW/2, y - rightBoxH/2, rightBoxW, rightBoxH, 12);
        PImage img = null;
        if (i < rightImages.size()) img = rightImages.get(i);
        if (img != null) {
            // draw image centered inside the box, scaled to fit
            imageMode(CENTER);
            float maxW = rightBoxW - 24;
            float maxH = rightBoxH - 24;
            float iw = img.width;
            float ih = img.height;
            float scale = min(maxW/iw, maxH/ih);
            float drawW = iw * scale;
            float drawH = ih * scale;
            fill(255);
            image(img, x, y, drawW, drawH);
        } else {
            fill(255);
            textSize(18);
            textAlign(CENTER, CENTER);
            text(rightItems.get(i), x, y);
        }
    }

    // Info text
    fill(0);
    textSize(14);
    textAlign(LEFT);
    text("Click an item on the left, then its match on the right. Click again to deselect.", 20, height - 40);

    // add a button to go to map scene
    int btnW = 150;
    int btnH = 50;
    float btnX = width - btnW/2 -20 ;
    float btnY = height - 50;

    // Clear button to the left of Go to Map
    float clearBtnX = btnX - btnW -40;
    float clearBtnY = btnY;
    fill(180, 50, 50);
    rect(clearBtnX - btnW/2, clearBtnY - btnH/2, btnW, btnH);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Clear", clearBtnX, clearBtnY);


    // If results are available, show summary
    if (correctAll) {
        fill(0);
        textSize(14);
        textAlign(CENTER);
        text(lastCorrect + " / " + (connections.size()/2) + " correct", width/2, btnY - 30);
        fill(0, 200, 0);
        rect(btnX - btnW/2, btnY - btnH/2, btnW, btnH);
        fill(255);
        textAlign(CENTER, CENTER);
        text("Go to Map", btnX, btnY);

    } else {
        // Check button to the right of Go to Map
        fill(40, 120, 200);
        rect(btnX - btnW/2, btnY - btnH/2, btnW, btnH);
        fill(255);
        textAlign(CENTER, CENTER);
        text("Check", btnX, btnY);
    }

    // Draw Try Again modal if needed
    if (showTryAgain) {
        pushStyle();
        fill(0, 0, 0, 150);
        rect(0, 0, width, height);

        float mw = 360;
        float mh = 160;
        float mx = width/2;
        float my = height/2;
        fill(255);
        rect(mx - mw/2, my - mh/2, mw, mh, 8);
        fill(0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Try again!", mx, my - 20);

        // OK button
        float okW = 100;
        float okH = 40;
        float okX = mx;
        float okY = my + 40;
        fill(40, 120, 200);
        rect(okX - okW/2, okY - okH/2, okW, okH, 6);
        fill(255);
        textSize(16);
        text("OK", okX, okY);
        popStyle();
    }
}

void checkConnections() {
    connCorrect.clear();
    lastCorrect = 0;
    for (int i = 0; i < connections.size(); i += 2) {
        int l = connections.get(i);
        int r = connections.get(i+1);
        boolean correct = false;
        if (r >= 0 && r < rightOrig.size()) {
            correct = (l == rightOrig.get(r));
        }
        connCorrect.add(correct);
        if (correct) lastCorrect++;
    }
    showResults = true;
    // If there are connections but not all are correct, show a Try Again confirmation overlay
    int total = connections.size() / 2;
    if (total > 0 && lastCorrect < total) {
        showTryAgain = true;
    } else {
        showTryAgain = false;
        correctAll = true;
    }
}

void learnWordsMousePressed() {
    // Buttons (positions match draw): Clear, Go to Map, Check
    int btnW = 150;
    int btnH = 50;
    float btnX = width - btnW/2 - 20;
    float btnY = height - 50;
    float clearBtnX = btnX - btnW - 40;
    float clearBtnY = btnY;
    // Check button is drawn at btnX in drawLearnWords(), so use same X here
    float checkBtnX = btnX;
    float checkBtnY = btnY;

    // Clear button hit test
    if (mouseX > clearBtnX - btnW/2 && mouseX < clearBtnX + btnW/2 && mouseY > clearBtnY - btnH/2 && mouseY < clearBtnY + btnH/2) {
        // clear connections and reset selection and results
        connections.clear();
        connCorrect.clear();
        showResults = false;
        lastCorrect = 0;
        selected = -1;
        isLeftSelected = false;
        return;
    }

    // If Try Again modal is showing, check OK button first
    if (showTryAgain) {
        float mx = width/2;
        float my = height/2;
        float okW = 100;
        float okH = 40;
        float okX = mx;
        float okY = my + 40;
        if (mouseX > okX - okW/2 && mouseX < okX + okW/2 && mouseY > okY - okH/2 && mouseY < okY + okH/2) {
            showTryAgain = false;
            return;
        }
        // clicking outside OK when modal up does nothing
        return;
    }

    // Go to Map (check this first so the visible Go-to-Map button is handled)
    if (mouseX > btnX - btnW/2 && mouseX < btnX + btnW/2 && mouseY > btnY - btnH/2 && mouseY < btnY + btnH/2) {
        if (correctAll) {
            currentScene = 3; // Switch to map scene
            } else {
                checkConnections();
                return;
            }
    }

    // Matching interactions
    float leftX = width * 0.2;
    float rightX = width * 0.8;
    float startY = 120;
    float spacing = max(leftBoxH + 20, (height - 220) / max(1, leftItems.size()));

    // Check left items
    for (int i = 0; i < leftItems.size(); i++) {
        float x = leftX;
        float y = startY + i * spacing;
        if (mouseX > x - leftBoxW/2 && mouseX < x + leftBoxW/2 && mouseY > y - leftBoxH/2 && mouseY < y + leftBoxH/2) {
            if (isLeftSelected && selected == i) {
                // Deselect
                selected = -1;
                isLeftSelected = false;
            } else if (!isLeftSelected && selected >= 0) {
                // Connect left to previously selected right
                connections.add(i);
                connections.add(selected);
                selected = -1;
                // reset any previous check results
                connCorrect.clear();
                showResults = false;
            } else {
                // Select left item
                selected = i;
                isLeftSelected = true;
            }
            return;
        }
    }

    // Check right items
    for (int i = 0; i < rightItems.size(); i++) {
        float x = rightX;
        float y = startY + i * spacing;
        if (mouseX > x - rightBoxW/2 && mouseX < x + rightBoxW/2 && mouseY > y - rightBoxH/2 && mouseY < y + rightBoxH/2) {
            if (!isLeftSelected && selected == i) {
                // Deselect
                selected = -1;
                isLeftSelected = false;
            } else if (isLeftSelected && selected >= 0) {
                // Connect left to right
                connections.add(selected);
                connections.add(i);
                selected = -1;
                isLeftSelected = false;
                // reset any previous check results
                connCorrect.clear();
                showResults = false;
            } else {
                // Select right item
                selected = i;
                isLeftSelected = false;
            }
            return;
        }
    }
}
