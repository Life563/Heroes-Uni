class Members {
  String name;
  float maxHealth;
  float currentHealth;
  int numFrames = 4;  // The number of frames in the animation
  int currentFrame = 0;
  int animate = millis();
  int attack;
  int defense;
  int tempDefense; //Used to know how many more hits a player can take while blocking
  int speed;
  //Used to show what stats were before level up
  int oldAttack; 
  int oldDefense;
  int oldSpeed;
  float oldHealth;
  int killCount; //Used for leveling up
  boolean selected; //Used to draw outline
  boolean hit; //Used to tell if the player has been hit
  boolean canBlock; //Used to block opponents attack
  boolean special; //Used tell if the character can use their special
  boolean CanAttack; //Used tell if the characteris allowed to attack
  //Arrays to store frames for animations
  PImage main[] = new PImage[numFrames]; 
  PImage outline[] = new PImage[numFrames]; 
  PImage shown[] = new PImage[numFrames]; 
  PVector pos; //Current Screen Position

  Members(String theName, PVector v) {
    maxHealth = (int) random(15, 21);
    currentHealth = maxHealth;
    attack = (int) random(3, 6);
    defense = (int) random(2, 6);
    speed = (int) random(5, 20);
    pos = v;
    name = theName;
    CanAttack = true;
    special = true;
    //Loads all the frames for the animations
    for (int i = 0; i < numFrames; i++) {
      String imageName = "" + name + i + ".png";
      main[i] = loadImage(imageName);
      imageName = "" + name + "Outline" + i + ".png";
      outline[i] = loadImage(imageName);
    }
  }

  void drawChar() { 
    /*
    Checks the name of the character and will draw the character based on the name.
     Also checks if the character has been selected and will draw an image of the
     character with an outline to show it has been selected.
     */
    if (hit) {
      image(loadImage("" + name + "Hit.png"), 200, 500);
    } else {
      if (millis() >= animate + 125) {
        currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
        animate = millis();
      }
      if (selected) 
        shown = outline;
      else
        shown = main;
      if (minigameGo) {
        image(shown[(currentFrame % numFrames)], 200, 500);
        fill(255, 0, 0);
        rect(220, 480, 100, 10);
        fill(0, 255, 0);
        rect(220, 480, (100.0*(currentHealth/maxHealth)), 10.0);
      } else {
        image(shown[(currentFrame % numFrames)], pos.x, pos.y);
        if (MODE != MENU && MODE != INFO && MODE != GAME_OVER) {
          //Health Bar
          fill(255, 0, 0);
          rect(pos.x+20, pos.y-20, 100, 10);
          fill(0, 255, 0);
          rect(pos.x+20, pos.y-20, (100.0*(currentHealth/maxHealth)), 10.0);
        }
      }
    }
  }

  void doSpecial() {
    //Calls the special attack, depending on the character depends on the special
    if (name.equals("Mage")) {
      for (Members m : team) {
        float temp = m.currentHealth + attack;
        if ( temp < maxHealth) { //Can't add more health than the max health
          m.currentHealth += attack; //Increases friendly character health by attack amount
        } else {
          m.currentHealth = m.maxHealth;
        }
        selectedEnemy = null;
      }
    } else if (name.equals("Assassin")) {
      selectedEnemy.currentHealth -= attack*2; //Deals a guarenteed critical hit on opponent
    } else if (name.equals("Warrior")) {
      //Will attack 2 times on random targets
      int count = 0;
      while (count < 2) {
        selectedEnemy = opp.get((int) random(0, opp.size()));
        selectedEnemy.currentHealth -= attack;  
        count++;
      }
      selectedEnemy.currentHealth -= attack*2; //Will change
    } else if (name.equals("Archer")) {
      for (Enemy e : opp) {
        e.currentHealth -= attack; //Deals damage to every enemy on the field
      }
    }
  }

  boolean levelUp() {
    //If the character has made 3 kills, they will level up.
    if (killCount % 3 == 0) {
      oldAttack = attack;
      oldDefense = defense;
      oldSpeed = speed;
      oldHealth = maxHealth;
      int addHealth = (int) random(1, 4);
      attack += (int) random(1, 4);
      defense += (int) random(1, 4);
      speed += (int) random(1, 4);
      maxHealth += addHealth;
      currentHealth += addHealth;
      return true;
    }
    return false;
  }
}