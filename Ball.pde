final float ELASTICITY = 0.95;

class Ball{
  public Ball(float x, float y, color col){
    this(x, y, col, false, false, false);
  }
  
  public Ball(float x, float y, color col, boolean bounced, boolean moved, boolean pocketed){
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.col = col;
    this.bounced = bounced;
    this.moved = moved;
    this.pocketed = pocketed;
  }
  
  public void draw(){
    fill(col);
    stroke(50);
    strokeWeight(1);
    circle(position.x, position.y, 24);
    noStroke();
    fill(255, 100);
    circle(position.x - 5, position.y - 5, 5);
    fill(255, 50);
    circle(position.x - 5, position.y - 5, 9);
    fill(255, 15);
    arc(position.x, position.y, 24, 24, PI - 0.5 * QUARTER_PI, PI + HALF_PI + 0.5 * QUARTER_PI, PIE);
    arc(position.x - 8, position.y - 8, 24, 24, 0 - 0.5 * QUARTER_PI, HALF_PI + 0.5 * + QUARTER_PI, PIE);
    stroke(0);
  }
  
  public void simStep(){
    bounce();
    roll();
  }
  
  public void bounce(){
    //Bounce on border
    if(position.y < 50 + 12 || position.y > 450 - 12){
      velocity.y = -velocity.y * ELASTICITY;
      position.y += velocity.y;
      rebounds++;
    }
      
    if(position.x < 50 + 12 || position.x > 850 - 12){
      velocity.x = -velocity.x * ELASTICITY;
      position.x += velocity.x;
      rebounds++;
    }
    
    //Bounce on other balls
    for(Ball ball : balls){
      if(ball == this || ball == null){
        continue;
      }
        
      if(position.dist(ball.position) < 24 && !bounced){
        PVector pos = new PVector(position.x, position.y);
        PVector v = new PVector(velocity.x, velocity.y);
        
        PVector delta = pos.sub(ball.position);
        float d = delta.mag();
        PVector mtd = delta.mult(((24 + 24) - d)/ d);
        
        position.add(mtd.mult(0.05));
        ball.position.sub(mtd.mult(0.05));
        
        PVector impactV = v.sub(ball.velocity);
        float vn = impactV.dot(mtd.normalize());
        
        if(vn > 0.0f) break;
        
        float i = (-(1.0f + ELASTICITY) * vn) / 2;
        PVector impulse = mtd.normalize().mult(i);
        
        velocity =  velocity.add(impulse);
        ball.velocity = ball.velocity.sub(impulse);
        
        this.bounced = true;
        ball.bounced = true;
        
        rebounds += 2;
      }
    }
  }
  
  public void roll(){
    velocity.x = velocity.x * 0.991;
    velocity.y = velocity.y * 0.991;

    if(velocity.mag() > 0.15){
      position.add(velocity);
      moved = true;
    }else{
      moved = false;
    }
  }
  
  private PVector position;
  private PVector velocity;
  private color col;
  private boolean bounced;
  private boolean moved;
  private boolean pocketed;
}
