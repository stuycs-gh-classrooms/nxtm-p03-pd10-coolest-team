int NUM_ORBS = 10; //<>//
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
int DRAGF = 4;
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
  earth = null;
}


void draw()
{
  background(255);
  displayMode();
  for (int o=0; o < orbCount; o++) {
    orbs[o].display();
  }
}

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
    } else if (mode == 1) {
      if (i == 0) {
        orbs[i] = new FixedOrb(width/2, height/2, random(10, MAX_SIZE), random(10, 100));
      } else {
        float x = random(0, width);
        float y = random(0, height);
        float s = random(10, 100);
        orbs[i] = new Orb(x, y, random(10, MAX_SIZE), s);
      }
    } else if (mode == 2) {
      float s = random(10, 100);
      orbs[i] = new Orb(50, 75+60*i, random(10, MAX_SIZE), s);
    }
  }
}

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
}

void applySprings()
{
  for (int i = 0; i < orbCount - 1; i++) {
    PVector force = orbs[i].getSpring(orbs[i+1], SPRING_LENGTH, SPRING_K);

    orbs[i].applyForce(force);

    PVector opposite = force.copy();
    opposite.mult(-1);
    orbs[i+1].applyForce(opposite);
  }
}

void addOrb()
{
  Orb[] copy = new Orb[orbCount+1];
  arrayCopy(orbs, copy);

  copy[orbCount] = new Orb();

  orbs = copy;
  orbCount++;
}

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
  }
  if (key == '=' || key == '+') {
    addOrb();
  }
}

void displayMode()
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
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
}
