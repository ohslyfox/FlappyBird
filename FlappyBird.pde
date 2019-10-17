/**
 * @author Patrick Finger
 * @date 05/22/2019
 * @brief A recreation of the hit mobile
 * game "Flappy Bird." Original idea credit
 * goes to Dong Nguyen
 */
public static final int BIRD_WIDTH = 60;
public static final int BIRD_HEIGHT = 40;
private Pipe[] pipes;
private Bird bird;
private Background background;
private int[] scores;
private String[] dates;
private PImage pipeUprightImage, pipeUpsideDownImage;
public int pipeIncrementer;
public boolean scoredPipe;
public boolean gameActive;
public boolean jumpReleased;

/**
 * initalizes the game
 */
public void setup() {
  frameRate(144);
  size(1280, 720);
  textAlign(CENTER);
  imageMode(CORNER);
  scores = new int[0];
  dates = new String[0];
  pipeUprightImage = loadImage("pipe.png");
  pipeUpsideDownImage = loadImage("pipe_upsidedown.png");
  restart();
  saveData(); // faster loading
}

/**
 * Handles key press events
 */
public void keyPressed() {
  if (keyCode == ' ' && jumpReleased && bird.getLocation().y > (BIRD_HEIGHT/2) && bird.isAlive()) {
    gameActive = true;
    jumpReleased = false;
    bird.hop();
  }       
  if (keyCode == 'r' || keyCode == 'R') {
    restart();
  }
}

/**
 * Handles key release events
 */
public void keyReleased() {
  if (keyCode == ' ') {
    jumpReleased = true;
  }
}

/**
 * Restarts the game
 */
public void restart() {
  // recreate objects
  pipes = new Pipe[5];
  for (int i = 0; i < pipes.length; i++) {
    pipes[i] = new Pipe(new PVector(550 + 550*i, 0), pipeUprightImage, pipeUpsideDownImage); 
  }
  bird = new Bird();
  background = new Background();
  
  // reset game settings
  pipeIncrementer = 0;
  scoredPipe = false;
  gameActive = false;
  jumpReleased = true;
}

/**
 * Creates and loads a highscore table and loads
 * data into local variables for displaying highscores
 * @return dataTable, the table containing highscores
 */
public Table loadData() {
  // create a highscore table
  Table dataTable = new Table();
  dataTable.addColumn("score", Table.INT);
  dataTable.addColumn("date", Table.STRING);
  
  // attempt to load existing table
  File f = new File(dataPath("scores.csv"));
  if (f.exists()) {
     dataTable = loadTable(dataPath("scores.csv"), "header");
  }

  // load table into highscore vars
  scores = new int[min(dataTable.getRowCount(),5)];
  dates = new String[scores.length];
  for (int i = 0; i < scores.length; i++) {
    TableRow currentRow = dataTable.getRow(i);
    scores[i] = currentRow.getInt("score");
    dates[i] = currentRow.getString("date");
  }
  
  // return the table
  return dataTable;
}

/**
 * Attempts to save the current score to the
 * highscore table
 */
public void saveData() {
  // load table
  Table dataTable = loadData();
  
  // concat new score with existing table
  try {
    // abort if zero score or duplicate score
    if (bird.getScore() == 0) return;
    for (TableRow current : dataTable.rows()) {
      if (current.getInt("score") == bird.getScore()) return;
    }
    
    // add the new score to the table
    TableRow newData = dataTable.addRow();
    newData.setInt("score", bird.getScore());
    newData.setString("date", String.valueOf(month()) + "/" + String.valueOf(day()) + "/" + String.valueOf(year()));
    
    // sort the data descending
    dataTable.setColumnType("score", Table.INT); // this line is required for proper int sorting (?)
    dataTable.sortReverse("score");
    
    // create the new lines to be saved
    String[] lines = new String[min(dataTable.getRowCount()+1,6)]; 
    lines[0] = "score,date"; // header
    
    // load data into lines to be saved
    for (int i = 1; i < lines.length; i++) {
      TableRow currentRow = dataTable.getRow(i-1);
      lines[i] = "" + currentRow.getInt("score") + "," + currentRow.getString("date");
    }
    
    // save data
    saveStrings(dataPath("scores.csv"), lines);
    
    // load table into highscore vars
    scores = new int[min(dataTable.getRowCount(),5)];
    dates = new String[scores.length];
    for (int i = 0; i < scores.length; i++) {
      TableRow currentRow = dataTable.getRow(i);
      scores[i] = currentRow.getInt("score");
      dates[i] = currentRow.getString("date");
    }
  }
  catch (Exception e) {
    // do nothing
  }
}

/**
 * Game loop, handles frame-by-frame game mechanics
 */
public void draw() {
  //draw and scroll background
  background.display();
  if (gameActive) {
    background.scroll(); 
  }
  // draw and scroll pipes
  for (Pipe current : pipes) {
    if (gameActive) {
      current.scroll();
    }
    current.display();
  }
  // draw bird
  bird.display();
  
  // score / collision checking
  Pipe currentPipe = pipes[pipeIncrementer];
  if (currentPipe.checkCollision(bird.getLocation())) {
    scoredPipe = true;
    bird.kill();
  }
  else if (!scoredPipe && currentPipe.checkScored(bird.getLocation())) {
    scoredPipe = true;
    bird.score();
  }
  
  // draw screen text
  if (bird.isAlive()) {
    textSize(48);
    fill(0);
    if (!gameActive) {
      text("Press SPACE to start!", width/2, height/2-100); 
    }
    else {
      text(bird.getScore(), width/2, 75);
    }
  }
  else {
    fill(0);
    textSize(48);
    text("GAME OVER", width/2, height/2 - 200);
    text("Score: " + bird.getScore(), width/2, height/2 - 100);
    textSize(32);
    text("Press 'R' to restart", width/2, height/2 -50);
    if (!gameActive) {
      fill(0,0,0,50);
      stroke(0,0,0,150);
      rect(width/2 - 210, height/2, 420, map(scores.length, 0, 5, 60, 325));
      fill(0);
      text("Score", width/2 - 125, height/2 + 40);
      text("Date", width/2 + 100, height/2 + 40);
      text("-----", width/2 - 125, height/2 + 60);
      text("----", width/2 + 100, height/2 + 60);
      for (int i = 0; i < scores.length; i++) {
        text(scores[i], width/2 -125, height/2 + 50 + 50*(i+1));
        text(dates[i], width/2 + 100, height/2 + 50 + 50*(i+1));
      }
    }
  }
  textSize(12);
  fill(0,0,0,150);
  text("by slyfox", 30, height - 5);
}
