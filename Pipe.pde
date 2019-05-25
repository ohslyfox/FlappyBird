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
  
  public Pipe(PVector startLoc) {
    pipeUpright = loadImage("pipe.png");
    pipeUpsideDown = loadImage("pipe_upsidedown.png");
    velocity = new PVector(-3, 0);
    newPipe(startLoc); 
  }
  
  private void newPipe(PVector startLoc) {
    location = new PVector(width + startLoc.x, 0);
    pipeHeight = (height/2) + (int)random(-height/3, height/3 -100);
  }
  
  public boolean checkCollision(PVector input) {
    if (input.x+(BIRD_WIDTH) >= (this.location.x) &&  input.x+(BIRD_WIDTH) <= (this.location.x + pipeWidth)) {
      if (input.y <= (this.location.y + pipeHeight) || input.y+(BIRD_HEIGHT) >= (this.location.y + pipeHeight + pipeGap)) {
        return true;
      }
    }
    return false;
  }
  
  public boolean checkScored(PVector input) {
    if (input.x+(BIRD_WIDTH) >= (this.location.x+pipeWidth)) {
      if (input.y > (this.location.y + pipeHeight) && input.y+(BIRD_HEIGHT) < (this.location.y + pipeHeight + pipeGap)) {
        return true;
      }
    }
    return false;
  }
  
  public void scroll() {
    this.location.x += this.velocity.x;
  }
  
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
  
  public PVector getLocation() {
    return this.location;
  }
  
  public void display() {
    this.bound();
    fill(255);
    //rect(location.x, location.y, pipeWidth, pipeHeight);
    //rect(location.x, location.y+pipeHeight+pipeGap, pipeWidth, height - (location.y+pipeHeight+pipeGap));
    image(pipeUpsideDown, location.x, location.y - (720-pipeHeight));
    image(pipeUpright, location.x, location.y+pipeHeight+pipeGap);
    
  }
}
