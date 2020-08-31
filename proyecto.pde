
float x = 0;
float y = 0;
float xn = 0;
float yn = 0;
float r = 0;
float angleLeaf = 0;
boolean rotateLeaf = false;
int iterationsLeaf = 1000;
float branchLength = 200;
float angle = 10;
int branchDeepness = 6;
boolean showTree = true;
int strokeColor = 0;
float shrink = 0.9;
boolean rotateTree = false;
float treeRotationAngle = 0.0;
boolean fallingLeaves = false;
float offset = 0;
float offsetX = 0;
float oscillation = 0;
void setup() {
  size(1920, 1000, P3D);
  colorMode(HSB, 100);
  background(0);
}

void draw() {

  if (!fallingLeaves) {
    angle = map(mouseX, 0, width, 5, 100);
    branchDeepness = int(map(mouseY, 0, height, 2, 10));
  }


  if (showTree) {
    background(0);
    drawTree(width/2, height-int(branchLength));
  } else {
    showBigLeaf();
  }
  if (rotateLeaf) {
    angleLeaf+=0.01;
  }
}


void drawTree(int rootX, int rootY) {

  strokeWeight(2);
  pushMatrix();
  translate(rootX, rootY);
  if (rotateTree) {
    background(0);
    rotateY(treeRotationAngle);
    treeRotationAngle+=0.005;
  }
  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = branchLength;
  line(x1, y1, x2, y2);
  drawBranches(x2, y2, branchLength, 0, branchDeepness);
  popMatrix();
}

void drawBranches(float x, float y, float branchLength, float rotation, int numBranches) {
  float  x2 = x + branchLength*sin(rotation*PI/180);
  float y2 = y - branchLength*cos(rotation*PI/180);
  strokeColor = int(map(y, 0, -height, 0, 100));
  stroke(strokeColor, 100, 100);
  line(x, y, x2, y2);
  if (numBranches==0) {
    drawLeaf(int(x2), int(y2), 10, -10, -rotation);
  }
  if (numBranches > 0) {
    drawBranches(x2, y2, branchLength*shrink, rotation -angle, numBranches-1);
    drawBranches(x2, y2, branchLength*shrink, rotation +angle, numBranches-1);
  }
}


void drawLeaf(int rootX, int rootY, int scaleX, int scaleY, float rotationX) {

  pushMatrix();
  if (fallingLeaves) {
    offsetX = sin(oscillation)*10;
  }
  translate(rootX + offsetX, rootY+offset);
  rotateZ(rotationX);
  if (rotateLeaf) {
    rotateY(angleLeaf);
  }
  for (int i = 0; i <iterationsLeaf; i++) {
    if (!showTree|| fallingLeaves) {
      strokeColor = int(map((yn*scaleY+rootY)*xn, -height, height, 0, 100));
      stroke(strokeColor, 100, 100);
    }
    point(xn*scaleX, yn*scaleY);

    r = random(101);
    xn = x;
    yn = y;

    if (r<1) {
      x = 0;
      y = 0.16 *yn;
    } else if (r<86) {
      x = 0.85 * xn + 0.04 * yn;
      y = -0.04 * xn + 0.85 * yn + 1.6;
    } else if (r<93) {
      x = 0.20 * xn - 0.26 * yn;
      y = 0.23 * xn + 0.22 * yn + 1.6;
    } else {
      x = -0.15 * xn + 0.28 * yn;
      y = 0.26 * xn + 0.24 * yn + 0.44;
    }
  }
  if (fallingLeaves) {
    offset += 0.2;
    oscillation += random(0.003, 0.008);
  }
  popMatrix();
}

void showBigLeaf() {
  drawLeaf(width/7, height, 300, -135, PI/6);
}


void keyPressed() {
  if (key == 'r') {
    rotateLeaf = !rotateLeaf;
  } else if (key == 'l') {
    background(0);
    offset = offsetX = 0;
    rotateLeaf = false;
    fallingLeaves = false;
    showTree = !showTree;
  } else if (key == 't') {
    rotateTree = !rotateTree;
  } 
}

void mousePressed() {
  offset = 0;

  fallingLeaves = !fallingLeaves;
}
