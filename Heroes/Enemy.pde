class Enemy {
  String name;
  float maxHealth;
  float currentHealth;  
  int currentFrame;
  int animate = millis();
  int attack;
  int speed;
  boolean hit; //Used to tell if the player has been hit
  boolean selected; //Used to draw outline
  boolean CanAttack; //Used tell if the characteris allowed to attack
  PVector pos;  //Current screen position
  PImage main[] = new PImage[4]; //Animation with no outline
  PImage outline[] = new PImage[4];  //Animation with outline
  PImage shown[] = new PImage[4]; //Current Animation shown

  Enemy(PVector p, String n) {
    name = n;
    if (name == "Boss") {
      attack = 4;
      maxHealth = bossHealth;
    } else {
      maxHealth = (int) random(10, 15);
      attack = 3;
    }
    currentHealth = maxHealth;
    speed = (int) random(5, 20);
    pos = p;
    CanAttack = true;
    for (int i = 0; i < 4; i++) {
      String imageName = "" + name + i + ".png";
      main[i] = loadImage(imageName);
      imageName = "" + name + "Outline" + + i + ".png";
      outline[i] = loadImage(imageName);
    }
  }

  void drawEnemy() {
    /*
    Checks the name of the enemy and will draw their image. Also checks if a character has been selected, and if
     so it will draw an outlined version instead.
     */
    if (hit) {
      image(loadImage("" + name + "Hit.png"), pos.x, pos.y);
    } else {
      if (millis() >= animate + 125) {
        currentFrame = (currentFrame+1) % 4;  // Use % to cycle through frames
        animate = millis();
      }
      if (selected) 
        shown = outline;
      else 
      shown = main;
      if (minigameGo) {
        image(shown[(currentFrame % 4)], 1250, 500);
        //Health Bar
        fill(255, 0, 0);
        rect(1280, 480, 100, 10);
        fill(0, 255, 0);
        rect(1280, 480, (100.0*(currentHealth/maxHealth)), 10);
      } else {
        image(shown[(currentFrame % 4)], pos.x, pos.y);
        //Health Bar
        fill(255, 0, 0);
        rect(pos.x+30, pos.y-20, 100, 10);
        fill(0, 255, 0);
        rect(pos.x+30, pos.y-20, (100.0*(currentHealth/maxHealth)), 10);
      }
    }
  }
}