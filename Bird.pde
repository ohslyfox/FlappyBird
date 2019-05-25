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
  
  public Bird() {
    birdImage = loadImage("bird.png");
    location = new PVector(width/8, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    score = 0;
    alive = true;
  }
  
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
  
    
  public PVector getLocation() {
    return this.location; 
  }
  
  public void hop() {
    if (acceleration.y == 0) {
      acceleration.y = .1;
    }
    velocity.set(new PVector(0,0));
    velocity.add(new PVector(0, -4.6));
  }
  
  public void score() {
    score += 1; 
  }
  
  public int getScore() {
    return this.score;
  }
  
  public void kill() {
    if (gameActive) {
      saveData();
    }
    gameActive = false;
    this.alive = false;
  }
  
  public boolean isAlive() {
    return this.alive;
  }
  
  public void display() {
    this.move();
    fill(255);
    
    // rotate and draw
    pushMatrix();
    translate(location.x+(BIRD_WIDTH/2), location.y+(BIRD_HEIGHT/2));
    if (gameActive || !bird.isAlive()) { // allows for no rotation before game start
      rotate(map(velocity.y, -4.5, 12.5, -PI/2, PI/2));
    }
    image(birdImage, -BIRD_WIDTH/2, -BIRD_HEIGHT/2);
    popMatrix();
  }
}
