Table table;
Ball[] balls;
color[] ballColors = {0xfff0ebce,
                      0xfff0e000, 0xff0066ff,
                      0xffff3300, 0xff9933ff,
                      0xff000000, 0xff009933,
                      0xff990000, 0xffff6600,
                      0xfff0e000, 0xff0066ff,
                      0xffff3300, 0xff9933ff,
                      0xffff6600, 0xff009933,
                      0xff990000};

Snapshot snap;

int rebounds; //Not very clean, but very practical

void setup() {
  size(900, 500);
  table = new Table();
  balls = new Ball[16];
  initGame();
  balls[0].velocity = new PVector(random(18, 22), random(-0.1, 0.1));
}

void draw() {
  table.draw();
  
  for(Ball ball : balls)
    ball.draw();
  
  boolean changed = simStep();
  
  if(!changed){
    snap.take();
    
    float bestVx = 0;
    float bestVy = 0;
    float bestScore = Float.MIN_VALUE;
    
    for(int attempt = 0; attempt < 2000; attempt++){
      rebounds = 0;
      float vx = random(-8, 8);
      float vy = random(-8, 8);
      balls[0].velocity = new PVector(vx, vy); 
      
      while(simStep());
      
      int score = score();
      if(score > bestScore){
        bestScore = score;
        bestVx = vx;
        bestVy = vy;
      }
      
      snap.restore();
    }
    
    balls[0].velocity = new PVector(bestVx, bestVy);
  }
}

int score(){
  if(balls[0].pocketed) //white ball
    return -1;
  if(balls[5].pocketed){ //black ball
    if(table.numPocketed == 15) //black ball and all other balls entered, white ball didn't
      return Integer.MAX_VALUE;
    return -10;
  }
  
  // Better score if smaller total distance from balls to pockets
  //float totalDist = 0;
  //for(Ball ball : balls){
  //  if(ball.pocketed || ball == balls[0])
  //    continue;
  //    
  //  totalDist += distToClosestPocket(ball);
  //}
  
  //Penalize too many rebounds, which helps getting more "human"-looking shots
  return max(table.numPocketed * 5000 - rebounds * 500, 1);
  //return max(table.numPocketed * 5000 - totalDist - rebounds * 500, 1);
}

float distToClosestPocket(Ball ball){
  float dist = Float.MAX_VALUE;
  for(Pocket pocket : table.pockets){
    float d = PVector.dist(pocket.position, ball.position);
    if(d < dist)
      dist = d;
  }
  return dist;
}

void initGame() {
  int counter = 1;
  int apex_x = 650, apex_y = 250;
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j <= i; j++) {
      balls[counter] = new Ball(apex_x + i * 22, apex_y - i * 12 + j * 24, ballColors[counter]);
      counter++;
    }
  }
  
  balls[0] = new Ball(250, 250, ballColors[0]);
  
  snap = new Snapshot();
}

boolean simStep(){
  for(Ball ball : balls)
    if(!ball.pocketed)
      ball.simStep();
    
  table.removePocketed();
  
  boolean somethingChanged = false;
  
  for(Ball ball : balls){
    if(ball.moved || ball.bounced){
      somethingChanged = true;
      break;
    }
  }
  
  for(Ball ball : balls){
    ball.bounced = false;
    ball.moved = false;
  }
  
  return somethingChanged;
}
