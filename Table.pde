class Table {
  
  public Table(){
    pockets = new Pocket[6];
    
    pockets[0] = new Pocket(55, 55);
    pockets[1] = new Pocket(450, 50);
    pockets[2] = new Pocket(845, 55);
    pockets[3] = new Pocket(845, 445);
    pockets[4] = new Pocket(450, 450);
    pockets[5] = new Pocket(55, 445);
    
    numPocketed = 0;
  }
  
  public void draw() {
    background(0xff664422);
    
    fill(225);
    noStroke();
    for(int x = 150; x < 800; x += 100){
      if(x == 450)
        continue;
      circle(x, 25, 6);
      circle(x, 475, 6);
    }
    
    for(int y = 150; y < 400; y += 100){
      circle(25, y, 6);
      circle(875, y, 6);
    }
    
    fill(0xff037a03);
    strokeWeight(3);
    stroke(0xff331100, 100);
    rect(50, 50, 800, 400);
    
    noStroke();
    fill(255, 10);
    ellipse(450, 250, 1000, 450);
    fill(255, 3);
    ellipse(450, 250, 500, 200);
    fill(255, 3);
    ellipse(450, 250, 300, 120);
    fill(255, 2);
    ellipse(450, 250, 100, 40);
    
    for(Pocket pocket : pockets)
      pocket.draw();
      
    fill(0xff0a0500, 100);
    noStroke();
    arc(75, 25, 28, 28, HALF_PI, PI + HALF_PI, OPEN);
    rect(75, 11, 350, 28);
    arc(425, 25, 28, 28, -HALF_PI, HALF_PI, OPEN);
  }
  
  public void removePocketed(){
    for(Pocket pocket : pockets){
      for(Ball ball : balls){
        
        if(pocket.isBallIn(ball)){
          putAside(ball);
          ball.pocketed = true;
          numPocketed++;
        }
      }
    }
  }
  
  private void putAside(Ball ball){
    ball.position = new PVector(75 + numPocketed * 25, 25);
    ball.velocity = new PVector(0, 0);
  }

  private Pocket[] pockets; //top left corner at index 0, then clockwise
  private int numPocketed;
}

class Pocket {
  public Pocket(int x, int y){
    this.position = new PVector(x, y);
  }
  
  public boolean isBallIn(Ball ball) {
    return position.dist(ball.position) < 18;
  }
  
  public void draw(){
    stroke(50);
    strokeWeight(1.5);
    fill(0xff553311);
    circle(position.x, position.y, 40);
    fill(0xff331100);
    circle(position.x, position.y, 35);
  }
  
  private PVector position;
}
