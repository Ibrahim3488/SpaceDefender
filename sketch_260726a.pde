
Spaceship ship;                          // the player
ArrayList<Bullet>    bullets;            // ARRAY (list) of all bullets
ArrayList<Meteorite> meteorites;         // ARRAY (list) of all meteorites

int   score = 0;
int   lives = 3;
boolean gameOver = false;
int   spawnTimer = 0;                     // frames until next meteorite

void setup() {
  size(600, 700);
  ship = new Spaceship(width/2, height - 60);
  bullets    = new ArrayList<Bullet>();
  meteorites = new ArrayList<Meteorite>();
}

void draw() {
  drawBackground();

  if (gameOver) {
    showGameOver();
    return;
  }

  // ---- SPAWN new meteorites over time ----
  spawnTimer--;
  if (spawnTimer <= 0) {
    float x = random(40, width - 40);
    meteorites.add(new Meteorite(x, -40));
    spawnTimer = int(random(35, 70));     // next spawn delay
  }

  // ---- UPDATE + DRAW the ship ----
  ship.update();
  ship.display();

  // ---- UPDATE + DRAW all BULLETS (loop over the array) ----
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
    if (b.offScreen()) {
      bullets.remove(i);                  // clean up bullets that left the screen
    }
  }

  // ---- UPDATE + DRAW all METEORITES (loop over the array) ----
  for (int i = meteorites.size() - 1; i >= 0; i--) {
    Meteorite m = meteorites.get(i);
    m.update();
    m.display();

    // meteorite reached the bottom -> lose a life
    if (m.y - m.r > height) {
      meteorites.remove(i);
      lives--;
      if (lives <= 0) gameOver = true;
      continue;
    }

    // meteorite hits the ship -> lose a life
    if (m.hits(ship.x, ship.y, ship.r)) {
      meteorites.remove(i);
      lives--;
      if (lives <= 0) gameOver = true;
      continue;
    }
  }

  // ---- COLLISION: every bullet vs every meteorite (nested array loops) ----
  for (int i = meteorites.size() - 1; i >= 0; i--) {
    Meteorite m = meteorites.get(i);
    for (int j = bullets.size() - 1; j >= 0; j--) {
      Bullet b = bullets.get(j);
      if (m.hits(b.x, b.y, 3)) {
        meteorites.remove(i);
        bullets.remove(j);
        score += 10;
        break;                            // meteorite gone, stop checking it
      }
    }
  }

  drawHUD();
}

void drawBackground() {
  background(8, 10, 30);
  fill(255, 255, 255, 90);
  noStroke();
  // deterministic "stars" using a fixed seed so they don't flicker
  randomSeed(42);
  for (int i = 0; i < 120; i++) {
    float sx = random(width);
    float sy = random(height);
    float s  = random(1, 3);
    ellipse(sx, sy, s, s);
  }
  randomSeed(millis());                    // release the seed again
}

void drawHUD() {
  fill(255);
  textSize(18);
  textAlign(LEFT, TOP);
  text("Score: " + score, 12, 10);
  textAlign(RIGHT, TOP);
  text("Lives: " + lives, width - 12, 10);
}

void showGameOver() {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(44);
  text("GAME OVER", width/2, height/2 - 30);
  textSize(22);
  text("Final Score: " + score, width/2, height/2 + 20);
  textSize(16);
  text("Press R to play again", width/2, height/2 + 60);
}


//  INPUT HANDLING

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT)  ship.movingLeft  = true;
    if (keyCode == RIGHT) ship.movingRight = true;
  } else {
    if (key == ' ' && !gameOver) {
      // fire a bullet from the tip of the ship
      bullets.add(new Bullet(ship.x, ship.y - ship.r));
    }
    if (key == 'r' || key == 'R') {
      restart();
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT)  ship.movingLeft  = false;
    if (keyCode == RIGHT) ship.movingRight = false;
  }
}

void restart() {
  score = 0;
  lives = 3;
  gameOver = false;
  bullets.clear();
  meteorites.clear();
  ship = new Spaceship(width/2, height - 60);
}

class Spaceship {
  float x, y;          // position
  float r = 22;        // approximate radius (for collisions)
  float speed = 6;
  boolean movingLeft, movingRight;

  Spaceship(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    if (movingLeft)  x -= speed;
    if (movingRight) x += speed;
    x = constrain(x, r, width - r);        // keep the ship on screen
  }

  void display() {
    // TRANSFORMATION: move the coordinate system to the ship 
    pushMatrix();
    translate(x, y);

    // Animated thruster flame (also uses transformation via translate)
    float flame = 10 + 6 * sin(frameCount * 0.6);
    noStroke();
    fill(255, 140, 0, 200);
    triangle(-6, 18, 6, 18, 0, 18 + flame);

    // Ship body (a triangle pointing up)
    fill(120, 200, 255);
    stroke(255);
    strokeWeight(2);
    triangle(0, -r, -18, 18, 18, 18);

    // Cockpit
    noStroke();
    fill(30, 60, 120);
    ellipse(0, 0, 14, 14);

    popMatrix();
  }
}



//  CLASS 2: Bullet  (fired by the ship's cannon)

class Bullet {
  float x, y;
  float speed = 10;

  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    y -= speed;                            // travel upward
  }

  void display() {
    noStroke();
    fill(255, 240, 120);
    ellipse(x, y, 6, 12);
  }

  boolean offScreen() {
    return y < -10;
  }
}



//  CLASS 3: Meteorite  (rotating falling rock)

class Meteorite {
  float x, y;          // position
  float r;             // radius
  float speed;         // falling speed
  float angle;         // current rotation angle
  float spin;          // rotation speed
  int   sides;         // number of jagged corners
  float[] offsets;     // ARRAY: random radius offset per corner (jagged look)

  Meteorite(float x, float y) {
    this.x = x;
    this.y = y;
    this.r     = random(20, 38);
    this.speed = random(1.5, 3.5);
    this.angle = random(TWO_PI);
    this.spin  = random(-0.05, 0.05);
    this.sides = int(random(7, 11));

    // Build a jagged rock shape by storing a random offset for each corner
    offsets = new float[sides];
    for (int i = 0; i < sides; i++) {
      offsets[i] = random(0.7, 1.15);      // multiplier on the base radius
    }
  }

  void update() {
    y     += speed;
    angle += spin;                         // keep rotating
  }

  void display() {
    // ---- TRANSFORMATION: translate to the rock, then rotate it ----
    pushMatrix();
    translate(x, y);
    rotate(angle);

    fill(150, 130, 110);
    stroke(90, 75, 60);
    strokeWeight(2);

    // Draw the jagged polygon using the ARRAY of corner offsets
    beginShape();
    for (int i = 0; i < sides; i++) {
      float a  = TWO_PI / sides * i;
      float rr = r * offsets[i];
      float vx = cos(a) * rr;
      float vy = sin(a) * rr;
      vertex(vx, vy);
    }
    endShape(CLOSE);

    // a couple of craters for detail
    noStroke();
    fill(110, 95, 80);
    ellipse(-r*0.2, -r*0.1, r*0.3, r*0.3);
    ellipse( r*0.25, r*0.2, r*0.2, r*0.2);

    popMatrix();
  }

  // circle-based collision test against a point/small object
  boolean hits(float px, float py, float pr) {
    float d = dist(px, py, x, y);
    return d < r + pr;
  }
}
