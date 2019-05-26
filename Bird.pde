/**
 * @author Patrick Finger
 * @date 05/22/2019
 * @brief implements the bird object
 */
class Bird {
  private PImage birdImage;
  private PVector location, velocity, acceleration;
  private int score;
  private boolean alive;
  
  /**
   * Default constructor, sets inital bird variables
   */
  public Bird() {
    birdImage = loadImage("bird.png");
    location = new PVector(width/8, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    score = 0;
    alive = true;
  }
  
  /**
   * Handles the vertical movement of the bird
   */
  private void move() {    
    //f = ma
    //a = f/1
    if (location.y < height+BIRD_HEIGHT) {
      location.add(velocity);
      velocity.add(acceleration);
    }
    else { // if bird falls out of frame
      this.kill();
    }
  }
  
  /**
   * Gets the current location of the bird
   * @return location, the vector location of the bird
   */
  public PVector getLocation() {
    return this.location; 
  }
  
  /**
   * Hop activity for the bird
   */
  public void hop() {
    if (acceleration.y == 0) {
      acceleration.y = .1;
    }
    velocity.set(new PVector(0,0));
    velocity.add(new PVector(0, -4.6));
  }
  
  /**
   * Increments the current score
   */
  public void score() {
    score += 1; 
  }
  
  /**
   * Gets the current score of the bird
   * @return score, the score of the bird
   */
  public int getScore() {
    return this.score;
  }
  
  /**
   * Kills the bird and saves the data
   */
  public void kill() {
    if (gameActive) {
      saveData();
    }
    gameActive = false;
    this.alive = false;
  }
  
  /**
   * Gets the living status of the bird
   * @return alive, the living status of the bird
   */
  public boolean isAlive() {
    return this.alive;
  }
  
  /**
   * Handles rotation and display of the bird
   */
  public void display() {
    // move the bird
    this.move();
  
    // rotate and draw the bird
    pushMatrix();
    translate(location.x+(BIRD_WIDTH/2), location.y+(BIRD_HEIGHT/2));
    if (gameActive || !bird.isAlive()) { // allows for no rotation before game start
      rotate(map(velocity.y, -4.5, 12.5, -PI/2, PI/2));
    }
    image(birdImage, -BIRD_WIDTH/2, -BIRD_HEIGHT/2);
    popMatrix();
  }
}
