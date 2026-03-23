int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int SPRING = 3;
int DRAGF = 4; //<>//
int COLLIDE = 5;
int COMBINATION = 6;
boolean[] toggles = new boolean[7];
String[] modes = {"Moving", "Bounce", "Gravity", "Spring", "Drag", "Collide", "Combination"};

FixedOrb earth;
Orb[] orbs;
int orbCount;


void setup()
{
  size(600, 600);
  //Part 3: create earth to simulate gravity
  earth = null;
}//setup


void draw()
{
  background(255);
  displayMode();
  for (int o=0; o < orbCount; o++) {
    orbs[o].display();
  }
}//draw


/**
 makeOrbs(boolean ordered)
 
 Set orbCount to NUM_ORBS
 Initialize and create orbCount Orbs in orbs.
 All orbs should have random mass and size.
 The first orb should be a FixedOrb
 If ordered is true:
 The orbs should be spaced SPRING_LENGTH distance
 apart along the middle of the screen.
 If ordered is false:
 The orbs should be positioned radomly.
 
 Each orb will be "connected" to its neighbors in the array.
 */
void makeOrbs(int mode)
{
  orbCount = NUM_ORBS;
  orbs = new Orb[orbCount];
  for (int i = 0; i < orbCount; i++) {
    if (mode == 0) {
      if (i == 0) {
        orbs[i] = new FixedOrb();
      } else {
        orbs[i] = new Orb();
      }
    }
    else if (mode == 1){ //alter for gravity
      float x = random(0, width/2);
      if (i == 0) {
        orbs[i] = new FixedOrb(width/2, height/2, random(10, MAX_SIZE), random(10, 100));
      } else {
        float s = random(10, 100);
        orbs[i] = new Orb(x+s/2+i*SPRING_LENGTH, height/2, random(10, MAX_SIZE), s);
      }
    }
    else if (mode == 2){ //alter for drag
      float x = random(0, width/2);
        float s = random(10, 100);
        orbs[i] = new Orb(x+s/2+i*SPRING_LENGTH, height/2, random(10, MAX_SIZE), s);
    }
  }
}//makeOrbs


/**
 drawSpring(Orb o0, Orb o1)
 
 Draw a line between the two Orbs.
 Line color should change as follows:
 red: The spring is stretched.
 green: The spring is compressed.
 black: The spring is at its normal length
 */
void drawSpring(Orb o0, Orb o1)
{
  strokeWeight(5);
  if (o0.center.dist(o1.center) == SPRING_LENGTH) {
    stroke(0);
  } else if (o0.center.dist(o1.center) > SPRING_LENGTH) {
    stroke(255, 0, 0);
  } else {
    stroke(0, 255, 0);
  }
  line(o0.center.x, o0.center.y, o1.center.x, o1.center.y);
}//drawSpring


/**
 applySprings()
 
 FIRST: Fill in getSpring in the Orb class.
 
 THEN:
 Go through the Orbs array and apply the spring
 force correctly for each orb. We will consider every
 orb as being "connected" via a spring to is
 neighboring orbs in the array.
 */
void applySprings()
{
  for (int i = 0; i < orbCount - 1; i++) {
    PVector force = orbs[i].getSpring(orbs[i+1], SPRING_LENGTH, SPRING_K);

    orbs[i].applyForce(force);

    PVector opposite = force.copy();
    opposite.mult(-1);
    orbs[i+1].applyForce(opposite);
  }
}//applySprings


/**
 addOrb()
 
 Add an orb to the arry of orbs.
 
 If the array of orbs is full, make a
 new, larger array that contains all
 the current orbs and the new one.
 (check out arrayCopy() to help)
 */
void addOrb()
{
  Orb[] copy = new Orb[orbCount+1];
  arrayCopy(orbs, copy);

  copy[orbCount] = new Orb();

  orbs = copy;
  orbCount++;
}//addOrb


/**
 keyPressed()
 
 Toggle the various modes on and off
 Use 1 and 2 to setup model.
 Use - and + to add/remove orbs.
 */
void keyPressed()
{
  if (key == ' ') {
    toggles[MOVING]  = !toggles[MOVING];
  }
    if (key == 'b') {
    toggles[BOUNCE]  = !toggles[BOUNCE];
  }
  if (key == '1') {
    toggles[GRAVITY] = !toggles[GRAVITY];
    makeOrbs(1);
  }
  if (key == '2') {
    toggles[SPRING]   = !toggles[SPRING];
    makeOrbs(0);
  }
  if (key == '3') {
    toggles[DRAGF]   = !toggles[DRAGF];
    makeOrbs(2);
  }
  if (key == '4') {
    toggles[COLLIDE]   = !toggles[COLLIDE];
    makeOrbs(1);
  }
  if (key == '5') {
    // Do later toggles[COMBINATION]   = !toggles[DRAGF];
  }

  if (key == '-') {
    //Part 4: Write code to remove an orb from the array
  }//removal
  if (key == '=' || key == '+') {
    //Part 4: Write addOrb() below
    addOrb();
  }//addition
}//keyPressed



void displayMode()
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }
}//display
