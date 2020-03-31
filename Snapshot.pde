class Snapshot{
  public Snapshot(){
    this.savedBalls = new Ball[16];
    this.numPocketed = 0;
  }
  
  public void take(){
    for(int i = 0; i < 16; i++)
      savedBalls[i] = new Ball(balls[i].position.x, balls[i].position.y, balls[i].col, balls[i].bounced, balls[i].moved, balls[i].pocketed);
    numPocketed = table.numPocketed;
  }
  
  public void restore(){
    for(int i = 0; i < 16; i++)
      balls[i] = new Ball(savedBalls[i].position.x, savedBalls[i].position.y, savedBalls[i].col, savedBalls[i].bounced, savedBalls[i].moved, savedBalls[i].pocketed);
    table.numPocketed = numPocketed;
  }
    
  private Ball[] savedBalls;
  private int numPocketed;
}
