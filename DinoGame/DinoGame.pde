//Globals
int nextConnectionNo = 1000;
int frameSpeed = 60;

//boolean showBestEachGen = false;
//int upToGen = 0;

boolean showNothing = false;
boolean cont = false;


//images
PImage dinoRun1;
PImage dinoRun2;
PImage dinoJump;
PImage dinoDuck;
PImage dinoDuck1;
PImage smallCactus;
PImage manySmallCactus;
PImage bigCactus;
PImage bird;
PImage bird1;
PImage dinoDead;


ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Ground> grounds = new ArrayList<Ground>();


int obstacleTimer = 0;
int minimumTimeBetweenObstacles = 60;
int randomAddition = 0;
int groundCounter = 0;
float speed = 10;
int flag = 0;

int groundHeight = 250;
int playerXpos = 150;

Dino d = new Dino();

ArrayList<Integer> obstacleHistory = new ArrayList<Integer>();
ArrayList<Integer> randomAdditionHistory = new ArrayList<Integer>();


//--------------------------------------------------------------------------------------------------------------------------------------------------

void setup() {

  frameRate(60);
  fullScreen();
  dinoRun1 = loadImage("dinorun0000.png");
  dinoRun2 = loadImage("dinorun0001.png");
  dinoJump = loadImage("dinoJump0000.png");
  dinoDuck = loadImage("dinoduck0000.png");
  dinoDuck1 = loadImage("dinoduck0001.png");
  smallCactus = loadImage("cactusSmall0000.png");
  bigCactus = loadImage("cactusBig0000.png");
  manySmallCactus = loadImage("cactusSmallMany0000.png");
  bird = loadImage("berd.png");
  bird1 = loadImage("berd2.png");
  
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------
void draw() {
  drawToScreen();
    if (!d.dead) {//if any players are alive then update them
      updateObstacles();
      d.update();
      d.show();//////////////////////////////////////////////////////////////////////////////////////
    } else {
      showObstaclesDead();
      d.showDead();
      if(cont)
      {
        resetObstacles();
        d.dead = false;
        d.score = 0;
        cont = false;
        d.show();
      }
      
    }
  }

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//writes info about the current player
void writeInfo() {
  fill(200);
  textAlign(LEFT);
  textSize(40);
    text("Score: " + d.score, 30 , height - 30);
     textAlign(RIGHT);
     text("HiScore: "+d.HiScore, width -40, height -30);
    textAlign(CENTER);
    textSize(30);
     if(d.dead)
    text("Press Y to play again!", width/2, height-30);
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------
//draws the display screen
void drawToScreen() {
    background(250); 
    stroke(0);
    strokeWeight(2);
    line(0, height - groundHeight - 30, width, height - groundHeight - 30);
    writeInfo();
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------
void keyPressed() {
  switch(key) {
  case 'y':
          if(d.dead==true)
            {d.duck=false;
            cont = true;}
            break;
  case CODED://any of the arrow keys
    switch(keyCode) {
    case DOWN:  if(!d.dead)
                {if(d.posY>0)
                {d.gravity = 3;
                d.duck=true;}
                else if(d.posY==0 && d.duck)
                {if(d.DuckState<=60)
                  d.DuckState += 30;}
                else if(d.posY==0)
                {d.duck=true;
                }}break;
                
    case UP: if(!d.dead)
              {d.jump(true);
               d.duck = false;
               d.DuckState = 30;}
             break;
      }
      break;
    }
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------
//called every frame
void updateObstacles() {
  obstacleTimer ++;
  speed += 0.002;
  if (obstacleTimer > minimumTimeBetweenObstacles + randomAddition) { //if the obstacle timer is high enough then add a new obstacle
    addObstacle();
  }
  groundCounter ++;
  if (groundCounter> 10) { //every 10 frames add a ground bit
    groundCounter =0;
    grounds.add(new Ground());
  }

  moveObstacles();//move everything
  showObstacles();
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------
//moves obstacles to the left based on the speed of the game 
void moveObstacles() {
  println(speed);
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).move(speed);
    if (obstacles.get(i).posX < -playerXpos) { 
      obstacles.remove(i);
      i--;
    }
  }

  for (int i = 0; i< birds.size(); i++) {
    birds.get(i).move(speed);
    if (birds.get(i).posX < -playerXpos) {
      birds.remove(i);
      i--;
    }
  }
  for (int i = 0; i < grounds.size(); i++) {
    grounds.get(i).move(speed);
    if (grounds.get(i).posX < -playerXpos) {
      grounds.remove(i);
      i--;
    }
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------
//every so often add an obstacle 
void addObstacle() {
  int tempInt;
  if (d.score>300 && random(1) < 0.15) { // 15% of the time add a bird/////////////////////
    tempInt = floor(random(3));
    Bird temp = new Bird(tempInt);//floor(random(3)));
    birds.add(temp);
  } else {//otherwise add a cactus
    if(d.score<=90)
    {
      tempInt = 0;
    }
    else if(d.score<=190 && d.score>90)
    {
      if(flag==0)
      {
          tempInt = 1;
          flag = 1;
      }
      else
      tempInt = floor(random(1.9));
    }
    else
    {if(flag==1)
      {
          tempInt = 2;
          flag = 0;
      }
      else
      tempInt = floor(random(3));
    }
    Obstacle temp = new Obstacle(tempInt);//floor(random(3)));
    obstacles.add(temp);
    tempInt+=3;
  }
  obstacleHistory.add(tempInt);

  randomAddition = floor(random(50));
  randomAdditionHistory.add(randomAddition);
  obstacleTimer = 0;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------
//what do you think this does?
void showObstacles() {
  for (int i = 0; i< grounds.size(); i++) {
    grounds.get(i).show();
  }
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).show();
  }

  for (int i = 0; i< birds.size(); i++) {
    birds.get(i).show();
  }
}

//what do you think this does?
void showObstaclesDead() {
  for (int i = 0; i< grounds.size(); i++) {
    grounds.get(i).show();
  }
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).show();
  }

  for (int i = 0; i< birds.size(); i++) {
    birds.get(i).showDead();
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------
//resets all the obstacles after every dino has died
void resetObstacles() {
  randomAdditionHistory = new ArrayList<Integer>();
  obstacleHistory = new ArrayList<Integer>();

  obstacles = new ArrayList<Obstacle>();
  birds = new ArrayList<Bird>();
  obstacleTimer = 0;
  randomAddition = 0;
  groundCounter = 0;
  speed = 10;
}
