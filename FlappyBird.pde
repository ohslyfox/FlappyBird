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
public int pipeIncrementer;
public boolean scoredPipe;
public boolean gameActive;
public boolean jumpReleased;

public void setup() {
  frameRate(144);
  size(1280, 720);
  textAlign(CENTER);
  imageMode(CORNER);
  scores = new int[0];
  dates = new String[0];
  restart();
}

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

public void keyReleased() {
  if (keyCode == ' ') {
    jumpReleased = true;
  }
}

public void restart() {
  // recreate objects
  pipes = new Pipe[5];
  for (int i = 0; i < pipes.length; i++) {
    pipes[i] = new Pipe(new PVector(550 + 550*i, 0)); 
  }
  bird = new Bird();
  background = new Background();
  
  // reset game settings
  pipeIncrementer = 0;
  scoredPipe = false;
  gameActive = false;
  jumpReleased = true;
}

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

public void saveData() {
  // load table
  Table dataTable = loadData();
  
  // concat new score with existing table
  try {
    // abort if zero score or duplicate score
    if (bird.getScore() == 0) return;
    for (TableRow current : dataTable.rows()) {
      if (current.getInt("score") == bird.getScore()) {
        return;
      }
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
    loadData(); // for fetching new score into local vars
  }
  catch (Exception e) {
    // do nothing
  }
}

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
      text(bird.getScore(), width/2, 100);
    }
  }
  else {
    fill(0);
    textSize(48);
    text("GAME OVER.", width/2, height/2-100);
    text("Score: " + bird.getScore(), width/2, height/2);
    textSize(32);
    text("Press 'r' to restart.", width/2, height/2 +50);
    if (!gameActive) {
      for (int i = 0; i < scores.length; i++) {
        text(scores[i], width/2 -125, height/2 + 50 + 50*(i+1));
        text(dates[i], width/2 + 50, height/2 + 50 + 50*(i+1));
      }
    }
  }
  textSize(12);
  fill(0,0,0,150);
  text("by slyfox", 30, height - 5);
}
