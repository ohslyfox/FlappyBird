/**
 * @author Patrick Finger
 * @date 05/22/2019
 * @brief implements the pipe objects
 */
private static int pipeGap = 150;
private static int pipeWidth = 102;

class Pipe {
  private PImage pipeUpright, pipeUpsideDown;
  private PVector location, velocity;
  private int pipeHeight;
  
  /**
   * Default constructor, sets the images and location
   * of the pipe
   * @param startLoc, the starting location of the pipe
   */
  public Pipe(PVector startLoc) {
    pipeUpright = loadImage("pipe.png");
    pipeUpsideDown = loadImage("pipe_upsidedown.png");
    velocity = new PVector(-3, 0);
    newPipe(startLoc); 
  }
  
  /**
   * Replaces the pipe to the new location and randomizes
   * the pipe height
   * @param startLoc, the starting locaiton of the pipe
   */
  private void newPipe(PVector startLoc) {
    location = new PVector(width + startLoc.x, 0);
    pipeHeight = (height/2) + (int)random(-height/3, height/3 -100);
  }
  
  /**
   * Checks if there was a collision with the input vector
   * and the pipe location vector
   * @param input, the input vector
   * @return boolean, whether a collision was detected
   */
  public boolean checkCollision(PVector input) {
    if (input.x+(BIRD_WIDTH) >= (this.location.x) &&  input.x <= (this.location.x + pipeWidth)) {
      if (input.y <= (this.location.y + pipeHeight) || input.y+(BIRD_HEIGHT) >= (this.location.y + pipeHeight + pipeGap)) {
        return true;
      }
    }
    return false;
  }
  
  /**
   * Checks if there was a scored pipe detected with
   * the input vector and the pipe location vector
   * @param input, the input vector
   * @return boolean, whether a scoring was detected
   */
  public boolean checkScored(PVector input) {
    if (input.x >= (this.location.x+pipeWidth)) {
      if (input.y > (this.location.y + pipeHeight) && input.y+(BIRD_HEIGHT) < (this.location.y + pipeHeight + pipeGap)) {
        return true;
      }
    }
    return false;
  }
  
  /**
   * Scrolls the pipe
   */
  public void scroll() {
    this.location.x += this.velocity.x;
  }
  
  /**
   * Bounds the pipe to the game, detects if the pipe
   * has gone off screen and recreates it if it does
   */
  private void bound() {
    if (this.location.x < -(pipeWidth)) {
      newPipe(new PVector(width+100, 0));
      // move to next pipe for collision checking
      pipeIncrementer += 1;
      scoredPipe = false;
      if (pipeIncrementer > 4) {
        pipeIncrementer = 0;
      }
    }
  }
  
  /**
   * Gets the location of the pipe
   * @return location, the location vector of the pipe
   */
  public PVector getLocation() {
    return this.location;
  }
  
  /**
   * Handles the displaying of the pipe
   */
  public void display() {
    this.bound();
    //rect(location.x, location.y, pipeWidth, pipeHeight);
    //rect(location.x, location.y+pipeHeight+pipeGap, pipeWidth, height - (location.y+pipeHeight+pipeGap));
    image(pipeUpsideDown, location.x, location.y - (720-pipeHeight));
    image(pipeUpright, location.x, location.y+pipeHeight+pipeGap);
    
  }
}
