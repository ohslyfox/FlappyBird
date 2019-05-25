/**
 * @author Patrick Finger
 * @date 05/22/2019
 * @brief implements the scrolling background
 */
class Background {
  private PImage backgroundImage;
  private PVector firstL, secondL, velocity;
  private int imageWidth;
  
  public Background() {
    if ((int)random(0,2) == 0) {
      backgroundImage = loadImage("background_scroll.png");
    }
    else {
      backgroundImage = loadImage("background_scroll_night.png");
    }
    imageWidth = backgroundImage.width;
    firstL = new PVector(0,0);
    secondL = new PVector(imageWidth,0);
    velocity = new PVector(-2,0);
  }
  
  public void scroll() {
    firstL.add(velocity);
    secondL.add(velocity);
    //move image that has surpassed 
    //screenlength to the end of the next image
    if (firstL.x <= -imageWidth) {
      firstL.x = imageWidth;
    }
    if (secondL.x <= -imageWidth) {
      secondL.x = imageWidth;
    }
  }
  
  public void display() {
    image(backgroundImage, firstL.x, firstL.y);
    image(backgroundImage, secondL.x, secondL.y);
  }
}
